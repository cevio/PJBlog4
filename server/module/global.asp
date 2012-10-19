<%
define(function(require, exports, module){
	var cache = require("cache"),
		sys_cache_global = cache.load("global");
	
	if ( cache !== null ){
		config.params = {};
		config.params.title = sys_cache_global[0][0]; // 标题
		config.params.description = sys_cache_global[0][4]; // 描述
		config.params.qq_appid = sys_cache_global[0][1]; // qq openid
		config.params.qq_appkey = sys_cache_global[0][2]; // qq openkey
		config.params.theme = sys_cache_global[0][5]; // 主题
		config.params.style = sys_cache_global[0][6]; // 样式
		config.params.nickname = sys_cache_global[0][7]; // 昵称
		config.params.themeFolder = "profile/themes/" + config.params.theme; // 主题文件夹
		config.params.styleFolder = "profile/themes/" + config.params.theme + "/style/" + config.params.style; // 样式文件夹
		config.params.website = config.debug === true ? "http://blog.cn" : sys_cache_global[0][3]; // 本网站地址
		config.params.webdescription = sys_cache_global[0][11]; // SEO描述
		config.params.webkeywords = sys_cache_global[0][12]; // SEO关键字
		config.params.authoremail = sys_cache_global[0][13]; // 博主邮箱
		config.params.seotitle = sys_cache_global[0][14]; // SEO 标题
		config.params.themeName = sys_cache_global[0][15]; // 主题名称
		config.params.themeAuthor = sys_cache_global[0][16]; // 主题作者
		config.params.themeWebSite = sys_cache_global[0][17]; // 主题网站
		config.params.themeEmail = sys_cache_global[0][18]; // 主题作者邮箱
		config.params.themeVersion = sys_cache_global[0][19]; // 主题版本
	}else{
		console.push("未找到缓存系统处理模块");
	}
});
%>