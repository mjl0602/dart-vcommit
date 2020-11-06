// 选择器用到的变量
import 'dart:io';
import 'dart:typed_data';

import '../data/type.dart';
import '../main.dart';

var longblank = '                                                           ';
List<String> get keyList => markInfo.keys.toList();
int get max => keyList.length - 1;
String get key => keyList[selectIndex];
int selectIndex = 0;

/// 更新屏幕上的文字
updateSelectText() {
  var targetMark = markTag[key];
  var text = ' 预览:  '
      "[$version]$targetMark: $content";
  stdout.write('\r$text     \r');
}

/// 等待用户选择一种提交类型
Future<String> select() async {
  if (Platform.isWindows) {
    stdin.lineMode = true;
    stdin.echoMode = true;
  } else {
    stdin.lineMode = false;
    stdin.echoMode = true;
  }
  print('> 请使用方向键选择一种Commit类型，使用enter确认，按下 h 获取帮助:');
  updateSelectText();
  await for (var cha in stdin) {
    if (cha is Uint8List) {
      if (cha.length == 3) {
        var keyValue = cha.join('');
        var upValue = keyMap[keyValue];
        if (upValue == null) {
          updateSelectText();
          continue;
        }
        if (upValue == 1) {
          selectIndex = (selectIndex - 1).clamp(0, max);
        }
        if (upValue == 2) {
          selectIndex = (selectIndex + 1).clamp(0, max);
        }
        updateSelectText();
      } else {
        updateSelectText();
      }
      if (cha.length == 1) {
        // 按下h按键
        if (cha.first == 104) {
          var helpText = keyList
              .map((key) => '${markTag[key]}:${markInfo[key]}')
              .join('\n');
          print('\r帮助:${longblank}\n$helpText\n');
          updateSelectText();
        }
        if (cha.first == 10) {
          return keyList[selectIndex];
        }
      }
    }
  }
  return null;
}
