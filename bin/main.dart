import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;

/// 脚本存放路径
// Uri templatePath = Platform.script.resolve('../template/');

/// 脚本运行路径
Uri shellPath = Uri.parse(path.join(Platform.environment['PWD']));

var markInfo = {
  "feat": "新功能（feature）",
  "fix": "修补bug",
  "docs": "文档（documentation）",
  "style": "格式（不影响代码运行的变动）",
  "refactor": "重构（既不是新增功能，也不是修改bug的代码变动）",
  "perf": "",
  "test": "增加测试",
  "build": "",
  "ci": "",
  "chore": "",
  "revert": ""
};
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
  // 构建列表
  for (var mark in markInfo.keys) {
    argParser.addFlag(
      mark,
      negatable: false,
      help: markInfo[mark],
    );
  }
  _argResults = argParser.parse(args);
  if (_argResults['help'] || _argResults.arguments.length == 0) {
    print('${argParser.usage}');
    return;
  }
  _argResults = argParser.parse(args);
  print('执行命令: ${_argResults.arguments}');

  /// 读取当前目录
  Project project = Project.currentPath();
  if (project == null) {
    print('不支持当前项目格式');
    return;
  }

  /// 查询项目版本
  String version = project.currentVersion;
  String content = _argResults.rest.join(' ');
  if (content.replaceAll(' ', '').isEmpty) {
    print('没有填写提交内容');
    return;
  }
  print('读取到版本: $version.');

  /// 查询标记
  String targetMark;
  for (var mark in markInfo.keys) {
    if (_argResults[mark] == true) {
      targetMark = mark.replaceRange(0, 1, mark.split('').first.toUpperCase());
      break;
    }
  }
  if (targetMark == null) {
    print("命令标记无效: ${args}");
    return;
  }

  /// 生成提交内容并确认
  var commitContent = "'[$version]$targetMark: $content'";
  print('请确认提交内容:\n$commitContent');
  bool willContinue = confirm();
  if (willContinue == false) {
    return;
  }

  /// 运行git commit命令
  var res = Process.runSync(
    "git",
    ["commit", "-m", commitContent],
    runInShell: true,
  );
  print("exitCode:${res.exitCode}");
  if (res.stderr.toString().isNotEmpty) {
    print("Err: ${res.stderr}");
  }
  print('Out: ${res.stdout}');
}

bool confirm() {
  stdout.add('Please Confirm (y/n):'.codeUnits);
  var input = stdin.readLineSync(retainNewlines: true);
  input = input.replaceAll('\n', '').toLowerCase();
  if (input == "n") {
    return false;
  }
  if (input == "y") {
    return true;
  }
  return confirm();
}

/// 全部项目类型
enum ProjectType {
  unknown,
  node,
  spring,
  pub,
  ios,
  android,
}

/// 关键文件对应的类型
Map<String, ProjectType> typeMap = {
  "pubspec.yaml": ProjectType.pub,
  "package.json": ProjectType.node,
};

/// 正则获取版本号内容
/// r是屏蔽转义，直接输入目标字符，就不用写[\\s \\n]这种东西了
Map<ProjectType, RegExp> targetMap = {
  ProjectType.pub: RegExp(r'(?<=version:\s)(.+?)(?=\n)'),
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
        // print(type);
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
