import 'dart:io';

import '../bin/main.dart' as VCommit;
import 'package:path/path.dart' as path;

main(List<String> args) async {
  for (var test in testList) {
    await test.run();
  }
}

List<TestOption> testList = [
  TestOption(
    name: "直接运行",
    description: "直接运行，应当显示-h内容",
    expect: 1,
    testFunc: () async => VCommit.main([]),
  ),
  TestOption(
    name: "显示帮助",
    description: "直接运行，应当显示-h内容",
    expect: 1,
    testFunc: () async => VCommit.main(["-h", '--testing']),
  ),
  TestOption(
    name: "Node",
    description: "测试Node项目(JS)",
    testFunc: () async => VCommit.main([
      "Run Unit Test",
      "--path",
      path.normalize(path.join(
        Platform.script.path,
        '../../example/node/',
      )),
      '--testing',
    ]),
  ),
  TestOption(
    name: "Pub",
    description: "测试Pub项目(Dart)",
    testFunc: () async => VCommit.main([
      "Run Unit Test",
      "--path",
      path.normalize(path.join(
        Platform.script.path,
        '../../example/pub/',
      )),
      '--testing',
    ]),
  ),
  TestOption(
    name: "Java",
    description: "测试Java项目(Spring)",
    testFunc: () async => VCommit.main([
      "Run Unit Test",
      "--path",
      path.normalize(path.join(
        Platform.script.path,
        '../../example/spring/',
      )),
      '--testing',
    ]),
  ),
];

class TestOption {
  final String name;
  final String description;
  final int expect;
  final Future<int> Function() testFunc;

  TestOption({
    this.name,
    this.description,
    this.testFunc,
    this.expect: 0,
  });

  Future run() async {
    print('\n===Test: $name');
    print('Description: $description');
    print('Running...');
    int result = await testFunc?.call();
    assert(result == expect);
    print('End With: $result');
    print('===End');
  }
}
