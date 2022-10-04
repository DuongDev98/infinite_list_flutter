import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/models/comment.dart';
import 'package:infinite_list/services/service.dart';
import 'package:infinite_list/states/comment_state.dart';
import 'package:infinite_list/events/comment_event.dart';

class CommentBloc extends Bloc<CommentEvent, CommentSate> {
  int limit = 20;
  CommentBloc() : super(CommentStateInitial()) {
     on<CommentFetchedEvent>((event, emit) async {
       try {
         bool hasReachedEndOfOnePage = (state is CommentStateSuccess && (state as CommentStateSuccess).hasReachedEnd);
         if (event is CommentFetchedEvent && !hasReachedEndOfOnePage) {
           if (state is CommentStateInitial) {
             List<Comment> lstResult = await getCommentFromApi(0, limit);
             emit(CommentStateSuccess(comments: lstResult, hasReachedEnd: false));
           } else if (state is CommentStateSuccess) {
             final finalIndexCurrentOfPage = (state as CommentStateSuccess).comments.length;
             List<Comment> lstResult = await getCommentFromApi(finalIndexCurrentOfPage, limit);
             if (lstResult.isEmpty) {
               emit(CommentStateSuccess(comments: (state as CommentStateSuccess).comments, hasReachedEnd: true));
             } else {
               List<Comment> temp = <Comment>[];
               lstResult.forEach((element) {
                 if (!((state as CommentStateSuccess).comments + temp).contains(element)) {
                   temp.add(element);
                 }
               });
               emit(CommentStateSuccess(comments: (state as CommentStateSuccess).comments + temp, hasReachedEnd: true));
             }
           }
         }
       } catch (exception) {
         emit(CommentStateFailure(error: exception.toString()));
       }
     });
  }
}