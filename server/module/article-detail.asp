<%
define(function(require, exports, module){
	var cache = require("cache"),
		id = pageArticleCustomParams.id,
		sys_cache_article = cache.load("article", id),
		articleListContainer = {},
		sys_cache_category, sys_cache_categoryList = {};
		
	sys_cache_category = cache.load("category");
	for ( var o = 0 ; o < sys_cache_category.length ; o++ ){
		sys_cache_categoryList[sys_cache_category[o][0] + ""] = sys_cache_category[o];
	}
	
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
	
	if ( sys_cache_article.length === 1 ){
		articleListContainer.id = id;
		articleListContainer.log_title = sys_cache_article[0][0];
		articleListContainer.log_category = sys_cache_article[0][1];
		articleListContainer.log_categoryName = sys_cache_categoryList[sys_cache_article[0][1] + ""][1];
		articleListContainer.log_categoryInfo = sys_cache_categoryList[sys_cache_article[0][1] + ""][2];
		articleListContainer.log_content = sys_cache_article[0][2];
		articleListContainer.log_tags = returnTagArrays(sys_cache_article[0][3]);
		articleListContainer.log_views = sys_cache_article[0][4];
		articleListContainer.log_posttime = sys_cache_article[0][5];
		articleListContainer.log_updatetime = sys_cache_article[0][6];
		
		return articleListContainer;
	}else{
		return null;
	}
});
%>