## 快捷键
- bin/setup 下载依赖，创建数据库
- bin/dev   解析我们的css,js，并开启项目
- bin/rails g system_test quotes 生成一个系统测试
- rails db:seed 从seed中创建数据到development表中
- rails db:fixtures:load 从测试数据fixtures中获取数据，并添加到development表中

## 项目如何启动
1. ./bin/setup
2. yarn install # 因为里面使用了esbuild
3. rails db:seed
4. ./bin/dev