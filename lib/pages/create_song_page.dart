import 'package:flutter/material.dart';
import 'package:pikachu/models/song.dart';
import 'package:pikachu/services/firestore_service.dart';

class CreateSongPage extends StatefulWidget {
  const CreateSongPage({super.key});

  @override
  State<CreateSongPage> createState() => _CreateSongPageState();
}

class _CreateSongPageState extends State<CreateSongPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _genreController = TextEditingController();
  final _durationController = TextEditingController();

  Future<void> _createSong() async {
    if (_formKey.currentState!.validate()) {
      try {
        final song = Song(
          id: _idController.text,
          title: _titleController.text,
          artist: _artistController.text,
          genre: _genreController.text,
          duration: int.parse(_durationController.text),
        );

        await FirestoreService().createSong(song);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Canción'),
        backgroundColor: Colors.yellow[600],
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'Id'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el id';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _artistController,
                decoration: const InputDecoration(labelText: 'Artista'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el artista';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Género'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el género';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duración (segundos)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la duración';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createSong,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                ),
                child: const Text('Crear Canción'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
