import 'dart:io';

import '../data/type.dart';
import 'package:path/path.dart' as path;

import '../main.dart';

/// 当前项目
class Project {
  final String version;
  final ProjectType type;
  Project._(this.version, this.type);

  /// 读取当前目录文件，判断项目类型
  /// 如果没有任何匹配，返回null
  factory Project.currentPath({bool self = false}) {
    String? currentVersion;
    ProjectType? type;
    print('Read Project:$shellPath');
    var dir = Directory.fromUri(
      self
          ? path.toUri(path.normalize(path.join(
              Platform.script.path,
              '../../',
            )))
          : shellPath,
    );
    for (var file in dir.listSync()) {
      var name = path.basename(file.path).replaceAll('.sample', '');
      type = typeMap[name];
      if (type != null) {
        currentVersion = versionFromFile(file as File, type);
        if (currentVersion?.isEmpty != false) {
          continue;
        }
        break;
      }
    }
    return Project._(currentVersion!, type!);
  }

  /// 从当前目录读取目标版本号
  static String? versionFromFile(File file, ProjectType type) {
    var content = file.readAsStringSync();
    // 使用正则匹配
    return targetMap[type]?.stringMatch(content);
  }
}
