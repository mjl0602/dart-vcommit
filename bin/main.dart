import 'dart:io';

import 'package:args/args.dart';

var markList = [
  "feat",
  "fix",
  "docs",
  "style",
  "refactor",
  "perf",
  "test",
  "build",
  "ci",
  "chore",
  "revert"
];
main(List<String> args) {
  ArgResults _argResults;
  // 创建ArgParser的实例，同时指定需要输入的参数
  final ArgParser argParser = new ArgParser()
    ..addFlag(
      'up',
      abbr: 'u',
      help: "版本号+1",
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: "查看指令帮助",
    );
  for (var mark in markList) {
    argParser.addFlag(
      mark,
      // abbr: 'u',
      negatable: false,
      help: "添加标记:$mark",
    );
  }
  _argResults = argParser.parse(args);
  if (_argResults['help'] || _argResults.arguments.length == 0) {
    print('${argParser.usage}');
    return;
  }
  _argResults = argParser.parse(args);
  var command = _argResults.arguments.first;
  print('执行命令:$command');
  print(args);

  String version = "1.2.2";
  String mark = "Fixed";
  String content = 'init commit';
  var res = Process.runSync(
    "git",
    ["commit", "-m", "'[$version]$mark: $content'"],
    runInShell: true,
  );
  print(res.exitCode);
}

enum ProjectType {
  unknown,
  js,
  spring,
  flutter,
  ios,
  android,
}

/// 当前项目
class Project {
  final String currentVersion;

  Project(this.currentVersion);
}
