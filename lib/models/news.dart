class News {
  int id;
  int timestamp;
  String title;
  String desc;
  String tag;
  int views;
  List<String> images;

  News(
      {this.id,
      this.timestamp,
      this.title,
      this.desc,
      this.tag,
      this.views,
      this.images});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    title = json['title'];
    desc = json['desc'];
    tag = json['tag'];
    views = json['views'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['tag'] = this.tag;
    data['views'] = this.views;
    data['images'] = this.images;
    return data;
  }
}
