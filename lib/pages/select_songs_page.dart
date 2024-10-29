import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikachu/models/song.dart';
import 'package:pikachu/pages/create_song_page.dart';
import 'package:pikachu/services/firestore_service.dart';

class SelectSongsPage extends StatefulWidget {
  final List<String> selectedSongs;
  final Function(List<String>) onSongsSelected;

  const SelectSongsPage({
    super.key,
    required this.selectedSongs,
    required this.onSongsSelected,
  });

  @override
  State<SelectSongsPage> createState() => _SelectSongsPageState();
}

class _SelectSongsPageState extends State<SelectSongsPage> {
  List<String> _selectedSongs = [];

  @override
  void initState() {
    super.initState();
    _selectedSongs = List.from(widget.selectedSongs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Canciones'),
        backgroundColor: Colors.yellow[600],
        actions: [
          TextButton(
            onPressed: () {
              print('Canciones seleccionadas: $_selectedSongs'); // Para depuración
              widget.onSongsSelected(_selectedSongs);
              Navigator.pop(context);
            },
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.yellow[100]!,
              Colors.yellow[300]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getSongs(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error al cargar las canciones'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final songs = snapshot.data!.docs
                      .map((doc) => Song.fromMap(doc.data() as Map<String, dynamic>))
                      .toList();

                  if (songs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No hay canciones disponibles'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateSongPage(),
                                ),
                              );
                            },
                            child: const Text('Crear Nueva Canción'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      final isSelected = _selectedSongs.contains(song.id);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.yellow[200],
                          child: Icon(
                            isSelected ? Icons.check : Icons.music_note,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(song.title),
                        subtitle: Text('${song.artist} - ${song.genre}'),
                        trailing: Text(
                          _formatDuration(song.duration),
                          style: const TextStyle(color: Colors.black54),
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedSongs.remove(song.id);
                            } else {
                              _selectedSongs.add(song.id);
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateSongPage(),
            ),
          );
        },
        backgroundColor: Colors.yellow[700],
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
