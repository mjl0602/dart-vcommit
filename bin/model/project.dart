import 'dart:io';

import 'package:xml/xml.dart' as xml;
import 'package:xml/xml_events.dart';

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
    String currentVersion;
    ProjectType type;
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
        currentVersion = versionFromFile(file, type);
        if (currentVersion?.isEmpty != false) {
          continue;
        }
        break;
      }
    }
    if (type == null) return null;
    return Project._(currentVersion, type);
  }

  /// 从当前目录读取目标版本号
  static String versionFromFile(File file, ProjectType type) {
    var content = file.readAsStringSync();
    if (type == ProjectType.spring) {
      var all = xml.parse(content).findElements('project').toList();
      for (var element in all) {
        var res = element.findElements('version').toList();
        if (res.length > 0) {
          print(res.first.text);
          print(res.first.text.length);
          return res.first.text;
        }
      }
      return null;
    }
    // 使用正则匹配
    return targetMap[type].stringMatch(content);
  }
}
