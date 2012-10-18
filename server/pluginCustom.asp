<%
define(function( require, exports, module ){
	exports.configCache = function( id ){
		var cache = require.async("cache"),
			thisPluginConfigCache = cache.load("moden", id),
			thisPluginConfigCacheList = {};
			
		for ( var i = 0 ; i < thisPluginConfigCache.length ; i++ ){
			thisPluginConfigCacheList[thisPluginConfigCache[i][0]] = thisPluginConfigCache[i][1];
		}
		
		return thisPluginConfigCacheList;
	}
	
	exports.pluginCache = function(){
		var cache = require.async("cache"),
			pluginCacheArray = cache.load("plugin"),
			pluginCacheList = {};
		
		for ( var i = 0 ; i < pluginCacheArray.length ; i++ ){
			pluginCacheList[pluginCacheArray[i][2]] = {
				id: pluginCacheArray[i][0],
				pluginname: pluginCacheArray[i][1],
				pluginfolder: pluginCacheArray[i][3],
				pluginstatus: pluginCacheArray[i][4]
			}
		}
		
		return pluginCacheList;
	}
	
	exports.loadPlugin = function( mark ){
		var pluginCacheList = this.pluginCache(),
			thisPluginCache, retPlugin = null;
		
		if ( pluginCacheList[mark] !== undefined ){
			thisPluginCache = pluginCacheList[mark];
			if ( thisPluginCache.pluginstatus === true ){
				var proxy = require.async("profile/plugins/" + thisPluginCache.pluginfolder + "/proxy");
					proxy.id = thisPluginCache.id;
					retPlugin = proxy;
			}
		}
		
		return retPlugin;
	}
});
%>