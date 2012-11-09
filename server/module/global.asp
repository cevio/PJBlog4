<%
define(function(require, exports, module){
	var cache = require("cache"),
		sys_cache_global = cache.load("global");
	
	if ( cache !== null ){
		pageCustomParams.global = {};
		pageCustomParams.global.title = sys_cache_global[0][0]; // 标题
		pageCustomParams.global.description = sys_cache_global[0][4]; // 描述
		pageCustomParams.global.qq_appid = sys_cache_global[0][1]; // qq openid
		pageCustomParams.global.qq_appkey = sys_cache_global[0][2]; // qq openkey
		pageCustomParams.global.theme = sys_cache_global[0][5]; // 主题
		pageCustomParams.global.style = sys_cache_global[0][6]; // 样式
		pageCustomParams.global.nickname = sys_cache_global[0][7]; // 昵称
		pageCustomParams.global.themeFolder = "profile/themes/" + pageCustomParams.global.theme; // 主题文件夹
		pageCustomParams.global.styleFolder = "profile/themes/" + pageCustomParams.global.theme + "/style/" + pageCustomParams.global.style; // 样式文件夹
		pageCustomParams.global.website = sys_cache_global[0][3]; // 本网站地址
		pageCustomParams.global.webdescription = sys_cache_global[0][11]; // SEO描述
		pageCustomParams.global.webkeywords = sys_cache_global[0][12]; // SEO关键字
		pageCustomParams.global.authoremail = sys_cache_global[0][13]; // 博主邮箱
		pageCustomParams.global.seotitle = sys_cache_global[0][14]; // SEO 标题
		pageCustomParams.global.themeName = sys_cache_global[0][15]; // 主题名称
		pageCustomParams.global.themeAuthor = sys_cache_global[0][16]; // 主题作者
		pageCustomParams.global.themeWebSite = sys_cache_global[0][17]; // 主题网站
		pageCustomParams.global.themeEmail = sys_cache_global[0][18]; // 主题作者邮箱
		pageCustomParams.global.themeVersion = sys_cache_global[0][19]; // 主题版本
	}else{
		console.push("未找到缓存系统处理模块");
	}
	
	return sys_cache_global;
});
%>