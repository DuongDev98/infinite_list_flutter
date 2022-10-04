import 'package:infinite_list/models/comment.dart';
import 'package:equatable/equatable.dart';

abstract class CommentSate extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CommentStateInitial extends CommentSate {}
class CommentStateFailure extends CommentSate {
  final String error;

  CommentStateFailure({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
class CommentStateSuccess extends CommentSate {
  final List<Comment> comments;
  final bool hasReachedEnd;

  CommentStateSuccess({required this.comments, required this.hasReachedEnd});

  @override
  // TODO: implement props
  List<Object?> get props => [comments, hasReachedEnd];
}