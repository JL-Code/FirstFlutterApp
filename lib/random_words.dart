import 'package:flutter/material.dart';

/// 1.引入第三方包 english_words 用于随机生成单词
import 'package:english_words/english_words.dart';
import './saved_words.dart';

/// 负责生成随机单词
class RandomWords extends StatefulWidget {
  RandomWords({Key key}) : super(key: key);

  _RandomWordsState createState() => _RandomWordsState();
}

///
class _RandomWordsState extends State<RandomWords> {
  /// 建议单词列表
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();

  /// TODO:赋值语句的右边为啥有 const 关键字 ？？？
  final _biggerFont = const TextStyle(fontSize: 18.0);

  /// build a suggestion words ListView Widget
  Widget _buildSuggestions() {
    print("_buildSuggestions");
    return new ListView.builder(
      /// 设置
      padding: EdgeInsets.all(16),
      itemBuilder: (BuildContext context, int i) {
        print("itemBuilder：$i");
        // final wordPair = new WordPair.random();
        // 在每一列之前，添加一个1像素高的分隔线widget
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;
        // 如果是建议列表中最后一个单词对
        if (index >= _suggestions.length) {
          // ...接着再生成10个单词对，然后添加到建议列表
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildListTile(_suggestions[index]);
      },
    );
  }

  /// build listtile
  Widget _buildListTile(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
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
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  /// 列表图标处理函数
  void _pushSaved() {
    ///TODO: MaterialPageRoute builder 创建的 Widget 可以是 StatefulWidget 吗？
    // Navigator.of(context).push(new MaterialPageRoute(
    //   builder: (context) {
    //     /// ListTile 集合
    //     final tiles = _saved.map((pair) {
    //       return _buildListTile(pair);
    //     });

    //     ///  Add a one pixel border in between each tile 在每个Tile之间添加1像素边框。
    //     final divided = ListTile.divideTiles(
    //       context: context,
    //       tiles: tiles,
    //     ).toList();

    //     /// 创建一个ListView
    //     return new Scaffold(
    //       appBar: new AppBar(
    //         title: new Text('Saved Suggestions'),
    //       ),
    //       body: new ListView(children: divided),
    //     );
    //   },
    // ));
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new SavedWords(
              saved: _saved,
            )));
  }

  @override
  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();
    /// 返回一个Text Widget
    // return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
