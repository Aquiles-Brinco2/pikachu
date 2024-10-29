class Song {
  final String id;
  final String title;
  final String artist;
  final String genre;
  final int duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.duration,
  });

factory Song.fromMap(Map<String, dynamic> map) {
  return Song(
    id: map['id'] as String? ?? '1', // Valor por defecto vacío
    title: map['title'] as String? ?? 'Untitled', // Valor por defecto 'Untitled'
    artist: map['artist'] as String? ?? 'Unknown Artist', // Valor por defecto 'Unknown Artist'
    genre: map['genre'] as String? ?? 'Unknown Genre', // Valor por defecto 'Unknown Genre'
    duration: map['duration'] as int? ?? 0, // Valor por defecto 0
  );
}


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'genre': genre,
      'duration': duration,
    };
  }

}
