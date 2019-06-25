import 'package:flutter_app/model/RedditPost.dart';
import 'package:flutter_app/model/RedditPosts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RedditAPI {
  final String baseUrl = "https://www.reddit.com/r/FlutterDev/hot.json";

  Future<RedditPosts> getTop(String after, {limit = 20}) async {
    var url = baseUrl + "?" + "limit=" + limit.toString() + "&after=" + after;
    var response = await http.get(Uri.encodeFull(Uri.encodeFull(url)));
    if (response.statusCode == 200) {
      return deserialize(response.body);
    } else {
      return RedditPosts(after, List());
    }
  }

  RedditPosts deserialize(String jsonString) {
    var responseJson = json.decode(jsonString);
    var data = responseJson['data'];
    var _after = data['after'];
    var children = data['children'] as List;
    List<RedditPost> posts =
        children.map((e) => RedditPost.fromJson(e['data'])).toList();
    return RedditPosts(_after, posts);
  }
}
