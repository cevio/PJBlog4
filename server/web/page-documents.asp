
<%
function pageTheme(){
%>
	<div class="ItemTabs fn-clear">
    	<div class="fn-left ItemTabs-content">
            <div class="ItemTabs-content-items">
            	<h1><span class="iconfont">&#226;</span>理解本程序模板引擎</h1>
                <p>本程序其实没有模板引擎，只是通过动态include的方式调用动态ASP文件来达到模板化的目的。这种做法的优势在于省去了对模板进行正则匹配的麻烦，提高了运做效率。有模板引擎不如没有模板引擎，这点就是我们只做主题的宗旨。那么我们该如何制作主题呢？</p>
                <p>制作主题我们首先必须在 /profile/themes/文件夹下创建本主题的文件夹名，文件夹名必须为英文，禁止中文和特殊符号。在主题文件夹中创建一个install.xml文件用来配置主题内容。该文件的写法如下：</p>
                <pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;theme&gt;
		&lt;themeName&gt;Twilight&lt;/themeName&gt;
		&lt;themeAuthor&gt;Viktor Persson&lt;/themeAuthor&gt;
		&lt;themeWebSite&gt;http://arcsin.se&lt;/themeWebSite&gt;
		&lt;themeEmail&gt;contact@arcsin.se&lt;/themeEmail&gt;
		&lt;themePublishDate&gt;2008‎-12‎-‎11‎ ‏‎12:18:52&lt;/themePublishDate&gt;
		&lt;themeVersion&gt;v2.5&lt;/themeVersion&gt;
		&lt;themeInfo&gt;&lt;![CDATA[
			Payment can be done via:
    		* Moneybookers: moneybookers@arcsin.se
    		* PayPal: paypal@arcsin.se
    		* Credit card: Follow the instructions found at the template license page: http://templates.arcsin.se/license/ 
		]]&gt;&lt;/themeInfo&gt;
&lt;/theme&gt;</pre>
				<p>然后依次创建default.asp article.asp link.asp tag.asp search.asp.如果需要用到公用头部的话请创建header.asp和footer.asp。最后请看如果编写这些文件的内容。</p>
                <p>第一步，定制模板的HTML代码。分离出头部代码和底部代码，分别放置到header.asp和footer.asp。然后将中间部分放置到default.asp。在default.asp的第一行和最后一行分别加入如下代码:</p>
                <ul>
                	<li>&lt;%include(config.params.themeFolder + "/header");%&gt;</li>
                    <li>&lt;%include(config.params.themeFolder + "/footer")%&gt;</li>
                </ul>
                <p>第二步，打开header.asp。在head标签中加入</p>
                <ul>
                	<li>&lt;meta name="Description" content="&lt;%=config.params.webdescription%&gt;" /&gt;</li>
                    <li>&lt;meta name="Keywords" content="&lt;%=config.params.webkeywords%&gt;" /&gt;</li>
                    <li>&lt;meta http-equiv="Content-Type" content="text/html; charset=utf-8" /&gt;</li>
                    <li>&lt;meta name="Author" content="&lt;%=config.params.nickname%&gt; - &lt;%=config.params.authoremail%&gt;" /&gt;</li>
                    <li>&lt;link rel="stylesheet" href="&lt;%=config.params.website + "/" + config.params.styleFolder%&gt;/default.css" type="text/css" /&gt;</li>
                    <li>&lt;script language="javascript" src="&lt;%=config.params.website + "/assets/js/core/sizzle.js"%&gt;"&gt; &lt;/script&gt;</li>
					<li>&lt;title>&lt;%=config.params.seotitle%&gt;&lt;/title&gt;</li>
                </ul>
                <p>第三步，打开footer.asp。对照主题制作的全局变量填入相应数据。</p>
                <p>第四步，请看其他说明。</p>
            </div>
        	<div class="ItemTabs-content-items">
            	<h1><span class="iconfont">&#226;</span>全局变量适用于整站，对照一下列表自由组装达到模板标签自由化效果。</h1>
                <table width="100%" cellpadding="0" cellspacing="0">
                	<tr>
                    	<td class="key">config.params.title</td>
                        <td class="info">网站主标题</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.description</td>
                        <td class="info">网站副标题，非SEO描述。</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.qq_appid</td>
                        <td class="info">腾讯开放平台APPID。用于登入或者腾讯的其他数据获取</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.qq_appkey</td>
                        <td class="info">腾讯开放平台APPKEY。用于登入或者腾讯的其他数据获取</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.theme</td>
                        <td class="info">网站当前所使用的<span>主题</span>所在的<span>目录名</span>，比如以下的红色部分：<br />profile/themes/<strong>template</strong>/style/default/x.css</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.themeFolder</td>
                        <td class="info">网站当前所使用的<span>主题</span>的<span>完整路径</span>，比如一下的红色部分：<br /><strong>profile/themes/template</strong>/style/default/x.css</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.style</td>
                        <td class="info">网站当前所使用的<span>风格</span>所在的<span>目录名</span>，比如以下的红色部分：<br />profile/themes/template/style/<strong>default</strong>/x.css</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.styleFolder</td>
                        <td class="info">网站当前所使用的<span>风格</span>的<span>完整路径</span>，比如一下的红色部分：<br /><strong>profile/themes/template/style/default</strong>/x.css</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.nickname</td>
                        <td class="info">自定义博主昵称</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.website</td>
                        <td class="info">网站的URL地址，即线上地址</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.webdescription</td>
                        <td class="info">SEO描述信息</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.webkeywords</td>
                        <td class="info">SEO关键字</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.authoremail</td>
                        <td class="info">博主邮箱</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.seotitle</td>
                        <td class="info">网页标题，SEO标题</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.themeName</td>
                        <td class="info">当前使用主题的名称</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.themeAuthor</td>
                        <td class="info">当前使用主题的作者</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.themeWebSite</td>
                        <td class="info">当前使用主题的作者的网站或官方网站，包括主题部分源码的修改教程地址。</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.themeEmail</td>
                        <td class="info">当前使用主题的作者的邮箱</td>
                    </tr>
                    <tr>
                    	<td class="key">config.params.themeVersion</td>
                        <td class="info">当前使用主题的版本号</td>
                    </tr>
                </table>
                <p>在制作主题的时候，建议将CSS的地址写成绝对地址。JS建议使用sizzle框架下的require方法来引入。注意书写代码的规范。</p>
                <h1><span class="iconfont">&#226;</span>LoadCacheModule(ModuleName, ModuleCallback)</h1>
                <p>该函数用来调用系统模块，并回调系统模块返回值。</p>
                <ul>
                	<li>ModuleName: { type: string } 系统模块名称</li>
                    <li>ModuleCallback: { type: function }系统模块返回的数据源 （通过对数据源的处理可以将数据按规则显示）， 他有一个参数即数据源对象，可能为数组，也可能为JSON数据格式。</li>
                </ul>
                <h1><span class="iconfont">&#226;</span>LoadPluginsCacheModule(ModuleName, ModuleCallback)</h1>
                <p>该函数用来调用插件模块，通过对其进行数据处理可以显示插件的内容。</p>
                <ul>
                	<li>ModuleName: { type: string } 插件模块名称</li>
                    <li>ModuleCallback: { type: function }插件模块返回的数据源 （通过对数据源的处理可以将数据按规则显示）， 他有一个参数即数据源对象，可能为数组，也可能为JSON数据格式。</li>
                </ul>
            </div>
            <div class="ItemTabs-content-items">
            	<h1><span class="iconfont">&#226;</span>首页的制作比较麻烦，涉及面广。让我们一步一步来看如何获取数据源来输出数据。</h1>
                <p>获得分类数据源。代码如下：</p>
                <pre>&lt;%LoadCacheModule("cache_category", function( cache_category ){......});%&gt;</pre>
                <p>这个分类源数据结构如下：</p>
                <pre>[{
    id: id,
    cate_name: cate_name,
    cate_info: cate_info,
    cate_count: cate_count, 
    cate_icon: cate_icon,
    cate_outlink: cate_outlink,
    cate_outlinktext: cate_outlinktext,
    childrens:[
        {
            id: id,
            cate_name: cate_name,
            cate_info: cate_info,
            cate_count: cate_count, 
            cate_icon: cate_icon,
            cate_outlink: cate_outlink,
            cate_outlinktext: cate_outlinktext
        },......
    ]
}, ....]</pre>
				<p>具体不明白的请参看我的模板文件。</p>
                <p>获取QQ登入连接。</p>
                <pre>&lt;if ( config.user.login === true ){
				console.log('您已登入 &lt;a href="server/logout.asp"&gt;退出登入&lt;/a&gt;');
			}else{
				var oauth = require("server/oAuth/qq/oauth"),
					fns = require("fn");
					
				console.log('&lt;a href="' + oauth.url("100299901", config.params.website + "/server/oauth.asp?type=qq&amp;dir=" + escape( fns.localSite() )) + '"&gt;登入&lt;/a&gt;');
			}&gt;</pre>
            	<p>获得日志列表数据源。代码如下：</p>
                <pre>&lt;%LoadCacheModule("cache_article", function( cache_article ){......})%&gt;</pre>
                <p>这个分类源数据结构如下：</p>
                <pre>[{
    id: id,
    log_title: log_title,
    log_category: log_category,
    log_categoryName: log_categoryName,
    log_categoryInfo: log_categoryInfo,
    log_content: log_content,
    log_tags: log_tags,
    log_views: log_views,
    log_posttime: log_posttime,
    log_updatetime: log_updatetime
}, ....]</pre>
            </div>
        </div>
        <div class="fn-right ItemTabs-list">
        	<a href="javascript:;">制作索引</a>
        	<a href="javascript:;">全局变量</a>
            <a href="javascript:;">制作首页</a>
        </div>
    </div>
<%
}

function pagePlugin(){
	
}
%>

<div class="tpl-space fn-clear">
    <div class="documents-zone">
    	<h3><span class="iconfont">&#367;</span> 技术文档</h3>
        <div class="documents-list">
        	<div class="documents-list-header fn-clear">
            	<a href="javascript:;">主题制作</a>
                <a href="javascript:;">插件制作</a>
            </div>
            <div class="documents-list-content">
            	<div class="documents-list-content-items"><%pageTheme();%></div>
                <div class="documents-list-content-items"><%pagePlugin();%></div>
            </div>
        </div>
    </div>
</div>