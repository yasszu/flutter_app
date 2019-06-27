import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/RedditAPi.dart';
import 'model/RedditPost.dart';
import 'model/RedditPosts.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
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
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildListView() {
    return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, i) {
          if (_needFetch(i)) {
            _fetchData();
          }
          return _buildRow(_items[i]);
        });
  }

  void _fetchData() async {
    var after = _after == null ? "" : _after;
    var response = RedditAPI().getTop(after);
    response.then((RedditPosts res) => {
          setState(() {
            _items.addAll(res.posts);
            _after = res.after;
          })
        });
  }

  bool _needFetch(int index) {
    return (index + 1) >= _items.length;
  }

  Widget _buildRow(RedditPost post) {
    final String key = post.name;
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
        isThreeLine: true,
        onTap: () {
          _launchURL(post.url);
        },
      ),
      Divider()
    ]);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
