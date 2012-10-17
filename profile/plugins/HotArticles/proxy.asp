<%
define(function( require, exports, module ){
	exports.data = function(id){
		var pluginInstall = require.async("pluginCustom"),
			cache = require.async("cache"),
			articlelist = cache.load("article_pages"),
			fns = require.async("fn"),
			date = require.async("DATE"),
			pluginConfigCache = pluginInstall.configCache( id ),
			infos = [];
			
		if ( articlelist.length < pluginConfigCache.top ){
			pluginConfigCache.top = articlelist.length;
		}

		for ( var i = 0 ; i < pluginConfigCache.top ; i++ ){
			var articlesCache = cache.load("article", articlelist[i][0]);
			infos.push({
				id: articlelist[i][0],
				log_title: fns.cutStr(articlesCache[i][0], pluginConfigCache.cut, true),
				log_posttime: date.format(articlesCache[i][5], pluginConfigCache.date)
			});
		}
		
		return infos;
	}
});
%>