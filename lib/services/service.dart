import 'dart:convert';
import '../models/comment.dart';
import 'package:http/http.dart' as http;

Future<List<Comment>> getCommentFromApi(int start, int limit) async {
  final url = "https://jsonplaceholder.typicode.com/comments?_start=${start}=&_limit=${limit}";
  final http.Client httpClient = http.Client();
  try {
    final resp = await httpClient.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      final respData = json.decode(resp.body) as List;
      return respData.map((element) => Comment(postId: element["postId"], id: element["id"],
          name: element["name"], email: element["email"], body: element["body"])).toList().cast<Comment>();
    }
    else return <Comment>[];
  } catch (e, s) {
    print(e.toString());
    return <Comment>[];
  }
}