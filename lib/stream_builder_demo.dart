import 'dart:async';

import 'package:flutter/material.dart';

/// Stream 能让你在更新 UI 是避免使用 setState 方法，
/// 这也是处理异步除 Future 之外另一种很有趣的方式。
/// 在 Stream 的世界里你可以将它理解为一个管道，在管道的一边你会监听它，
/// 在管道的另一边你会往这个管道里去添加数据，
/// 管道监听的一边能收到你往这个管道里添加的数据，
/// 这种方式你也可以从观察者模式上去假设记忆般的理解
class StreamBuilderDemo extends StatefulWidget {
  static const String routeName = "/stream";

  @override
  _StreamBuilderDemoState createState() => _StreamBuilderDemoState();
}

class _StreamBuilderDemoState extends State<StreamBuilderDemo> {
  int num = 0;
  StreamController<String> _streamController = StreamController<String>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stream"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("$num"),
            RaisedButton(
              child: Text("单订阅流"),
              onPressed: () {
                StreamController<int> cr = new StreamController();
                cr.stream.listen((data) {
                  num = data;
                  debugPrint('stream:$data');
                });
                cr.sink.add(1);
                cr.sink.add(2);
                cr.sink.add(3);
                cr.close();
              },
            ),
            RaisedButton(
              child: Text("广播Stream"),
              onPressed: () {
                StreamController<int> cr2 = new StreamController();
                final st = StreamTransformer<int, String>.fromHandlers(
                    handleData: (int data, sink) {
                  if (data == 10) {
                    sink.add('添加正常');
                  } else {
                    sink.addError('添加错误');
                  }
                });

                cr2.stream.transform(st).listen((String data) {
                  debugPrint(data);
                }).onError((e) {
                  debugPrint('$e');
                });

                /// 通过 sink 像 Stream 中添加数据
                cr2.sink.add(11);
                cr2.sink.add(10);
                cr2.sink.add(12);

                cr2.close();
              },
            ),
            RaisedButton(
              child: Text("Stream 更新UI"),
              onPressed: () {
                num++;
                _streamController.sink.add("$num");
              },
            ),
            StreamBuilder<String>(
              stream: _streamController.stream,
              /// snapshot 快照
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                print(snapshot);
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                return Text(snapshot.data);
              },
            )
          ],
        ),
      ),
    );
  }
}

