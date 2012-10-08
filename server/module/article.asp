<%
define(function(require, exports, module){
	var cache = require("cache"),
		sys_cache_articlePages = cache.load("article_pages"),
		sys_cache_global = cache.load("global");
		
	var perPage = sys_cache_global[0][10];
	
	var arrays = [], 
		articleIdFrom = 0, 
		articleIdTo = 0,
		articleListContainer = [];
		
	function returnTagArrays( tags ){
		var module_tags_require = require.async("tags"),
			tagStrArrays = module_tags_require.reFormatTags(tags),
			keeper = [];
			
		for ( var j = 0 ; j < tagStrArrays.length ; j++ ){
			var rets = module_tags_require.readTagFromCache( Number(tagStrArrays[j]) );
				keeper.push({ id: Number(tagStrArrays[j]), name: rets });
		}
		return keeper;
	}
	
	for ( var i = 0 ; i < sys_cache_articlePages.length ; i++ ){
		arrays.push(sys_cache_articlePages[i][0]);
	}
	
	articleIdFrom = (config.page.assets.index - 1) * perPage + 1;
	articleIdTo = config.page.assets.index * perPage;
	
	if ( articleIdFrom > arrays.length ){
		articleIdFrom = arrays.length;
		articleIdTo = arrays.length;
	}else{
		if ( articleIdFrom < 1 ){
			articleIdFrom = 1;
		}
		if ( articleIdTo > arrays.length ){
			articleIdTo = arrays.length;
		}
	}
	
	articleIdFrom--; articleIdTo--;
	
	if ( arrays.length > 0 ){
		for ( i = articleIdFrom ; i <= articleIdTo ; i++ ){
			var sys_cache_article = cache.load("article", Number(arrays[i]));
			
			articleListContainer.push({
				id: Number(arrays[i]),
				log_title: sys_cache_article[0][0],
				log_category: sys_cache_article[0][1],
				log_content: sys_cache_article[0][2],
				log_tags: returnTagArrays(sys_cache_article[0][3]),
				log_views: sys_cache_article[0][4],
				log_posttime: sys_cache_article[0][5],
				log_updatetime: sys_cache_article[0][6]
			})
		}
	}
	
	return articleListContainer;
	
});
%>