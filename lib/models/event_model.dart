/// Event Model representing college and alumni events
class EventModel {
  final String id;
  final String title;
  final String description;
  final String? bannerUrl;
  final DateTime eventDate;
  final String location;
  final bool isVirtual;
  final String? meetingLink;
  final String qrCodeSecret;
  final int capacity;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    this.bannerUrl,
    required this.eventDate,
    required this.location,
    this.isVirtual = false,
    this.meetingLink,
    required this.qrCodeSecret,
    this.capacity = 100,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      bannerUrl: json['banner_url'] as String?,
      eventDate: json['event_date'] != null
          ? DateTime.parse(json['event_date'] as String)
          : DateTime.now(),
      location: json['location'] as String? ?? 'BIT Campus',
      isVirtual: json['is_virtual'] as bool? ?? false,
      meetingLink: json['meeting_link'] as String?,
      qrCodeSecret: json['qr_code_secret'] as String? ?? json['id'] as String,
      capacity: json['capacity'] as int? ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'banner_url': bannerUrl,
      'event_date': eventDate.toIso8601String(),
      'location': location,
      'is_virtual': isVirtual,
      'meeting_link': meetingLink,
      'qr_code_secret': qrCodeSecret,
      'capacity': capacity,
    };
  }
}
