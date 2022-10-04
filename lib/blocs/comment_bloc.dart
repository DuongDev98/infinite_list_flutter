import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/models/comment.dart';
import 'package:infinite_list/services/service.dart';
import 'package:infinite_list/states/comment_state.dart';
import 'package:infinite_list/events/comment_event.dart';

class CommentBloc extends Bloc<CommentEvent, CommentSate> {
  int limit = 20;
  CommentBloc() : super(CommentStateLoading()) {
     on<CommentFecthedEvent>((event, emit) async {
       try {
         int offset = 0;
         List<Comment> lstComments = <Comment>[];
         if (state is CommentStateSuccess) {
           offset = (state as CommentStateSuccess).lstComments.length;
           lstComments = (state as CommentStateSuccess).lstComments;
         }
         emit(CommentStateLoading());
         final comments = await getCommentFromApi(offset, limit);
         lstComments.addAll(comments);
         emit(CommentStateSuccess(lstComments: lstComments));
       }
       catch (e) {
         emit(CommentStateFailure(error: e.toString()));
       }
     });
  }
}