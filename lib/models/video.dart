class Video {
  final String id;
  final String key;
  final String site;
  final String type;
  final bool official;
  final String name;

  const Video({
    required this.id,
    required this.key,
    required this.site,
    required this.type,
    required this.official,
    required this.name,
  });

  bool get isYoutubeTrailer => site == 'YouTube' && type == 'Trailer';

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      key: json['key'] as String,
      site: json['site'] as String? ?? '',
      type: json['type'] as String? ?? '',
      official: json['official'] as bool? ?? false,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'site': site,
      'type': type,
      'official': official,
      'name': name,
    };
  }
}
