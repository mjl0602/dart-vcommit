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

  /// 读取当前目录
  Project project = Project.currentPath();
  if (project == null) {
    print('不支持当前项目格式');
    return;
  }

  /// 查询项目版本
  String version = project.currentVersion;
  String mark = "Fixed";
  String content = _argResults.rest.join(' ');
  if (content.replaceAll(' ', '').isEmpty) {
    print('没有填写提交内容');
    return;
  }
  print('版本: $version');
  var res = Process.runSync(
    "git",
    ["commit", "-m", "'[$version]$mark: $content'"],
    runInShell: true,
  );
  print(res.exitCode);
  print("Err: ${res.stderr}");
  print('Out: ${res.stdout}');
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

/// 正则获取版本号内容
/// r是屏蔽转义，直接输入目标字符，就不用写[\\s \\n]这种东西了
Map<ProjectType, RegExp> targetMap = {
  ProjectType.pub: RegExp(r'(?<=version:\s)(.+?)\n'),
  ProjectType.node: RegExp(r'(?<=:\s")(.+?)(?=",)'),
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
    var dir = Directory.fromUri(shellPath);
    for (var file in dir.listSync()) {
      var name = path.basename(file.path);
      type = typeMap[name];
      if (type != null) {
        print(type);
        currentVersion = versionFromFile(file, type);
        break;
      }
    }
    if (type == null) return null;
    return Project._(currentVersion, type);
  }

  /// 从当前目录读取目标版本号
  static String versionFromFile(File file, ProjectType type) {
    var content = file.readAsStringSync();
    // 使用正则匹配
    return targetMap[type].stringMatch(content);
  }
}
