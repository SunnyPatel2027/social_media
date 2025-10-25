import 'package:equatable/equatable.dart';
import '../data/post_model.dart';

class PostState extends Equatable {
  final bool isLoading;
  final List<PostModel> posts;
  final String? error;

  const PostState({this.isLoading = false, this.posts = const [], this.error});

  PostState copyWith({bool? isLoading, List<PostModel>? posts, String? error}) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, posts, error];
}
