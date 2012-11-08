<!--#include file="config.asp" -->
<%
(function(mark){
	
 	require("status");
	require("cache_global");
	
	var pagePluginCustomParams = {};
	
	pagePluginCustomParams.page = http.get("page");
	if ( pagePluginCustomParams.page.length === 0 ){ 
		pagePluginCustomParams.page = 1; 
	}else{
		pagePluginCustomParams.page = Number(pagePluginCustomParams.page);
		if ( pagePluginCustomParams.page < 1 ){
			pagePluginCustomParams.page = 1;
		}
	}
	
	var assetsPluginCustom = require("pluginCustom"),
		AllPluginLists = assetsPluginCustom.pluginCache()，
		thisPluginInfo = {};
		
	if ( AllPluginLists[mark] === undefined ){
		console.log("未找到该插件");
		return;
	}else{
		thisPluginInfo = AllPluginLists[mark];
	}
	
	if ( thisPluginInfo.pluginstatus === true ){
		var fso = require("fso"),
			pluginWebPath = "profile/themes/" + config.params.theme + "/" + thisPluginInfo.pluginwebpage,
			pluginProcyPath = "profile/plugins/" + thisPluginInfo.pluginfolder + "/proxy";	
		if ( fso.exsit(pluginProcyPath) === true ){
			pagePluginCustomParams.webData = require(pluginProcyPath);
			if ( fso.exsit(pluginWebPath) ){
				include(pluginWebPath);
			}else{
				console.log("插件页面文件不存在");
			}
		}else{
			console.log("插件数据接口文件不存在");
		}
	}else{
		console.log("插件已被停用");
	}
})(http.get("mark"));
CloseConnect();
%>