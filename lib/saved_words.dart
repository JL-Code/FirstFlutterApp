import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class SavedWords extends StatefulWidget {
  final Set<WordPair> saved;

  SavedWords({Key key, @required this.saved}) : super(key: key);

  _SavedWordsState createState() => _SavedWordsState(saved);
}

class _SavedWordsState extends State<SavedWords> {
  /// TODO:声明集合类型需要初始化
  Set<WordPair> saved = new Set<WordPair>();
  _SavedWordsState(this.saved);
  final _biggerFont = const TextStyle(fontSize: 18.0);

  /// build listtile
  Widget _buildListTile(WordPair pair) {
    final alreadySaved = saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        /// 提示：在Flutter的响应式风格的框架中，调用setState() 会为State对象触发build()方法，从而导致对UI的更新
        setState(() {
          if (alreadySaved) {
            saved.remove(pair);
          } else {
            saved.add(pair);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tiles = saved.map((pair) {
      return _buildListTile(pair);
    }).toList();

    /// 创建一个ListView
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Saved Suggestions'),
      ),
      body: new ListView(children: tiles),
    );
  }
}
