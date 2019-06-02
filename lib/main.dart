import 'package:flutter/material.dart';
import './random_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// 定义一个单词随机对
    // final wordPair = new WordPair.random();
    // return new MaterialApp(
    //   title: 'Welcome to Flutter',
    //   home: new Scaffold(
    //     appBar: new AppBar(
    //       title: new Text('Welcome to Flutter'),
    //     ),
    //     body: new Center(
    //       // child: new Text(wordPair.asPascalCase),
    //       child: new RandomWords(),
    //     ),
    //   ),
    // );
    /// TODO: MaterialApp 与 Scaffold 是什么关系？它们的作用分别是什么？
    return new MaterialApp(
      title: 'Startup Name Generator',

      ///TODO: 7.使用主题更改UI
      ///7.1改变primary color 为 white
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new RandomWords(),
    );
  }
}
