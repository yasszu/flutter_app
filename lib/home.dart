import 'package:flutter/material.dart';

import 'api/RedditAPi.dart';
import 'model/RedditPost.dart';
import 'model/RedditPosts.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  final Set<String> _saved = new Set<String>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final List<RedditPost> _items = new List();
  String _after;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('r/FlutterDev'),
      ),
      body: _buildListView(),
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

  Widget _buildListView() {
    return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, i) {
          if (needFetch(i)) {
            fetchData();
          }
          return _buildRow(_items[i]);
        });
  }

  void fetchData() async {
    var after = _after == null ? "" : _after;
    var response = RedditAPI().getTop(after);
    response.then((RedditPosts res) => {
          setState(() {
            _items.addAll(res.posts);
            _after = res.after;
          })
        });
  }

  bool needFetch(int index) {
    return (index + 1) >= _items.length;
  }

  Widget _buildRow(RedditPost post) {
    final String key = post.name;
    final bool alreadySaved = _saved.contains(key);
    return Column(children: [
      ListTile(
        leading: Container(
            width: 80,
            child: post.thumbnail == "self" || post.thumbnail == "default"
                ? FlutterLogo(size: 80.0)
                : Image.network(
                    post.thumbnail,
                    fit: BoxFit.cover,
                  )),
        title: Text(post.author),
        subtitle: Text(
          post.title,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        isThreeLine: true,
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
