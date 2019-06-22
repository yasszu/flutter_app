import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class Home extends StatefulWidget {

  @override
  HomeState createState() => new HomeState();

}

class HomeState extends State<Home> {

  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

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
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (needFetch(index)) {
            fetchWords();
          }
          return _buildRow(_suggestions[index]);
        });
  }

  bool needFetch(int index) {
    return index >= _suggestions.length;
  }

  void fetchWords() {
    _suggestions.addAll(generateWordPairs().take(10)); /*4*/
  }

  Widget _buildRow(WordPair pair) {
    final String word = pair.asPascalCase + "#" + _suggestions.length.toString();
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        word,
        style: _biggerFont,
      ),
      trailing: new Icon(   // Add the lines from here...
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
    );
  }

}
