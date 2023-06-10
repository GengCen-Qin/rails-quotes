## 项目介绍：
​	本项目是为了方便英语不太好的Ruby On Rails初学者进行学习，项目来源于[The Turbo Rails Tutorial](https://www.hotrails.dev/)。

​	使用Rails7进行开发一个现代的单页响应式web应用程序，而无需编写任何自定义JavaScript代码。线上展示成品：https://www.hotrails.dev/quotes

​	通过本次教程的学习，你将了解Turbo如何与Rails搭配使用，并学习到如何编写增删改查代码，自定义样式组织，测试驱动开发，Turbo Drive，Turbo Frames，Turbo Stream等内容，具体可看官网目录，本次教程翻译也是按照官网章节划分，具体翻译文件保留在：**项目根目录下的翻译文件夹。**

​	因为是我个人翻译的，所以难免会有语句不通，错别字，语句歧义等问题，所以当您发现问题或感到疑惑时，建议对照着官网再理解一下，并希望您能给出意见，方便我及时的修改与维护。希望每个学习者都能有所收获，并为Ruby社区贡献一份力量。	

## 项目如何启动
1. ./bin/setup   # 下载gem，js依赖，创建，迁移，存储数据到数据库。
2. yarn install  # 因为项目使用了esbuild
3. rails db:seed # 导入数据 
4. ./bin/dev     # 启动项目

## 苹果兼容

> 我在使用Mac mini2学习时，使用Devise gem时出现不适配的问题，如果你有类似情况，可以参考。

- **注意：**在执行`rails db:seed`是，我的电脑(Mac mini2 arm64)在执行bcrypt进行加密时，爆出错误：`is an incompatible architecture (have 'x86_64', need 'arm64')`

  1. 查看你的`Gemfile.lock`,看是否和下面一样

  ```yml
  PLATFORMS
    arm64-darwin-22
  ```

  2. 如果是，则在控制台执行: `uname -m`，查看是否为：**x86_64**

  如果情况一致，说明你在 Rosetta 模拟器中运行 Ruby 和 gem 时，它们会认为你的系统仍然是 ARM 架构，所以执行 `bundle install` 或 `gem install` 时会生成 `arm64-darwin-22` 的 `Gemfile.lock` 中的 `PLATFORMS`。

  可以看到两者出现了偏差，当我们执行`bundle install`时，将使用当前终端窗口所处的编译架构来编译 gem，而这时候我们是通过Rosetta模拟器在x86_64架构上安装的gem，所以默认使用x86_64架构编译gem，并将这些gem安装到x86_64架构目录上。所以我们会在报错信息中看到空文件的提示。

  `arch -arm64 bundle install` 命令使用 `-arm64` 标志来显式指定了命令应该在 ARM64 架构下执行。这意味着它将使用 ARM64 架构编译 gem，并将这些 gem 安装到 ARM64 目录下，而不管终端窗口当前所处的架构是什么。

  所以这里我们应该使用`arch -arm64 bundle install`命令以确保所有 gem 都被正确地编译和安装到 ARM64 架构目录下。这样就可以匹配上了，如果没用，则先清理掉之前的gem:`gem uninstall devise bcrypt` 
