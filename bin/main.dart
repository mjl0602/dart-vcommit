import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;

/// 脚本存放路径
// Uri templatePath = Platform.script.resolve('../template/');

/// 脚本运行路径
Uri shellPath = Uri.parse(path.join(Platform.environment['PWD']));

var markInfo = [
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
  for (var mark in markInfo) {
    argParser.addFlag(
      mark,
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
  Project project = Project.currentPath();
  if (project == null) {
    print('不支持当前项目格式');
    return;
  }
  String version = project.currentVersion;
  String mark = "Fixed";
  String content = 'init commit';
  print('$version');
  // var res = Process.runSync(
  //   "git",
  //   ["commit", "-m", "'[$version]$mark: $content'"],
  //   runInShell: true,
  // );
  // print(res.exitCode);
  // print("Err: ${res.stderr}");
  // print('Out: ${res.stdout}');
}

enum ProjectType {
  unknown,
  node,
  spring,
  pub,
  ios,
  android,
}

Map<String, ProjectType> typeMap = {
  "pubspec.yaml": ProjectType.pub,
  "package.json": ProjectType.node,
};

/// 当前项目
class Project {
  final String currentVersion;
  final ProjectType type;
  Project._(this.currentVersion, this.type);

  /// 读取当前目录文件，判断项目类型
  /// 如果没有任何匹配，返回null
  factory Project.currentPath() {
    String currentVersion;
    ProjectType type;
    print('shellPath:$shellPath');
    var dir = Directory.fromUri(shellPath);
    for (var file in dir.listSync()) {
      var name = path.basename(file.path);
      type = typeMap[name];
      if (type != null) {
        break;
      }
    }
    currentVersion = "$type";
    if (type == null) {
      return null;
    }
    return Project._(currentVersion, type);
  }
}
