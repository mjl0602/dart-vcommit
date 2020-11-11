// 创建ArgParser的实例，同时指定需要输入的参数
import 'package:args/args.dart';

import 'type.dart';

ArgParser get argParser {
  var _parser = ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: "查看指令帮助",
    )
    ..addFlag(
      'emoji',
      abbr: 'e',
      negatable: true,
      defaultsTo: false,
      help: "是否显示emoji表情",
    )
    ..addFlag(
      'yes',
      abbr: 'y',
      negatable: false,
      help: "是否无需确认",
    )
    ..addFlag(
      'push',
      abbr: 'p',
      negatable: false,
      help: "在commit后push",
    )
    ..addOption(
      'path',
      help: "在指定路径运行",
    )
    ..addFlag(
      'testing',
      negatable: false,
      help: "正在运行单元测试（测试用）",
    )
    ..addFlag(
      'add',
      defaultsTo: true,
      negatable: true,
      help: "是否要先运行git add .",
    );

  for (var i = 0; i < markInfo.keys.length; i++) {
    String mark = markInfo.keys.toList()[i];
    String index = '${i + 1}.'.padRight(3, ' ');
    _parser.addFlag(
      mark,
      abbr: (i + 1).toRadixString(16),
      negatable: false,
      help: "$index ${markTag[mark]}:${markInfo[mark]}",
    );
  }
  return _parser;
}
