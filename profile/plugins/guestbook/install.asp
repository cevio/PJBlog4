<%
define(function( require, exports, module ){
	if ( config.plugin.addCategory("guestbook", {
		cate_name: "留言本",
		cate_info: "官方提供的留言本插件",
		cate_order: 100,
		cate_root: 0,
		cate_count: 0,
		cate_icon: "1.gif",
		cate_show: false,
		cate_outlink: true,
		cate_outlinktext: "plugin.asp?mark=guestbook",
		pluginmark: "guestbook"
	}) ){
		config.plugin.copyThemeFiles([
			{ from: "guestbook.asp", to: "." },
			{ from: "guestbook.js", to: "js"}
		]);
		
		config.plugin.copyStyleFiles([
			{ from: "guestbook.css", to: "." }
		]);
	}
});
%>