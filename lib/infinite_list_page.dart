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
  final _scrollThreadhold = 250;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentBloc = BlocProvider.of(context);
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if(maxScrollExtent - currentScroll <= _scrollThreadhold) {
        _commentBloc.add(CommentFetchedEvent());
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
            if (state is CommentStateInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CommentStateFailure) {
              return Text(state.error);
            } else {
              CommentStateSuccess currentState = state as CommentStateSuccess;
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index == currentState.comments.length) {
                    return Container(
                      alignment: Alignment.center,
                      child: const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  } else {
                    Comment item = currentState.comments[index];
                    return ListTile(
                      leading: Text(item.id.toString()),
                      title: Text(item.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: Text(item.body),
                    );
                  }
                },
                itemCount: currentState.hasReachedEnd ? currentState.comments.length : currentState.comments.length + 1,
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
    super.dispose();
    _scrollController.dispose();
  }
}