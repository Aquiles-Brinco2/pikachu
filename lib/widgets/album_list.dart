import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikachu/models/album.dart';
import 'package:pikachu/pages/album_detail_page.dart';

class AlbumList extends StatelessWidget {
  const AlbumList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('albums').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar álbumes'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final albums = snapshot.data!.docs;

        return ListView.builder(
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final album =
                Album.fromMap(albums[index].data() as Map<String, dynamic>);
            return ListTile(
              leading: Image.network(
                album.coverUrl,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.album),
              ),
              title: Text(album.title),
              subtitle: Text(album.artist),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlbumDetailPage(album: album),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
