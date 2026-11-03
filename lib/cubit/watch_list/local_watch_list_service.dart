import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'saved_movie.dart';
import 'watch_list_service.dart';

/// Keeps the saved movies on this device, one list per signed-in user.
///
/// Temporary stand-in until Firestore is enabled for the project: the list
/// does not follow the account to other devices.
class LocalWatchListService implements WatchListService {
  final _changes = StreamController<String>.broadcast();

  String _key(String uid) => 'watchlist_$uid';

  Future<List<SavedMovie>> _read(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(uid));
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => SavedMovie.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _write(String uid, List<SavedMovie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(uid),
      jsonEncode(movies.map((movie) => movie.toJson()).toList()),
    );
    _changes.add(uid);
  }

  @override
  Stream<List<SavedMovie>> watchList(String uid) async* {
    yield await _read(uid);
    await for (final changedUid in _changes.stream) {
      if (changedUid == uid) yield await _read(uid);
    }
  }

  @override
  Future<void> add(String uid, SavedMovie movie) async {
    final movies = await _read(uid);
    movies.removeWhere((saved) => saved.id == movie.id);
    // Newest first, like the Firestore version.
    await _write(uid, [movie, ...movies]);
  }

  @override
  Future<void> remove(String uid, int movieId) async {
    final movies = await _read(uid);
    movies.removeWhere((saved) => saved.id == movieId);
    await _write(uid, movies);
  }
}
