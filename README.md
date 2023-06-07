## 快捷键
- bin/setup 下载依赖，创建数据库
- bin/dev   解析我们的css,js，并开启项目
- bin/rails g system_test quotes 生成一个系统测试
- rails db:seed 从seed中创建数据到development表中
- rails db:fixtures:load 从测试数据fixtures中获取数据，并添加到development表中

## 学习总结：
### Turbo Drive

在Rails7中使用`Turbo Drive`可以加速整个系统相应，因为它会拦截所有的请求转为Ajax请求，包括form表达提交和页面跳转。其中显著的观察，就是通过控制台，可以看到，当使用ajaxa请求后，只有在页面第一次被访问时，才会加载js，css文件。当之后访问时，只局部更新<body>,其工作原理就是通过拦截请求，并对其进行改造, `Turbo Drive`是rails7默认依赖的，所以我们可以直接使用。

当然在某些情况下，我们不想使用Turbo Drive，比如一些其他的gem无法适配，那推荐是在不能适配的组件上，选择`data: { turbo: false }`。比如：

```erb
# link_to :
<%= link_to "New quote",
                new_quote_path,
                class: "btn btn--primary",
                data: { turbo: false } %>

# form_with :
<%= simple_form_for quote,
                    html: {
                      class: "quote form",
                      data: { turbo: false }
                    } do |f| %>
```

或者你也可以全部关闭：
```js
// app/javascript/application.js

import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
```

需要注意的一点，如果<header>中的css，js不再加载更新，那如果系统更新了，用户是无法享受的，所以需要设置：
```erb
<%# app/views/layouts/application.html.erb %>

<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
<%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
```

这样在请求时，就会判断css，js是否被更改过，如果更改过，则进行从新导入，如果没有，则不再导入。

### Turbo Frames
Turbo Frames 是一个独立的网页，可以被添加，替换，删除，而不需要刷新整个页面，并且只需要写一行js代码。

> 规则一：
当你点击一个包含于Turbo Frame的链接时，Turbo会在目标页面中去找拥有同样ID的frame，并且去替换原先页面同ID的frame内容。
> 规则二：
当你点击一个包含于Turbo Frame的链接时，如果目标页面没有相同ID的frame，则原先页面中该ID的frame会消失，并且会在控制台中报错：`the error Response has no matching <turbo-frame id="name_of_the_frame"> element`
> 规则三：
一个链接可以**指定**一个不直接嵌套在其中的Turbo Frame。在这种情况下，源页面上具有与data-turbo-frame数据属性相同id的Turbo Frame将由目标页面上具有与data-turbo-frame数据属性相同id的Turbo Frame替换。 这一点比较抽象。比如我原页面中有有两个被turbo_frame标签包裹，一个是id为first，一个id为second，当我使用id为first包裹的组件总请求其他页面时，默认会去找该页面有没有id为first的frame去替换，像上面的规则，但如果我们在data中设置：`turbo_frame: "second"`，则它就会去找id为second的frame去替换

> 如何取id？有更好的实践
turbo_frame_tag helper 有一个组件：`dom_id`，可以传递字符串，对象从而转为id，比如：
```ruby
# If the quote is persisted and its id is 1:
dom_id(@quote) # => "quote_1"

# If the quote is a new record:
dom_id(Quote.new) # => "new_quote"

# Note that the dom_id can also take an optional prefix argument
# We will use this later in the tutorial
dom_id(Quote.new, "prefix") # "prefix_new_quote"
```
这个不需要我们主动调用dom_id,直接传递即可。

> 还有一个问题，当我们使用Turbo Frame包裹内容时，如果内部包含其他的标签，则点击时，无法找到对应的id，控制台就会报错。
所以如果是需要切换页面的，我们使用dom_id去替换，如果没有，传递：`data: { turbo_frame: "_top" }`

> 还有一个问题，当我们先替换了部分页面，则时候下方操作其他数据时，页面刷新，也会导致替换页面失效
这里我们引出：`TURBO_STREAM`


### TURBO_STREAM format
可以让我们轻松的，替换，插入，删除，入队列，出队列的控制页面，而不需要写一句Js


