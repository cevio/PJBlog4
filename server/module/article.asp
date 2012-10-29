<%
define(function(require, exports, module){
	var cache = require("cache"),
		sys_cache_articlePages,
		sys_cache_global = cache.load("global"),
		sys_cache_category,
		sys_cache_categoryList = {};
		
	var perPage = sys_cache_global[0][10];
	
	var arrays = [], 
		articleIdFrom = 0, 
		articleIdTo = 0,
		articleListContainer = [];
		
	if ( pageIndexCustomParams === undefined ){
		return {
			list: articleListContainer, 
			page:{}
		}
	}
	
	if ( pageIndexCustomParams.page === undefined ){
		return {
			list: articleListContainer, 
			page:{}
		}
	}
	
	if ( pageIndexCustomParams.cateID === undefined || pageIndexCustomParams.cateID === 0 ){
		sys_cache_articlePages = cache.load("article_pages");
	}else{
		sys_cache_articlePages = cache.load("article_pages_cate", pageIndexCustomParams.cateID);
	}
	
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
	
	for ( var i = 0 ; i < sys_cache_articlePages.length ; i++ ){
		arrays.push(sys_cache_articlePages[i][0]);
	}
	
	articleIdFrom = (pageIndexCustomParams.page - 1) * perPage + 1;
	articleIdTo = pageIndexCustomParams.page * perPage;
	
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
				log_categoryName: sys_cache_categoryList[sys_cache_article[0][1] + ""][1],
				log_categoryInfo: sys_cache_categoryList[sys_cache_article[0][1] + ""][2],
				log_content: sys_cache_article[0][7],
				log_tags: returnTagArrays(sys_cache_article[0][3]),
				log_views: sys_cache_article[0][4],
				log_posttime: sys_cache_article[0][5],
				log_updatetime: sys_cache_article[0][6]
			})
		}
	}
	
	
	function pageAnalyze(currentPage, totalPages, perPageCount){
		if ( perPageCount === undefined ){ perPageCount = 9; }
		if ( perPageCount > totalPages ){ perPageCount = totalPages; }
		
		var isEven = perPageCount % 2 === 0 ? false : true,
			o = Math.floor(perPageCount / 2),
			l = isEven ? o : o - 1,
			r = o;
		
		var _l = currentPage - l,
			_r = currentPage + r;
		
		if ( _l < 1 ){
			_l = 1;
			_r = _l + perPageCount - 1;
			if ( _r > totalPages ){
				_r = totalPages;
			}
		}else if ( _r > totalPages ){
			_r = totalPages;
			_l = _r - perPageCount + 1;
			if ( _l < 1 ){
				_l = 1;
			}
		}
		
		return {
			prev : currentPage - 1 < 1 ? 1 : currentPage - 1,
			next : currentPage + 1 > totalPages ? totalPages : currentPage + 1,
			from : _l,
			to : _r,
			current : currentPage
		}
	}
	
	return {
		list : articleListContainer, 
		page: pageAnalyze(pageIndexCustomParams.page, Math.ceil(arrays.length / perPage))
	};
	
});
%>