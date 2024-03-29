import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;

import 'controller/confirm.dart';
import 'controller/select.dart';
import 'data/argParser.dart';
import 'data/type.dart';
import 'model/project.dart';

/// 脚本运行路径
Uri shellPath = Uri.parse(path.join(Platform.environment['PWD'] ?? ''));

late ArgResults argResults;
String? version;
String? content;

/// 主方法，返回值：1-显示帮助，0-正常运行，-1-运行出错
Future<int> main(List<String> args) async {
  // print(Platform.environment);
  /// 是否使用Emoji

  /// 防止误输入
  args = List.from(args, growable: true);
  args.remove('commit');

  /// read windows path
  if (Platform.isWindows) {
    var _path = Process.runSync(
      "chdir",
      [],
      runInShell: true,
    ).stdout.replaceAll('\r\n', '');
    shellPath = path.toUri(_path);
  }

  /// 解析输入
  argResults = argParser.parse(args);
  useEmoji = argResults['emoji'];
  argResults = argParser.parse(args);

  if (argResults['testing']) {
    print('Testing Arg:$args');
  }

  /// 指定运行路径
  if (argResults['path'] != null) {
    shellPath = path.toUri(argResults['path']);
  }

  /// 读取当前目录
  Project? project;
  try {
    project = Project.currentPath();
  } catch (e) {
    print('读取当前项目出错');
  }

  /// 输入help或者没有输入任何参数
  if (argResults['help'] || argResults.arguments.length == 0) {
    print('命令大全');
    print('${argParser.usage}');
    if (project != null) {
      print('\n当前项目版本号: ${project.version}');
    }
    print('\n命令示例: vcm --feat "添加登陆功能"');
    print('生成提交: [0.1.1+2]Feat: 添加登陆功能\n');
    return 1;
  }

  if (project == null) {
    print('不支持当前项目格式');
    return -1;
  }

  /// 查询项目版本
  version = project.version;
  // print(argResults.rest);
  content = argResults.rest.join(' ');
  if ((content?.replaceAll(' ', '') ?? '').isEmpty) {
    print('没有填写提交内容');
    return -1;
  }

  /// 查询标记
  String? targetMark;
  // 是否从标记选择
  bool isSetFromSelect = false;
  // print(_argResults.arguments);
  // print(_argResults.rest);
  // 先找当前标记
  for (var mark in markInfo.keys) {
    if (targetMark != null) {
      break;
    }
    if (argResults[mark] == true) {
      targetMark = markTag[mark];
      break;
    }
  }

  /// 没有可用标记就触发选择工具来选择标记
  if (targetMark == null) {
    if (Platform.isWindows) {
      print('Windows不支持方向键选择标签，只能使用命令行标记');
      print('例如: vcm --fix "修复了一些bug"');
      print('要查看命令行标记帮助，请运行vcm -h');
      return 0;
    }
    targetMark = argResults['testing'] ? 'test' : await select();
    isSetFromSelect = targetMark != null;
    targetMark = markTag[targetMark];
  }

  /// 检查必备参数
  if (targetMark == null) {
    print("在指令中找不到可用的Commit标记，参数内容:${args}");
    return -1;
  }

  print('读取到版本: $version.');

  /// 生成提交内容并确认
  var commitContent = "[$version]$targetMark: $content";
  print('请确认提交内容:\n$commitContent');
  // 如果使用了-y参数或者在单元测试，是不需要返回的
  bool willContinue =
      (argResults['yes'] || argResults['testing'] || isSetFromSelect)
          ? true
          : confirm();
  if (willContinue == false) {
    return -1;
  }

  /// git add .
  if (argResults['add']) {
    print('Run: git add .');
    Process.runSync(
      "git",
      ["add", "."],
      runInShell: true,
    );
  }

  if (argResults['testing']) {
    print("Test Result: $commitContent");
    return 0;
  }
  print(["git", "commit", "-m", commitContent].join(' '));

  /// 运行git commit命令
  var res = Process.runSync(
    "git",
    ["commit", "-m", commitContent],
    runInShell: true,
  );
  print("code:${res.exitCode}");
  if (res.stderr.toString().isNotEmpty) {
    print("Err: ${res.stderr}");
  }
  print('Out: ${res.stdout}');

  /// 直接Push
  if (argResults['push']) {
    print('Run:git push...');
    // 运行git push
    var res = Process.runSync(
      "git",
      ["push"],
      runInShell: true,
    );
    print("code:${res.exitCode}");
    if (res.stderr.toString().isNotEmpty) {
      print("Err: ${res.stderr}");
    }
    print('Out: ${res.stdout}');
  }
  return 0;
}
