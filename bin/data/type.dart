/// 支持的按键键值
var keyMap = {
  "279165": 1, // up
  "279166": 2, // down
};

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
  "pom.xml": ProjectType.spring,
};

/// 正则获取版本号内容
/// r是屏蔽转义，直接输入目标字符，就不用写[\\s \\n]这种东西了
Map<ProjectType, RegExp> targetMap = {
  ProjectType.pub: RegExp(r'(?<=version:\s)(.+?)(?=\n)'),
  ProjectType.node: RegExp(r'(?<=version":\s")(.+?)(?=",)'),
  // XML需要单独的解析
  ProjectType.spring: RegExp(r''),
};

var markInfo = {
  "feat": "新功能（feature）",
  "fix": "修补bug",
  "docs": "文档（documentation）",
  "style": "格式（不影响代码运行的变动）",
  "refactor": "重构（既不是新增功能，也不是修改bug的代码变动）",
  "perf": "性能优化",
  "test": "增加测试",
  "build": "打包",
  "ci": "持续集成",
  "chore": "构建过程或辅助工具的变动",
  "revert": "撤销，版本回退"
};

var markTag = {
  "feat": "😘Feat",
  "fix": "🔧Fix",
  "docs": "📖Docs",
  "style": "🌼Style",
  "refactor": "🔭Refactor",
  "perf": "🚁Perf",
  "test": "🛂Test",
  "build": "🔨Build",
  "ci": "🚬CI",
  "chore": "🔔Chore",
  "revert": "⏰Revert"
};
