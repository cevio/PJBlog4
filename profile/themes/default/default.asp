<%include(config.params.themeFolder + "/header");%>
    <div id="content-wrap">
        <div id="sidebar">
            <h3>Download</h3>
            <p>
            <div class="download" onclick="window.location.href='assets/system/javascript/sizzle.js'">Sizzle v4.0</div>
            </p>
            <h3>Wise Words</h3>
            <div class="left-box">
                <p>&quot;Manage your code, make it more perfect.&quot; </p>
                <p class="align-right">- Evio Shen</p>
            </div>
            <h3>Sizzle Plugins Demo</h3>
            <ul class="sidemenu">
                <li><a href="demo/sizzleload/" target="_blank">Sizzle Loader</a></li>
                <li><a href="demo/tipshow" target="_blank">Sizzle TipShow</a></li>
                <li><a href="demo/upload" target="_blank">Sizzle Upload</a></li>
                <li><a href="demo/flowlayer" target="_blank">Sizzle Flowlayer</a></li>
                <li><a href="demo/tabs/default.html" target="_blank">Sizzle Tabs</a></li>
            </ul>
            <h3>Link</h3>
            <ul class="sidemenu">
                <li><a href="http://bbs.pjhome.net" target="_blank">PJBlog BBS</a></li>
            </ul>
        </div>
        <div id="main">
            <h2>什么是sizzle？ sizzle何用？</h2>
            <p><strong>Sizzle</strong> 是一套前端用智能来处理模块和组件依赖关系的框架。 它遵循 <strong>CommonJS</strong> 的运行规范来完成对各个模块的动态加载。而且可以同时包含其他库而不产生冲突。 Sizzle的使用很简单，其下共有 5 个常用的方法， 只需要学习这 5 个方法便能将 Sizzle 框架驾驭完美。它们分别是 <strong>config()</strong> <strong>config.map()</strong> <strong>config.log()</strong> <strong>define()</strong> <strong>require()</strong>。具体的方法介绍请往下看。 其他我想说的是， Sizzle 经过了4个版本的修改，现在已经形成了稳定版本，大家可以放心使用。 如果在使用过程中还发现了什么问题，请及时联系我。具体联系方式请查找本站联系我。Sizzle 框架将被使用在 PJBlog4 新版本中，让我们的后台更加代码逻辑化和模块化。 那么，如何加载它呢，看代码： </p>
            <p>
            <pre>&lt;script language="javascript" src="http://assets.sizzle.cc/assets/system/javascript/sizzle.js"&gt;&lt;/script&gt;</pre>
            </p>
            <p>把这个加到网站内即可，一般加载在 head 里。</p>
            <h2>config 方法介绍</h2>
            <p>config 方法是对sizzle框架的设置。它的语法是： config(key, value)。 key：设置属性的键名；value：设置属性的值。 如果当 value 值不存在的时候，config 便可以 return 这个 Key 的值。config 可以设置以下的值：</p>
            <p>
            <pre>// 设置框架为调试模式。
config("debug", true); 
// 设置框架的基址（用来简化标识路径）。
config("base", "http://assets.sizzle.cc");  
// 设置框架的编码。
config("charset", "UTF-8"); </pre>
            </p>
            <h2>config.log 方法介绍</h2>
            <p>显而易见，这个方法就是 console.log 的封装，用来打印数据。不过只有当debug模式开启时，这个方法才有用。</p>
            <h2>config.map 方法介绍</h2>
            <p>config.map 方法是添加和获取映射对的。什么意思呢？ 就是如果当我们把 jQuery.1.7.2.js 映射成 jQuery 这样一个字符的时候，我们可以在调用的时候只输入 jQuery 就可以完成对模块的调用。我们来看几个例子：</p>
            <p>
            <pre>// 我们将 http://xx.cn/public/manery.js 映射成了 manery 这样一个标识。
config.map("manery", "http://xx.cn/public/manery.js");  

// 当我们调用 manery 这个模块的时候，客户端自动会加载 http://xx.cn/public/manery.js 这个文件。
require("manery"); </pre>
            </p>
            <p>看了实例应该可以明白了吧。</p>
            <h2>define 方法介绍</h2>
            <p>define 顾名思义就是定义的意思，那么它是定义什么的呢，当然，它定义模块。当我们创建一个模块的时候，就用到这个方法了。这个方法有 2 个参数， 一个是deps，另一个是factory。 deps 就是依赖关系数组，factory就是模块函数原型。你也可以省略deps参数而直接写入factory方法原型。请看实例：</p>
            <p>
            <pre>define(["public/custom", "private/kately"], function(require, exports, module){
	return {
		value : "evio",
		name : "name" 
	}    
})</pre>
            </p>
            <p>当然，上面的例子没有任何意义，我只是举例。这个说明了，我们定义了这个模块，它依赖于 public/custom 和 private/kately 这2个模块。所以，当调用这个模块的时候，系统会有限载入依赖的其他2个模块，然后运行这个模块。 我们再来看一个实例。</p>
            <p>
            <pre>define(function(require, exports, module){
	var a = require("a"),
    	b = require("b");
    
    exports.arr = [a, b];
})</pre>
            </p>
            <p>我们看到，这次没有任何的依赖关系，但是我们发现function内部的require方法。只要在这个function内存在require方法，那么，这个require的地址将自动被转化成依赖关系，所以，这个模块加载钱也加载了 a 和 b 模块。我们来看3个参数：</p>
            <p>
            <pre>require, // function 类型，会获取一个模块，这个请看下一个说明文案。
exports, // 将向外部提供接口API。
module // 函数包裹原型。</pre>
            </p>
            <p>这3个参数是CommonJS规范的关键所在。你们不了解可以参阅CommonJS的说明。这里我就不多说了。</p>
            <h2>require 方法介绍</h2>
            <p>动态加载模块的底层函数方法。这个在整个框架中占据极为重要的位置。require有2个参数，第一个是ARR：模块队列，数组格式；另一个是FUNCTION：加载完毕后执行的方法。FUNCTION的参数个数依ARR的个数和顺序而定，内容为前面模块返回的对象或者值。我们来看一个实例：</p>
            <p>
            <pre>require(["public/custom", "private/kately"], function(custom, kately){
	[custom, kately].each(function(){
		// do something...
	});
})</pre>
            </p>
            <p>require能确保模块加载完成后运行它自身的方法，而且不会重复加载。所以你可以很方便的来管理你的代码模块，实现按需加载，去除多余加载。更多的是代码开发者对模块的把控更加随意了。</p>
            <h2>Sizzle 标识选择器</h2>
            <p>标识选择器是以路径为基础的。它包括以下内容：</p>
            <p>
            <pre>/    这个符号表示网站根目录选取。
:      这个符号表示从本机选取
http://      表示从互联网选取

require("/a/b/c");
require(":a/b/c");
require("http://sizzle.cc/a/b/c");</pre>
            </p>
            <p>这个选择器如果定义了base 那么它就是基于base 的地址。 如果base不是互联网地址，那么它是本网址下的base标识为base的标识。呵呵，很拗口不理解吧，慢慢体会。</p>
            <h2>结尾</h2>
            <p><font color="red">招募Sizzle开发人员和PJBlog4开发人员。</font> <br />
                本人联系方式： QQ(8802430)  Email(evio@vip.qq.com) QQ群(7267790)。</p>
            <br />
        </div>
        
        <!-- content-wrap ends here --> 
    </div>
<%include(config.params.themeFolder + "/footer")%>