import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/mentorship_provider.dart';
import '../../widgets/mentorship/mentor_card.dart';
import '../../widgets/mentorship/mentor_request_card.dart';

class MentorshipScreen extends ConsumerWidget {
  const MentorshipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BIT Mentorship Portal'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people_outline_rounded), text: 'Find Mentors'),
              Tab(icon: Icon(Icons.history_rounded), text: 'My Sessions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMentorsTab(context, ref),
            _buildSessionsTab(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorsTab(BuildContext context, WidgetRef ref) {
    final mentorsAsync = ref.watch(mentorListProvider);

    return mentorsAsync.when(
      data: (mentors) => mentors.isEmpty
          ? const Center(child: Text('No active mentors found.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mentors.length,
              itemBuilder: (context, index) {
                final mentor = mentors[index];
                return MentorCard(
                  mentor: mentor,
                  onBookTap: () {
                    context.push('/mentorship/book', extra: mentor);
                  },
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error loading mentors: $err')),
    );
  }

  Widget _buildSessionsTab(BuildContext context, WidgetRef ref) {
    final requestsState = ref.watch(mentorRequestsNotifierProvider);

    if (requestsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (requestsState.requests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No Mentorship Sessions Yet'),
            SizedBox(height: 8),
            Text('Book a session with an alumni mentor to get started.'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requestsState.requests.length,
      itemBuilder: (context, index) {
        final req = requestsState.requests[index];
        return MentorRequestCard(request: req);
      },
    );
  }
}
