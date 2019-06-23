import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:english_words/english_words.dart';
import 'package:http/http.dart' as http;

import 'model/RedditPost.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  final Set<String> _saved = new Set<String>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final String baseUrl = "https://www.reddit.com/r/FlutterDev/hot.json";

  final List<RedditPost> _items = new List();

  String _after;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, i) {
          if (needFetch(i)) {
            fetchData();
          }
          return _buildRow(_items[i]);
        });
  }

  Future<List<RedditPost>> fetchData() async {
    var url = baseUrl + "?" + "limit=20";
    var response = await http.get(Uri.encodeFull(Uri.encodeFull(url)));
    if (response.statusCode == 200) {
      var responseJson  = json.decode(response.body);
      var data = responseJson['data'];
      _after = data['after'];
      var children = data['children'] as List;
      List<RedditPost> posts = children.map((e) =>
          RedditPost.fromJson(e['data'])
      ).toList();

      if (posts.length > 0) {
        setState(() {
          print(_items.length);
          _items.addAll(posts);
        });
      }

      return posts;
    } else {
      return List();
    }
  }

  bool needFetch(int index) {
    print("index: " + index.toString());
    return (index + 1) >= _items.length;
  }

  Widget _buildRow(RedditPost post) {
    final String key = post.name;
    final bool alreadySaved = _saved.contains(key);

    return Column(children: [
      ListTile(
        title: Text(
          post.title,
          style: _biggerFont,
        ),
        trailing: new Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(key);
            } else {
              _saved.add(key);
            }
          });
        },
      ),
      Divider()
    ]);
  }
}
