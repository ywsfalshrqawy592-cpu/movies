import 'package:cloud_firestore/cloud_firestore.dart';

import 'saved_movie.dart';

abstract class WatchListService {
  Stream<List<SavedMovie>> watchList(String uid);

  Future<void> add(String uid, SavedMovie movie);

  Future<void> remove(String uid, int movieId);
}

class FirestoreWatchListService implements WatchListService {
  FirestoreWatchListService([this._listName = 'watchlist', this._firestore]);

  final String _listName;
  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _watchList(String uid) =>
      _db.collection('users').doc(uid).collection(_listName);

  @override
  Stream<List<SavedMovie>> watchList(String uid) => _watchList(uid)
      .orderBy('savedAt', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => SavedMovie.fromJson(doc.data()))
            .toList(),
      );

  @override
  Future<void> add(String uid, SavedMovie movie) => _watchList(uid)
      .doc('${movie.id}')
      .set({...movie.toJson(), 'savedAt': FieldValue.serverTimestamp()});

  @override
  Future<void> remove(String uid, int movieId) =>
      _watchList(uid).doc('$movieId').delete();
}
