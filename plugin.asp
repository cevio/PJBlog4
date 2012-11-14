<!--#include file="config.asp" -->
<%
	var mark = http.get("mark");
	
	// '加载用户登入状态
	require("status");
	
	// '加载全局变量模块
	pageCustomParams.tempCaches.globalCache = require("cache_global");
	
	pageCustomParams.page = http.get("page");
	if ( pageCustomParams.page.length === 0 ){ 
		pageCustomParams.page = 1; 
	}else{
		pageCustomParams.page = Number(pageCustomParams.page);
		if ( pageCustomParams.page < 1 ){
			pageCustomParams.page = 1;
		}
	}
	
	var assetsPluginCustom = require("pluginCustom"),
		AllPluginLists = assetsPluginCustom.pluginCache(),
		thisPluginInfo = {};
		
	if ( AllPluginLists[mark] === undefined ){
		console.log("未找到该插件");
	}else{
		thisPluginInfo = AllPluginLists[mark];
		
		if ( thisPluginInfo.pluginstatus === true ){
			var fso = require("FSO"),
				pluginWebPath = "profile/themes/" + pageCustomParams.global.theme + "/" + thisPluginInfo.pluginwebpage,
				pluginProcyPath = "profile/plugins/" + thisPluginInfo.pluginfolder + "/proxy.asp";	
			if ( fso.exsit(pluginProcyPath) === true ){
				
				// '重要参数
				pageCustomParams.webData = require(pluginProcyPath);
				pageCustomParams.configData = assetsPluginCustom.configCache(thisPluginInfo.id);
				pageCustomParams.pluginFolder = "profile/plugins/" + thisPluginInfo.pluginfolder;
				
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
	}
	
	delete pageCustomParams.tempCaches;
	delete pageCustomParams.tempModules;
	delete pageCustomParams.tempParams;
	
	CloseConnect();
%>