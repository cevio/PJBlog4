<!--#include file="config.asp" -->
<%
try{
	pageCustomParams.tempModules.cache = require("cache");
	pageCustomParams.tempModules.dbo = require("DBO");
	pageCustomParams.tempModules.connect = require("openDataBase");
	pageCustomParams.tempModules.fns = require("fn");
	pageCustomParams.tempModules.sap = require("sap");
	pageCustomParams.tempCaches.globalCache = require("cache_global");
	pageCustomParams.tempCaches.fso = require("FSO");
	
	if ( !pageCustomParams.tempCaches.globalCache.webstatus ){
		ConsoleClose("抱歉，网站暂时被关闭。");
	}
	
	if ( pageCustomParams.tempModules.connect !== true ){
		ConsoleClose("连接数据库失败");
	}
	
	require("status")();
	
	pageCustomParams.mark = http.get("mark");
	if ( !pageCustomParams.mark || pageCustomParams.mark.length === 0 ){
		ConsoleClose("参数不正确");
	};
	
	pageCustomParams.page = http.get("page");
	if ( pageCustomParams.page.length === 0 ){ 
		pageCustomParams.page = 1; 
	}else{
		if ( !isNaN( pageCustomParams.page ) ){
			pageCustomParams.page = Number(pageCustomParams.page);
			if ( pageCustomParams.page < 1 ){
				pageCustomParams.page = 1;
			}
		}else{
			ConsoleClose("page params error.");
		}
	};
	
	pageCustomParams.tempParams.category = require("cache_category");
	pageCustomParams.plugin = {};
	pageCustomParams.tempParams.pluginWebPath = "";
	pageCustomParams.tempParams.pluginProxyPath = "";
	
	(function(mark, cache, global, fso){
		var assetsPluginCustom = require("pluginCustom"),
			AllPluginLists = assetsPluginCustom.pluginCache(),
			thisPluginInfo = {};
		
		if ( AllPluginLists[mark] === undefined ){
			ConsoleClose("未找到插件，请确认该插件是否已经被安装。");
			return;
		}else{
			thisPluginInfo = AllPluginLists[mark];
			if ( thisPluginInfo.pluginstatus === true ){
				pageCustomParams.tempParams.pluginWebPath = "profile/themes/" + global.theme + "/" + thisPluginInfo.pluginwebpage,
				pageCustomParams.tempParams.pluginProxyPath = "profile/plugins/" + thisPluginInfo.pluginfolder + "/proxy.asp";	
				pageCustomParams.plugin.configData = assetsPluginCustom.configCache(thisPluginInfo.id);
				pageCustomParams.plugin.folder = "profile/plugins/" + thisPluginInfo.pluginfolder;
				if ( fso.exsit(pageCustomParams.tempParams.pluginProxyPath) ){ 
					pageCustomParams.plugin.webData = require(pageCustomParams.tempParams.pluginProxyPath); 
				}
			}else{
				ConsoleClose("插件已被停用");
			}
		}	
	})(pageCustomParams.mark, pageCustomParams.tempModules.cache, pageCustomParams.tempCaches.globalCache, pageCustomParams.tempCaches.fso);
	
	if ( pageCustomParams.tempCaches.fso.exsit(pageCustomParams.tempParams.pluginWebPath) ){
		include(pageCustomParams.tempParams.pluginWebPath);
	}else{
		ConsoleClose("插件页面文件不存在");
	}
	
	delete pageCustomParams.tempCaches;
	delete pageCustomParams.tempModules;
	delete pageCustomParams.tempParams;
	
	CloseConnect();
}catch(e){
	ConsoleClose(e.message);
}