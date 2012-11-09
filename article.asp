<!--#include file="config.asp" -->
<%
/**
 * ' pageCustomParams变量参数实例：
 * ' {
 * '	page: 1,
 * ' 	id: 1,
 * '	article: {
 * '		id: 1,
 * '				title: "...",
 * '				postDate: "1986/10/31 10:31:25",
 * '				editDate: "1986/10/31 10:31:25",
 * '				category: {
 * '					id: 0,
 * '					name: "...",
 * '					info: "...",
 * '					icon: "...",
 * '					url: "..."
 * '				},
 * '				tags: [
 * '					{
 * '						id: 0,
 * '						name: "...",
 * '						url: "..."
 * '					},
 * '					#loop#
 * '				],
 * '				content: "...",
 * '				url: "..."
 * '	}
 * ' }
 */
	// '加载用户登入状态
	require("status");
	
	// '加载全局变量模块
	require("cache_global");
	
	// '加载分类数据
	require("cache_category");
	
	pageCustomParams.page = http.get("page");
	if ( pageCustomParams.page.length === 0 ){ 
		pageCustomParams.page = 1; 
	}else{
		pageCustomParams.page = Number(pageCustomParams.page);
		if ( pageCustomParams.page < 1 ){
			pageCustomParams.page = 1;
		}
	}
	
	pageCustomParams.id = http.get("id");
	if ( pageCustomParams.id.length === 0 ){
		pageCustomParams.id = 0;
	}else{
		pageCustomParams.id = Number(pageCustomParams.id);
	}
	
	if ( pageCustomParams.id === 0 ){
		console.end("日志ID错误");
	}

	;(function(){
		var cache = require("cache"),
			tagsCacheData = require("tags"),
			categoryCacheData = cache.load("category"),
			id = pageCustomParams.id,
			sys_cache_article = cache.load("article", id),
			articleListContainer = {},
			categoryJSON = {};

		;(function(){
			for ( var o = 0 ; o < categoryCacheData.length ; o++ ){
				categoryJSON[categoryCacheData[o][0] + ""] = categoryCacheData[o];
			}
		})();
		
		function getTags(tagStr){
			var tagStrArrays = tagsCacheData.reFormatTags(tagStr),
				keeper = [];
				
			for ( var j = 0 ; j < tagStrArrays.length ; j++ ){
				var rets = tagsCacheData.readTagFromCache( Number(tagStrArrays[j]) );
				
				keeper.push({ 
					id: Number(tagStrArrays[j]), 
					name: rets,
					url: "tags.asp?id=" + tagStrArrays[j]
				});
			}
			
			return keeper;
		}
		
		function getCategoryName( id ){
			var rets = {};
			if ( categoryJSON[id + ""] !== undefined ){
				rets.id = id;
				rets.name = categoryJSON[id + ""][1];
				rets.info = categoryJSON[id + ""][2];
				rets.icon = "profile/icons/" + categoryJSON[id + ""][5];
				rets.url = "default.asp?c=" + id;
			}
			return rets;
		}
		
		if ( sys_cache_article.length === 1 ){
			articleListContainer.id = id;
			articleListContainer.title = sys_cache_article[0][0];
			articleListContainer.category = getCategoryName(sys_cache_article[0][1]);
			articleListContainer.content = sys_cache_article[0][2];
			articleListContainer.tags = getTags(sys_cache_article[0][3]);
			articleListContainer.postDate = sys_cache_article[0][5];
			articleListContainer.editDate = sys_cache_article[0][6];
		}
		
		pageCustomParams.article = articleListContainer;
	})();
	
		
	pageCustomParams.global.seotitle = pageCustomParams.article.log_title;
	
	include("profile/themes/" + pageCustomParams.global.theme + "/article.asp");
	
	CloseConnect();
%>