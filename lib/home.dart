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
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final String baseUrl = "https://www.reddit.com/r/FlutterDev/hot.json";
  String after;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(itemBuilder: (context, i) {
      if (needFetch(i)) {
        fetchWords();
        fetchData();
      }
      return _buildRow(_suggestions[i]);
    });
  }

  Future<List<RedditPost>> fetchData() async {
    var url = baseUrl + "?" + "limit=10";
    var response = await http.get(Uri.encodeFull(Uri.encodeFull(url)));
    if (response.statusCode == 200) {
      var responseJson  = json.decode(response.body);
      var data = responseJson['data'];
      after = data['after'];
      var children = data['children'] as List;
      List<RedditPost> posts = children.map((e) => RedditPost.fromJson(e['data'])).toList();

      posts.forEach((p) {
        print(p.title);
      });

      return posts;
    } else {
      return List();
    }
  }

  bool needFetch(int index) {
    return index >= _suggestions.length;
  }

  void fetchWords() {
    _suggestions.addAll(generateWordPairs().take(10));
  }

  Widget _buildRow(WordPair pair) {
    final String word =
        pair.asPascalCase + "#" + _suggestions.length.toString();
    final bool alreadySaved = _saved.contains(pair);
    return Column(children: [
      ListTile(
        title: Text(
          word,
          style: _biggerFont,
        ),
        trailing: new Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      ),
      Divider()
    ]);
  }
}
