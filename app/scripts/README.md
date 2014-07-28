* controllers.js
* filters.js
* directives.js

这三个文件是对应的文件夹内js合并的输出（通过grunt监听实现），不用管。

* _prefix.js
* _suffix.js

这两个文件是为了让所有脚本被包裹成下面的格式：

```javascript
!function() {
  // all codes here
  ...
}()
```
