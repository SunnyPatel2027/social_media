import 'package:equatable/equatable.dart';
import '../data/user_model.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  const AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, UserModel? user, String? error}) {
    return AuthState(isLoading: isLoading ?? this.isLoading, user: user ?? this.user, error: error);
  }

  @override
  List<Object?> get props => [isLoading, user?.uid, error];
}
