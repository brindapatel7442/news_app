part of 'headline_bloc.dart';

enum PostStatus { initial, success, failure }  // status for API calling response

class HeadlineState extends Equatable {
  const HeadlineState({
    this.status = PostStatus.initial,
    this.posts = const <Headlines>[],
    this.hasReachedMax = false,
  });

  final PostStatus status;
  final List<Headlines> posts;
  final bool hasReachedMax;

  HeadlineState copyWith({
    PostStatus? status,
    List<Headlines>? posts,  // list of headlines
     bool? hasReachedMax,  // reached scroll to bottom
  }) {
    return HeadlineState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}