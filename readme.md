

# VCommit

VCommit自动为您的git commit附加当前项目的版本号，并支持选择添加Commit类型，添加对应类型标记与Emoji表情😘。

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

# 使用

命令示例: vcm --feat "添加登陆功能"  
生成提交: [0.1.1+2]😘Feat: 添加登陆功能

或者直接执行`vcm "添加了登陆功能"`，可以使用方向键选择一种类型提交。  
获取帮助请按h，取消该选择请按ctrl+c。

```bash
# 使用帮助
$ vcm 'update readme'
> 请使用方向键选择一种Commit类型，使用enter确认，按下 h 获取帮助:
帮助:                                                                                            
😘Feat:新功能（feature）
🔧Fix:修补bug
📖Docs:文档（documentation）
🌼Style:格式（不影响代码运行的变动）
🔭Refactor:重构（既不是新增功能，也不是修改bug的代码变动）
🚁Perf:性能优化
🛂Test:增加测试
🔨Build:打包
🚬CI:持续集成
🔔Chore:构建过程或辅助工具的变动
⏰Revert:撤销，版本回退

 预览:  [0.2.2+1]😘Feat: update readme 
```
# 原生平台运行

dart可以通过dart2native直接在原生平台运行，不需要dart环境

dart2native不支持交叉编译，在每个平台上只能编译当前平台的机器码

```bash
# 请只在mac上运行
dart2native bin/main.dart -o build/vcm
# 请只在windows上运行
dart2native bin/main.dart -o build/dart-vcommit-win.exe
```
