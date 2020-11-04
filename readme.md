

# VCommit

# 安装

```shell
git clone https://github.com/mjl0602/dart-vcommit.git
cd dart-vcommit
pub global activate --source path ./
```

有时候只有安装dart才有pub包管理（而不是仅仅安装flutter就可以）

你需要
```
brew install dart
```

总之要先安装pub
# dart2native

dart2native不支持交叉编译，在每个平台上只能编译当前平台的机器码
```bash
# 请只在mac上运行
dart2native bin/main.dart -o build/dart-vcommit-mac
# 请只在windows上运行
dart2native bin/main.dart -o build/dart-vcommit-win.exe
```