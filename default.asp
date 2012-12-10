<!--#include file="config.asp" -->
<%
	// '加载用户登入状态
	require("status");
	
	// '加载全局变量模块
	pageCustomParams.tempCaches.globalCache = require("cache_global");
	
	// '加载fn模块
	pageCustomParams.tempModules.fns = require("fn");
	
	// '获取页面page参数
	pageCustomParams.page = http.get("page");
	// 'Page参数的逻辑判断和过滤
	if ( pageCustomParams.page.length === 0 ){ 
		pageCustomParams.page = 1; 
	}else{
		// '判断是否是数字类型（包括字符串）
		if ( !isNaN( pageCustomParams.page ) ){
			// '统一转成数字类型
			pageCustomParams.page = Number(pageCustomParams.page);
			if ( pageCustomParams.page < 1 ){
				pageCustomParams.page = 1;
			}
		}else{
			console.end("page params error.");
		}
	};
	
	// '当前页面分类参数（进入category筛选模式）
	pageCustomParams.cateID = http.get("c");
	if ( pageCustomParams.cateID.length === 0 ){
		pageCustomParams.cateID = 0;
	}else{
		if ( !isNaN(pageCustomParams.cateID) ){
			pageCustomParams.cateID = Number(pageCustomParams.cateID);
			if ( pageCustomParams.cateID < 1 ){
				pageCustomParams.cateID = 0;
			}
		}else{
			pageCustomParams.cateID = 0;
		}
	};
	
	pageCustomParams.article = {
		list: [],
		pagebar: []
	};
	
	// '处理日志列表
	;(function(){
		var cache = require("cache"),
			tagsCacheData = require("tags"),
			fns = require("fn"),
			perPage = pageCustomParams.tempCaches.globalCache.articleperpagecount,
			categoryCacheData = cache.load("category"),
			articleCurrentPage = pageCustomParams.page,
			modules,
			articlesArray = [],
			categoryJSON = categoryCacheData.list,
			categoryArray = categoryCacheData.arrays,
			i = 0;

		function getTags( tagStr ){
			var tagStrArrays = tagsCacheData.reFormatTags(tagStr),
				keeper = [];	
			for ( var j = 0 ; j < tagStrArrays.length ; j++ ){
				var rets = tagsCacheData.readTagFromCache( Number(tagStrArrays[j]) );
				if ( rets !== undefined ){
					keeper.push({ 
						id: Number(tagStrArrays[j]), 
						name: rets.name,
						url: "tags.asp?id=" + tagStrArrays[j],
						count: rets.count
					});
				}
			}
			return keeper;
		}
		
		function getCategoryName( id ){
			var rets = {};
			if ( categoryJSON[id + ""] !== undefined ){
				rets.id = id;
				rets.name = categoryJSON[id + ""].name;
				rets.info = categoryJSON[id + ""].info;
				rets.icon = "profile/icons/" + categoryJSON[id + ""].icon;
				rets.url = "default.asp?c=" + id;
			}
			return rets;
		}
		
		if ( pageCustomParams.cateID === undefined || pageCustomParams.cateID === 0 ){
			modules = cache.load("article_pages");
		}else{
			modules = cache.load("article_pages_cate", pageCustomParams.cateID);
		}

		categoryArray = categoryArray.sort(function( A, B ){
			return A.order - B.order;
		});
		
		pageCustomParams.categorys = categoryArray;
		
		if ( modules.length > 0 ){
			var articleContainerParams = pageCustomParams.tempModules.fns.pageFormTo( articleCurrentPage, perPage, modules.length );
			for ( i = articleContainerParams.from ; i <= articleContainerParams.to ; i++ ){
				var articleCacheDatas = cache.load("article", Number(modules[i][0]));
				articlesArray.push({
					id: Number(modules[i][0]),
					title: articleCacheDatas[0][0],
					postDate: articleCacheDatas[0][5],
					editDate: articleCacheDatas[0][6],
					category: getCategoryName(articleCacheDatas[0][1]),
					tags: getTags(articleCacheDatas[0][3]),
					content: articleCacheDatas[0][7],
					url: "article.asp?id=" + modules[i][0]
				});
			}
			pageCustomParams.article.list = articlesArray;
			
			var articlePagebar = pageCustomParams.tempModules.fns.pageAnalyze(articleCurrentPage, Math.ceil(modules.length / perPage));
			if ( (pageCustomParams.article.list.length > 0) && ( (articlePagebar.to - articlePagebar.from) > 0 ) ){
				for ( i = articlePagebar.from ; i <= articlePagebar.to ; i++ ){
					var url = pageCustomParams.cateID > 0 ? 
									"default.asp?c=" + pageCustomParams.cateID + "&page=" + i :
									"default.asp?page=" + i;
									
					if ( articlePagebar.current === i ){
						pageCustomParams.article.pagebar.push({
							key: n
						});
					}else{
						pageCustomParams.article.pagebar.push({
							key: n,
							url : url
						});
					}				
				}
			}
		}
		
	})();
	
	delete pageCustomParams.tempCaches;
	delete pageCustomParams.tempModules;
	delete pageCustomParams.tempParams;
	
	include("profile/themes/" + pageCustomParams.global.theme + "/default.asp");
	CloseConnect();
%>