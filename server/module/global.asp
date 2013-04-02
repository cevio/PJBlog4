<%
define(function(require, exports, module){
	var sys_cache_global = pageCustomParams.tempModules.cache.load("global");

		pageCustomParams.global = {};
		pageCustomParams.global.title = sys_cache_global.title; // '标题
		pageCustomParams.global.description = sys_cache_global.description; // '描述
		pageCustomParams.global.theme = sys_cache_global.theme; // '主题
		pageCustomParams.global.style = sys_cache_global.style; // '样式
		pageCustomParams.global.nickname = sys_cache_global.nickname; // '昵称
		pageCustomParams.global.themeFolder = "profile/themes/" + pageCustomParams.global.theme; // '主题文件夹
		pageCustomParams.global.styleFolder = "profile/themes/" + pageCustomParams.global.theme + "/style/" + pageCustomParams.global.style; // '样式文件夹
		pageCustomParams.global.website = sys_cache_global.website; // '本网站地址
		pageCustomParams.global.webdescription = sys_cache_global.webdescription; // 'SEO描述
		pageCustomParams.global.webkeywords = sys_cache_global.webkeywords; // 'SEO关键字
		pageCustomParams.global.authoremail = sys_cache_global.authoremail; // '博主邮箱
		pageCustomParams.global.seotitle = sys_cache_global.seotitle; // 'SEO 标题
		pageCustomParams.global.themeName = sys_cache_global.themename; // '主题名称
		pageCustomParams.global.themeAuthor = sys_cache_global.themeauthor; // '主题作者
		pageCustomParams.global.themeWebSite = sys_cache_global.themewebSite; // '主题网站
		pageCustomParams.global.themeEmail = sys_cache_global.themeemail; // '主题作者邮箱
		pageCustomParams.global.themeVersion = sys_cache_global.themeversion; // '主题版本
		pageCustomParams.global.totalarticles = sys_cache_global.totalarticles; // '日志总数
		pageCustomParams.global.totalcomments = sys_cache_global.totalcomments; // '评论总数
		pageCustomParams.global.articleperpagecount = sys_cache_global.articleperpagecount; // '每页日志数
		pageCustomParams.global.commentperpagecount = sys_cache_global.commentperpagecount; // '每页评论数
	
	return sys_cache_global;
});
%>