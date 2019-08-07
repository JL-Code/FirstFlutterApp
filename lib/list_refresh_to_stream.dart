import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:first_flutter_app/models/emotion.dart';
import 'package:first_flutter_app/models/news.dart';
import 'package:first_flutter_app/utils/text_util.dart';
import 'package:flutter/material.dart';

class ListRefreshToStream extends StatefulWidget {
  @override
  _ListRefreshToStreamState createState() => _ListRefreshToStreamState();
}

class _ListRefreshToStreamState extends State<ListRefreshToStream> {
  final StreamController<List<News>> _streamController =
      StreamController<List<News>>();
  final List<News> _innerList = List<News>();
  final List<Emotion> _emotions = List<Emotion>();
  final Map<String, String> _mapEmotion = Map<String, String>();
  int currentPage = 1;

  @override
  void initState() {
    _initEmotions();
    _fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  /// 构建列表
  _buildList(List<News> newsList) {
    return ListView.separated(
      /// 这里数据+1 表示最后一项,用于显示加载状态
      itemCount: newsList.length + 1,
      itemBuilder: (context, index) {
        debugPrint("_buildList: $index");
        if (index == newsList.length) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("加载更多"),
                onPressed: () {
                  _fetchData();
                },
              )
            ],
          );
        } else {
          var news = newsList[index];
          return _ListTile(
            /// LocalKey、GlobalKey
//            key: ValueKey<int>(news.id),
            title: Text("id:${news.id}" + news.title),
            news: news,
            emotions: _mapEmotion,
          );
        }
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  /// 获取远程数据
  _fetchData() async {
    try {
      HttpClient client = new HttpClient();
      String url = "http://www.wlinling.com/news?_page=$currentPage&_limit=20";

      /// 可以在这里设置请求头
      /// 然后调用 close
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      String responseBody = await response.transform(utf8.decoder).join();

      /// dart json 解析列表结构数据
      /// [How do I deserialize a JSONArray?](https://github.com/dart-lang/json_serializable/issues/135)
      List list = json.decode(responseBody);
      List<News> newsList = list.map((model) => News.fromJson(model)).toList();
      _innerList.addAll(newsList);
      _streamController.add(_innerList);
      debugPrint("http ok currentPage:$currentPage");
      debugPrint("http ok url:$url");
      currentPage++;
//      print(responseBody);
      print(newsList.first.id);
      print(newsList.last.id);
    } catch (e) {
      print(e);
    }
  }

  /// 初始化表情包数据
  _initEmotions() async {
    try {
      var jsonStr =
          await DefaultAssetBundle.of(context).loadString("json/emotion.json");
      List list = json.decode(jsonStr);
      _emotions.clear();
      _emotions.addAll(list.map((item) => Emotion.fromJson(item)));
      _emotions.forEach((emotion) {
        _mapEmotion[emotion.value] = emotion.url;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("StreamBuilder"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _fetchData();
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
          if (!snapshot.hasData) {
            debugPrint("Stream 暂无数据");
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            );
          } else {
            return _buildList(snapshot.data);
          }
        },
      ),
    );
  }
}

/// list item
class _ListTile extends StatelessWidget {
  final Widget title;
  final News news;
  final Map<String, String> emotions;

  _ListTile({Key key, this.title, this.news, this.emotions}) : super(key: key);

  _buildGallery(List<String> urls) {
    if (urls.isEmpty) {
      return null;
    }

    /// Wrap 自动换行
    return Wrap(
      spacing: 4, // 主轴(水平)方向间距
      runSpacing: 4, // 纵轴（垂直）方向间距
      children: _buildGridTileList(urls),
    );
  }

  /// 构建图片列表
  _buildGridTileList(List<String> urls) {
    return List<Container>.generate(
      urls.length,
      (int index) {
        return Container(
          child: FadeInImage.assetNetwork(
            placeholder: "images/default_nor_avatar.png",
            height: 100,
            width: 100,
            image: urls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("_ListTile build");
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          title,
          TextUtil.format(news.desc, emotions),
          SizedBox(height: 10),
          _buildGallery(news.images),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("tag: ${news.tag}"),
              Text("views: ${news.views}"),
            ],
          )
        ],
      ),
    );
  }
}

/// 数据加载更多基类
/// [TData] 页面数据类型
/// [TModel]
/// 继承了List 基类
abstract class DataLoadMoreBase<TData, TModel> extends ListBase<TData> {}
