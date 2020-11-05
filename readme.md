

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

# 使用

命令示例: vcm --feat "添加登陆功能"  
生成提交: [0.1.1+2]Feat: 添加登陆功能

或者直接执行`vcm "添加了登陆功能"`，可以使用方向键选择一种类型提交。  
取消该选择请按ctrl+c。

```
命令大全
-h, --help        查看指令帮助
-a, --[no-]add    先运行git add .
                  (defaults to on)
    --feat        新功能（feature）
    --fix         修补bug
    --docs        文档（documentation）
    --style       格式（不影响代码运行的变动）
    --refactor    重构（既不是新增功能，也不是修改bug的代码变动）
    --perf        性能优化
    --test        增加测试
    --build       打包
    --ci          持续集成
    --chore       构建过程或辅助工具的变动
    --revert      撤销，版本回退
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
