import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/blocs/comment_bloc.dart';
import 'package:infinite_list/events/comment_event.dart';
import 'package:infinite_list/models/comment.dart';
import 'package:infinite_list/states/comment_state.dart';
import 'infinite_list_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) {
            final commentBloc = CommentBloc();
            commentBloc.add(CommentFetchedEvent());
            return commentBloc;
          },)
        ],
        child: InfiniteList(),
      )
    );
  }
}