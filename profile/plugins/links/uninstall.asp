<%
define(function(require, exports, module){
	if ( config.plugin.deleteCategory("links") ){
		config.plugin.deleteThemeFiles(["links.asp", "js/links.js"]);
	}
});
%>