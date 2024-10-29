import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pikachu/models/song.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Stream<QuerySnapshot> getSongs() {
    return _firestore
        .collection('songs')
        .where('userId', isEqualTo: userId)

        .snapshots();
  }

  Future<String> createSong(Song song) async {
    try {
      final docRef = await _firestore.collection('songs').add({
        'title': song.title,
        'artist': song.artist,
        'genre': song.genre,
        'duration': song.duration,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await docRef.update({'id': docRef.id});
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear la canción: $e');
    }
  }
}
