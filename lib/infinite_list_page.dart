import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/blocs/comment_bloc.dart';
import 'package:infinite_list/events/comment_event.dart';
import 'package:infinite_list/models/comment.dart';
import 'package:infinite_list/states/comment_state.dart';

class InfiniteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InfiniteList();
}

class _InfiniteList extends State<InfiniteList> {
  late CommentBloc _commentBloc;
  //scroll controller
  final _scrollController = ScrollController();
  final _scrollThreadhold = 100;

  @override
  void initState() {
    // TODO: implement initState
    _commentBloc = BlocProvider.of(context);
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentPos = _scrollController.position.pixels;
      if (maxScrollExtent - currentPos < _scrollThreadhold) {
        _commentBloc.add(CommentFecthedEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infinite List"),
      ),
      body: SafeArea(
        child: BlocBuilder<CommentBloc, CommentSate>(
          builder: (context, state) {
            if (state is CommentStateLoading) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
            else if (state is CommentStateFailure) {
              return Center(
                child: Text((state as CommentStateFailure).error),
              );
            }
            else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  Comment item = (state as CommentStateSuccess).lstComments[index];
                  return ListTile(
                    leading: Text(item.id.toString()),
                    title: Text(item.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Text(item.body),
                  );
                },
                itemCount: (state as CommentStateSuccess).lstComments.length,
                controller: _scrollController,
              );
            }
          },
        )
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
  }
}