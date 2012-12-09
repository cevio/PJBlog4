																																			 <%
define(function( require, exports, module ){
	if ( config.plugin.addCategory("links", {
		cate_name: "友情链接",
		cate_info: "Pjblog4友情链接插件",
		cate_order: 100,
		cate_root: 0,
		cate_count: 0,
		cate_icon: "1.gif",
		cate_show: false,
		cate_outlink: true,
		cate_outlinktext: "plugin.asp?mark=links",
		pluginmark: "links"
	}) ){
		config.plugin.copyThemeFiles([
			{ from: "links.asp", to: "." },
			{ from: "links.js", to: "js"}
		]);
		
		config.plugin.copyStyleFiles([
			{ from: "links.css", to: "." },
			{ from: "linkxlogo.jpg", to: "." }
		]);
	}
});
%>