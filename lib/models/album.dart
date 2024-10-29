class Album {
  final String id;
  final String title;
  final String artist;
  final List<String> songIds;
  final String coverUrl;

  Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.songIds,
    required this.coverUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'songIds': songIds,
      'coverUrl': coverUrl,
    };
  }

factory Album.fromMap(Map<String, dynamic> map) {
  return Album(
    id: map['id'] ?? '1', // Valor por defecto vacío
    title: map['title'] ?? 'Untitled', // Valor por defecto 'Untitled'
    artist: map['artist'] ?? 'Unknown Artist', // Valor por defecto 'Unknown Artist'
    songIds: List<String>.from(map['songIds'] ?? []), // Lista vacía si no hay ids
    coverUrl: map['coverUrl'] ?? 'https://example.com/default_cover.jpg', // URL por defecto
  );
}
}