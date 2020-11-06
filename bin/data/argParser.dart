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
      'version',
      abbr: 'v',
      negatable: false,
      help: "查看当前版本",
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
    // ..addFlag(
    //   'runtest',
    //   negatable: false,
    //   help: "运行单元测试",
    // )
    ..addFlag(
      'testing',
      negatable: false,
      help: "正在运行单元测试（测试用）",
    )
    ..addFlag(
      'add',
      abbr: 'a',
      defaultsTo: true,
      negatable: true,
      help: "是否要先运行git add .",
    );
  // 构建标记列表
  for (var mark in markInfo.keys) {
    _parser.addFlag(
      mark,
      // abbr: mark,
      negatable: false,
      help: markInfo[mark],
    );
  }
  return _parser;
}
