import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/error_handler.dart';
import '../../auth/data/user_model.dart';
import '../data/post_repository.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository _repo;
  final UserModel? user;
  StreamSubscription? _sub;

  PostCubit(this._repo, this.user) : super(const PostState()) {
    _listen();
  }

  void _listen() {
    emit(state.copyWith(isLoading: true));
    _sub = _repo.getPostsStream().listen(
      (posts) {
        emit(state.copyWith(isLoading: false, posts: posts));
      },
      onError: (e) {
        final f = ErrorHandler.handle(e);
        emit(state.copyWith(isLoading: false, error: f.message));
      },
    );
  }

  Future<void> createPost(String msg) async {
    if (user == null) return;
    try {
      await _repo.createPost(msg, user!.username);
    } catch (e) {
      final f = ErrorHandler.handle(e);
      emit(state.copyWith(error: f.message));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
