import 'package:flutter/material.dart';
import 'package:first_flutter_app/widgets/real_rich_text.dart';

class TextUtil {
  static const _separator = "\u4f60";
  static final RegExp tagPattern = RegExp("#[^#]+#");

  static String parse(String input) {
    input.replaceAll(tagPattern, "replace");
    return "";
  }

  /// 格式化文本
  static Widget format(String input, Map<String, String> emotions) {

    if (emotions == null) return Text(input);
//    var input = "小朋友们第一次坐船闹出各种开心事，简直就是开心果本果啊[笑cry][太开心][吃惊]";
    var exp = RegExp(r"(\[[^[\]|\[]+\])");
    input = input.replaceAllMapped(exp, (Match m) {
      String match = m.group(0);
//      debugPrint("emotion：$match emotions: ${emotions[match]}");
      return "$_separator$match";
    });
    var texts = input.split(_separator);
//    emotions.forEach((k, v) => debugPrint("key:$k value:$v"));
    return RealRichText(
      List.generate(texts.length, (index) {
        var text = texts[index];
        var url = emotions[text];
//        debugPrint("text：$text url: $url");

        if (url != null) {
          return ImageSpan(
            NetworkImage(url),
            imageWidth: 16,
            imageHeight: 16,
          );
        } else {
          return TextSpan(
            text: text,
          );
        }
      }),
    );
  }

  /// 替换官方表情
  static String replaceEmotion(String input, Map<String, String> emotions) {
    // TODO: 目前采用循环表情列表来替换微博中可能包含的表情。
    emotions.keys.forEach((key) {
      input.replaceAll(key, emotions[key]);
    });
    return input;
  }
}
