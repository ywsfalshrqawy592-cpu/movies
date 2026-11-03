import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'saved_movie.dart';
import 'watch_list_service.dart';
import 'watch_list_state.dart';

/// Holds the saved movies of the signed-in user.
///
/// It follows the session: when the user changes it switches to their list,
/// and when they sign out it clears the list.
class WatchListCubit extends Cubit<WatchListState> {
  WatchListCubit(this._service, {required Stream<String?> userIds})
    : super(const WatchListState()) {
    _userSubscription = userIds.distinct().listen(_onUserChanged);
  }

  final WatchListService _service;
  late final StreamSubscription<String?> _userSubscription;
  StreamSubscription<List<SavedMovie>>? _listSubscription;
  String? _uid;

  void _onUserChanged(String? uid) {
    _uid = uid;
    _listSubscription?.cancel();
    _listSubscription = null;
    emit(const WatchListState());
    if (uid == null) return;
    _listSubscription = _service
        .watchList(uid)
        .listen(
          (movies) => emit(WatchListState(movies: movies)),
          onError: (Object e) => emit(
            WatchListState(movies: state.movies, errorMessage: e.toString()),
          ),
        );
  }

  /// Saves the movie, or removes it if it is already saved.
  Future<void> toggle(SavedMovie movie) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      if (state.isSaved(movie.id)) {
        await _service.remove(uid, movie.id);
      } else {
        await _service.add(uid, movie);
      }
    } catch (e) {
      emit(WatchListState(movies: state.movies, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _listSubscription?.cancel();
    return super.close();
  }
}
