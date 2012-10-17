<!--#include file="config.asp" -->
<%
	require("cache_global");
	
	var pageIndexCustomParams = {};
	
	pageIndexCustomParams.page = http.get("page");
	if ( pageIndexCustomParams.page.length === 0 ){ 
		pageIndexCustomParams.page = 1; 
	}else{
		pageIndexCustomParams.page = Number(pageIndexCustomParams.page);
		if ( pageIndexCustomParams.page < 1 ){
			pageIndexCustomParams.page = 1;
		}
	}
	
	pageIndexCustomParams.cateID = http.get("c");
	if ( pageIndexCustomParams.cateID.length === 0 ){
		pageIndexCustomParams.cateID = 0;
	}else{
		pageIndexCustomParams.cateID = Number(pageIndexCustomParams.cateID);
	}
	
	var assetsPluginCustom = require("pluginCustom");
	
	include("profile/themes/" + config.params.theme + "/default.asp");
	
	CloseConnect();
%>