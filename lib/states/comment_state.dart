import 'package:infinite_list/models/comment.dart';
import 'package:equatable/equatable.dart';

abstract class CommentSate extends Equatable {}
class CommentStateLoading extends CommentSate {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class CommentStateSuccess extends CommentSate {
  final List<Comment> lstComments;
  CommentStateSuccess({required this.lstComments});
  @override
  // TODO: implement props
  List<Object?> get props => [lstComments];
}
class CommentStateFailure extends CommentSate {
  final String error;
  CommentStateFailure({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}