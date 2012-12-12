<%
define(function(require, exports, module){
	if ( config.plugin.deleteCategory("guestbook") ){
		config.plugin.deleteThemeFiles(["guestbook.asp", "js/guestbook.js"]);
		config.plugin.deleteStyleFiles(["guestbook.css", "detail_11.jpg", "detail_05.jpg"]);
	}
});
%>