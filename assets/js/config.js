// JavaScript Document
// set default params for sizzle
define(["assets/js/core/jQuery"], function(){
	
	// build upload module
	config("debug", true);
	config("base", "/");
	
	// map modules
	config.map("upload", "assets/js/upload");
	config.map("form", "assets/js/core/form");
	config.map("tpl-category", "assets/js/tpl/tpl-category");
	config.map("overlay", "assets/js/core/overlay");
	config.map("editor", "assets/js/lib/xheditor/editor");
	config.map("tabs", "assets/js/core/tabs");
	config.map("easing", "assets/js/core/jQuery.easing.1.3");
	
	config.ajaxUrl = { assets: {}, server: {} }
	
	config.ajaxUrl.server.getCateInfo = "server/category.asp?j=getcateinfo";
	config.ajaxUrl.server.updateCate = "server/category.asp?j=updatecate";
	config.ajaxUrl.server.addCate = "server/category.asp?j=addcates";
	config.ajaxUrl.server.destoryCate = "server/category.asp?j=destorycates";
	config.ajaxUrl.server.iconList = "server/category.asp?j=iconlist";
	config.ajaxUrl.server.delArticles = "server/article.asp?j=delarticle";
	config.ajaxUrl.server.setupPlugin = "server/plugin.asp?j=setup";
	config.ajaxUrl.server.configSetPlugin = "server/plugin.asp?j=setconfig";
	config.ajaxUrl.server.updateConfig = "server/plugin.asp?j=updateconfig";
	config.ajaxUrl.server.pluginStop = "server/plugin.asp?j=pluginstop";
	config.ajaxUrl.server.pluginActive = "server/plugin.asp?j=pluginactive";
	config.ajaxUrl.server.pluginUnInstall = "server/plugin.asp?j=pluginuninstall";
	config.ajaxUrl.server.setupTheme = "server/theme.asp?j=setup";
	config.ajaxUrl.server.setupThemeStyle = "server/theme.asp?j=setupstyle";
	config.ajaxUrl.server.setupThemeDelete = "server/theme.asp?j=themedelete";

	$("body")
	
	// 全局绑定事件之跳转全局设置页面
	.on("click", ".sdk-globalconfigure", function(){
		window.location.href = "?p=globalConfigure";
	});
	
	return {
		status : true,
		load : function( args ){
			require.async(args, function( customs ){
				if ( customs.init !== undefined ){
					customs.init();
				}
			});
		}
	};
});