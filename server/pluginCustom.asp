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
					proxy.folder = thisPluginCache.pluginfolder;
					retPlugin = proxy;
			}
		}
		
		return retPlugin;
	}
	
	exports.addCategory = function(mark, data){
		var dbo = require("DBO"),
			connecte = require("openDataBase");
		
		if ( connecte === true ){
			try{
				dbo.trave({
					conn: config.conn,
					sql: "Select * From blog_category Where pluginmark='" + mark + "'",
					callback: function(rs){
						if ( rs.Bof || rs.Eof ){
							dbo.add({
								data: data,
								table: "blog_category",
								conn: config.conn
							});
							var cache = require.async("cache");	
								cache.build("category");
						}
					}
				});
					
				return true;
			}catch(e){
				return false;
			}
		}else{
			return false;
		}
	}
	
	exports.deleteCategory = function(mark){
		var dbo = require("DBO"),
			connecte = require("openDataBase");
		
		if ( connecte === true ){
			try{
				config.conn.Execute("Delete From blog_category Where pluginmark='" + mark + "'");
				var cache = require.async("cache");	
					cache.build("category");
				return true;
			}catch(e){
				return false;
			}
		}else{
			return false;
		}
	}
	
	exports.copyThemeFiles = function(source, target){
		var copyArray = [];
		if ( target === undefined ){
			copyArray = source;
		}else{
			copyArray.push({
				from: source,
				to: target
			});
		}
		
		var fso = require.async("FSO");
		
		for ( var i = 0 ; i < copyArray.length ; i++ ){
			fso.copy(
				"profile/plugins/" + this.folder + "/" + copyArray[i].from, 
				"profile/themes/" + this.themeFolder + (copyArray[i].to === "." ? "" : "/" + copyArray[i].to)
			);
		}
	}
	
	exports.copyStyleFiles = function(source, target){
		var copyArray = [];
		if ( target === undefined ){
			copyArray = source;
		}else{
			copyArray.push({
				from: source,
				to: target
			});
		}
		
		var fso = require.async("FSO");
		
		for ( var i = 0 ; i < copyArray.length ; i++ ){
			fso.copy(
				"profile/plugins/" + this.folder + "/" + copyArray[i].from, 
				"profile/themes/" + this.themeFolder + "/style/" + this.styleFolder + (copyArray[i].to === "." ? "" : "/" + copyArray[i].to)
			);
		}
	}
	
	exports.deleteThemeFiles = function(arrays){
		var fso = require.async("FSO");
		for ( var i = 0 ; i < arrays.length ; i++ ){
			fso.destory("profile/themes/" + this.themeFolder + "/" + arrays[i]);
		}
	}
	
	exports.deleteStyleFiles = function(arrays){
		var fso = require.async("FSO");
		for ( var i = 0 ; i < arrays.length ; i++ ){
			fso.destory("profile/themes/" + this.themeFolder + "/style/" + this.styleFolder + "/" + arrays[i]);
		}
	}
});
%>