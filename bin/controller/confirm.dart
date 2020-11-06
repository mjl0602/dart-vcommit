import 'dart:io';

/// 使用y/n确认输入
bool confirm() {
  stdout.write('请输入确认提交(y/n):');
  var input = stdin.readLineSync(retainNewlines: true);
  input = input.replaceAll('\n', '').replaceAll('\r', '').toLowerCase();
  if (input == "n") {
    return false;
  }
  if (input == "y") {
    return true;
  }
  return confirm();
}
