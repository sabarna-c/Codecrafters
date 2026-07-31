-- =====================================================
-- ALUMNICONNECT+ PRODUCTION SUPABASE POSTGRESQL SCHEMA
-- BIT College Alumni Networking Platform
-- Complete DB Schema, RLS, Indexes, Triggers, Storage & Seed Data
-- =====================================================

-- -----------------------------------------------------
-- 1. EXTENSIONS & SETUP
-- -----------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -----------------------------------------------------
-- 2. CORE TABLES DEFINITION
-- -----------------------------------------------------

-- DEPARTMENTS TABLE
CREATE TABLE IF NOT EXISTS public.departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(10) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- BATCHES TABLE
CREATE TABLE IF NOT EXISTS public.batches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    year INTEGER NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- USERS TABLE (Linked with auth.users)
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL UNIQUE,
    role VARCHAR(20) NOT NULL DEFAULT 'student' CHECK (role IN ('student', 'alumni', 'admin')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    avatar_url TEXT,
    bio TEXT,
    headline VARCHAR(200),
    department_id UUID REFERENCES public.departments(id) ON DELETE SET NULL,
    batch_id UUID REFERENCES public.batches(id) ON DELETE SET NULL,
    company VARCHAR(150),
    job_title VARCHAR(150),
    location VARCHAR(150),
    linkedin_url TEXT,
    phone VARCHAR(30),
    skills TEXT[] DEFAULT '{}',
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- EVENTS TABLE
CREATE TABLE IF NOT EXISTS public.events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    banner_url TEXT,
    event_date TIMESTAMP WITH TIME ZONE NOT NULL,
    location VARCHAR(200) NOT NULL,
    is_virtual BOOLEAN DEFAULT FALSE,
    meeting_link TEXT,
    organizer_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    qr_code_secret VARCHAR(100) DEFAULT uuid_generate_v4()::text,
    capacity INTEGER DEFAULT 100,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- EVENT REGISTRATION TABLE
CREATE TABLE IF NOT EXISTS public.event_registration (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    rsvp_status VARCHAR(20) DEFAULT 'attending' CHECK (rsvp_status IN ('attending', 'maybe', 'declined')),
    attended BOOLEAN DEFAULT FALSE,
    checked_in_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(event_id, user_id)
);

-- MENTORS TABLE
CREATE TABLE IF NOT EXISTS public.mentors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE UNIQUE,
    expertise TEXT[] NOT NULL DEFAULT '{}',
    max_mentees INTEGER DEFAULT 5,
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'busy', 'inactive')),
    hourly_availability TEXT,
    bio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- MENTOR REQUESTS TABLE
CREATE TABLE IF NOT EXISTS public.mentor_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mentor_id UUID NOT NULL REFERENCES public.mentors(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'completed')),
    meeting_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- DONATION CAUSES TABLE
CREATE TABLE IF NOT EXISTS public.donation_causes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    target_amount DECIMAL(12,2) NOT NULL,
    raised_amount DECIMAL(12,2) DEFAULT 0.00,
    banner_url TEXT,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'completed', 'paused')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- DONATIONS TABLE
CREATE TABLE IF NOT EXISTS public.donations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cause_id UUID NOT NULL REFERENCES public.donation_causes(id) ON DELETE CASCADE,
    donor_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'USD',
    stripe_payment_id VARCHAR(100),
    status VARCHAR(20) DEFAULT 'completed',
    is_anonymous BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- UTILIZATION REPORTS TABLE
CREATE TABLE IF NOT EXISTS public.utilization_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cause_id UUID NOT NULL REFERENCES public.donation_causes(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    amount_spent DECIMAL(12,2) NOT NULL,
    proof_document_url TEXT,
    report_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- SCHOLARSHIPS TABLE
CREATE TABLE IF NOT EXISTS public.scholarships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    sponsor_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    eligibility_criteria TEXT NOT NULL,
    deadline TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- SCHOLARSHIP APPLICATIONS TABLE
CREATE TABLE IF NOT EXISTS public.scholarship_applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    scholarship_id UUID NOT NULL REFERENCES public.scholarships(id) ON DELETE CASCADE,
    applicant_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'submitted' CHECK (status IN ('submitted', 'under_review', 'awarded', 'rejected')),
    gpa DECIMAL(3,2),
    statement_of_purpose TEXT NOT NULL,
    document_urls TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(scholarship_id, applicant_id)
);

-- JOBS TABLE
CREATE TABLE IF NOT EXISTS public.jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    company VARCHAR(150) NOT NULL,
    location VARCHAR(150) NOT NULL,
    job_type VARCHAR(50) DEFAULT 'Full-Time',
    experience_level VARCHAR(50) DEFAULT 'Entry Level',
    description TEXT NOT NULL,
    salary_range VARCHAR(100),
    posted_by_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    apply_link TEXT,
    accepts_referrals BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    body TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'general',
    payload JSONB,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- -----------------------------------------------------
-- 3. INDEXES FOR PERFORMANCE OPTIMIZATION
-- -----------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON public.users(role);
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON public.profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_company ON public.profiles(company);
CREATE INDEX IF NOT EXISTS idx_profiles_department ON public.profiles(department_id);
CREATE INDEX IF NOT EXISTS idx_profiles_batch ON public.profiles(batch_id);
CREATE INDEX IF NOT EXISTS idx_profiles_verified ON public.profiles(is_verified);
CREATE INDEX IF NOT EXISTS idx_events_date ON public.events(event_date);
CREATE INDEX IF NOT EXISTS idx_mentor_requests_mentor ON public.mentor_requests(mentor_id);
CREATE INDEX IF NOT EXISTS idx_mentor_requests_student ON public.mentor_requests(student_id);
CREATE INDEX IF NOT EXISTS idx_donations_cause ON public.donations(cause_id);
CREATE INDEX IF NOT EXISTS idx_jobs_company ON public.jobs(company);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id);

-- -----------------------------------------------------
-- 4. AUTOMATIC TIMESTAMP & USER TRIGGERS
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at triggers to tables
DO $$
DECLARE
    t text;
BEGIN
    FOR t IN SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS tr_updated_at_%I ON public.%I', t, t);
        EXECUTE format('CREATE TRIGGER tr_updated_at_%I BEFORE UPDATE ON public.%I FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column()', t, t);
    END LOOP;
END $$;

-- TRIGGER: Auto-create user and profile entry on Supabase Auth SignUp
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, email, role)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'role', 'student')
    );

    INSERT INTO public.profiles (user_id, full_name)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', 'BIT Member')
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- -----------------------------------------------------
-- 5. ADMIN ANALYTICS RPC FUNCTION
-- -----------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_admin_stats()
RETURNS JSONB AS $$
DECLARE
    result JSONB;
BEGIN
    SELECT jsonb_build_object(
        'total_students', (SELECT COUNT(*) FROM public.users WHERE role = 'student'),
        'total_alumni', (SELECT COUNT(*) FROM public.users WHERE role = 'alumni'),
        'pending_verifications', (SELECT COUNT(*) FROM public.profiles WHERE is_verified = FALSE),
        'total_events', (SELECT COUNT(*) FROM public.events),
        'total_donations', COALESCE((SELECT SUM(amount) FROM public.donations WHERE status = 'completed'), 0),
        'active_mentorships', (SELECT COUNT(*) FROM public.mentor_requests WHERE status = 'accepted'),
        'active_jobs', (SELECT COUNT(*) FROM public.jobs)
    ) INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- -----------------------------------------------------
-- 6. ROW LEVEL SECURITY (RLS) POLICIES
-- -----------------------------------------------------
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_registration ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mentors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mentor_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.donation_causes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.donations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.utilization_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.scholarships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.scholarship_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Read policies for public tables
CREATE POLICY "Public read profiles" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Public read events" ON public.events FOR SELECT USING (true);
CREATE POLICY "Public read jobs" ON public.jobs FOR SELECT USING (true);
CREATE POLICY "Public read causes" ON public.donation_causes FOR SELECT USING (true);
CREATE POLICY "Public read mentors" ON public.mentors FOR SELECT USING (true);

-- User self-update policies
CREATE POLICY "Users update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users view own notifications" ON public.notifications FOR SELECT USING (auth.uid() = user_id);

-- -----------------------------------------------------
-- 7. STORAGE BUCKETS CONFIGURATION
-- -----------------------------------------------------
INSERT INTO storage.buckets (id, name, public)
VALUES 
    ('avatars', 'avatars', true),
    ('event_banners', 'event_banners', true),
    ('scholarship_docs', 'scholarship_docs', false),
    ('utilization_proofs', 'utilization_proofs', true)
ON CONFLICT (id) DO NOTHING;

-- -----------------------------------------------------
-- 8. INITIAL SEED DATA
-- -----------------------------------------------------
INSERT INTO public.departments (name, code) VALUES
    ('Computer Science & Engineering', 'CSE'),
    ('Electronics & Communication Engineering', 'ECE'),
    ('Mechanical Engineering', 'MECH'),
    ('Information Technology', 'IT'),
    ('Civil Engineering', 'CIVIL'),
    ('Electrical & Electronics Engineering', 'EEE')
ON CONFLICT (name) DO NOTHING;

INSERT INTO public.batches (year, name) VALUES
    (2018, 'Batch of 2018'),
    (2019, 'Batch of 2019'),
    (2020, 'Batch of 2020'),
    (2021, 'Batch of 2021'),
    (2022, 'Batch of 2022'),
    (2023, 'Batch of 2023'),
    (2024, 'Batch of 2024'),
    (2025, 'Batch of 2025'),
    (2026, 'Batch of 2026')
ON CONFLICT (year) DO NOTHING;

INSERT INTO public.donation_causes (title, description, target_amount, raised_amount, status) VALUES
    ('BIT Innovation Lab & Supercomputing Hub', 'Funding advanced GPU clusters and AI research hardware for BIT students.', 50000.00, 18500.00, 'active'),
    ('BIT Need-Based Merit Scholarships 2026', 'Supporting underprivileged students with full tuition and hostel grants.', 30000.00, 12000.00, 'active')
ON CONFLICT DO NOTHING;

INSERT INTO public.jobs (title, company, location, job_type, experience_level, description, salary_range, accepts_referrals) VALUES
    ('Software Development Engineer II', 'Google', 'Mountain View, CA', 'Full-Time', 'Mid Level', 'Building scalable cloud microservices and high-throughput systems.', '\$140,000 - \$180,000', true),
    ('Associate Product Manager', 'Microsoft', 'Seattle, WA', 'Full-Time', 'Entry Level', 'Product strategy and user research for Azure Developer Experience.', '\$115,000 - \$140,000', true)
ON CONFLICT DO NOTHING;
