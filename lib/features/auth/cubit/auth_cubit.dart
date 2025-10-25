import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/error_handler.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;
  StreamSubscription? _sub;

  AuthCubit(this._repo) : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(isLoading: true));

    _sub = _repo.authStateChanges().listen((u) async {
      if (u == null) {
        emit(state.copyWith(isLoading: false, user: null));
      } else {
        try {
          final model = await _repo.getUserById(u.uid);
          emit(state.copyWith(isLoading: false, user: model));
        } catch (e) {
          emit(
            state.copyWith(
              isLoading: false,
              error: ErrorHandler.handle(e).message,
            ),
          );
        }
      }
    });

    final saved = await _repo.getSavedUid();
    if (saved != null && state.user == null) {
      try {
        final u = await _repo.getUserById(saved);
        emit(state.copyWith(isLoading: false, user: u));
      } catch (_) {
        emit(state.copyWith(isLoading: false));
      }
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> signUp(String email, String pass, String username) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await _repo.signUp(email, pass, username);
      await Future.delayed(const Duration(milliseconds: 200));
      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: ErrorHandler.handle(e).message),
      );
    }
  }

  Future<void> signIn(String email, String pass) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await _repo.signIn(email, pass);
      await Future.delayed(const Duration(milliseconds: 200));
      emit(state.copyWith(isLoading: false, user: user));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: ErrorHandler.handle(e).message),
      );
    }
  }

  /// ✅ Single, safe logout trigger
  Future<void> signOut() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    try {
      await _repo.signOut();
    } catch (_) {}
    emit(const AuthState(isLoading: false, user: null));
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
