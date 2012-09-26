<!--#include file="config.asp" -->
<%
	require("cache_global");
	
	config.page.assets.index = http.get("page");
	
	if ( config.page.assets.index.length === 0 ){ 
		config.page.assets.index = 1; 
	}else{
		config.page.assets.index = Number(config.page.assets.index);
	}
	
	include("profile/themes/" + config.params.theme + "/default.asp");
%>