import 'package:cloud_firestore/cloud_firestore.dart';

import 'saved_movie.dart';

/// Firestore calls for the saved movies of each user.
///
/// Every movie is a document at `users/{uid}/watchlist/{movieId}`, so a user
/// can only ever see their own list (enforced by the Firestore rules too).
class WatchListService {
  WatchListService([this._firestore]);

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _watchList(String uid) =>
      _db.collection('users').doc(uid).collection('watchlist');

  /// Emits the saved movies, newest first, and again after every change.
  Stream<List<SavedMovie>> watchList(String uid) => _watchList(uid)
      .orderBy('savedAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => SavedMovie.fromJson(doc.data()))
            .toList(),
      );

  Future<void> add(String uid, SavedMovie movie) => _watchList(uid)
      .doc('${movie.id}')
      .set({...movie.toJson(), 'savedAt': FieldValue.serverTimestamp()});

  Future<void> remove(String uid, int movieId) =>
      _watchList(uid).doc('$movieId').delete();
}
