<!--#include file="config.asp" -->
<%
/**
 * ' pageCustomParams变量参数实例：
 * ' {
 * '	page: 1,
 * ' 	cateID: 0,
 * '	article: {
 * '		list: [ // 文章列表数据
 * '			{
 * '				id: 1,
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
 * '			},
 * '			#loop#
 * '		],
 * '		pagebar: [
 * '			{
 * '				key: 1[,url: "...."]
 * '			},
 * '			#loop#
 * '		]
 * '	}
 * ' }
 */
 	
	// '加载用户登入状态
	require("status");
	
	// '加载全局变量模块
	pageCustomParams.globalCache = require("cache_global");
	
	// '加载分类数据
	require("cache_category");

	// '当前页面page参数
	pageCustomParams.page = http.get("page");
	if ( pageCustomParams.page.length === 0 ){ 
		pageCustomParams.page = 1; 
	}else{
		pageCustomParams.page = Number(pageCustomParams.page);
		if ( pageCustomParams.page < 1 ){
			pageCustomParams.page = 1;
		}
	}
	
	// '当前页面分类参数（进入category筛选模式）
	pageCustomParams.cateID = http.get("c");
	if ( pageCustomParams.cateID.length === 0 ){
		pageCustomParams.cateID = 0;
	}else{
		pageCustomParams.cateID = Number(pageCustomParams.cateID);
	};
	
	// '分析处理相关逻辑
	pageCustomParams.article = {
		list: [],
		pagebar: []
	}

	// ' 处理日志列表
	;(function(){
		var cache = require("cache"),
			categoryCacheData = cache.load("category"),
			tagsCacheData = require("tags"),
			fns = require("fn"),
			perPage = pageCustomParams.globalCache[0][10],
			modules, 
			list, 
			pagebar,
			categoryJSON = {},
			articleIdFrom = 0,
			articleIdTo = 0;
			
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
			
		if ( pageCustomParams.cateID === undefined || pageCustomParams.cateID === 0 ){
			modules = cache.load("article_pages");
		}else{
			modules = cache.load("article_pages_cate", pageCustomParams.cateID);
		}
		
		;(function(){
			for ( var o = 0 ; o < categoryCacheData.length ; o++ ){
				categoryJSON[categoryCacheData[o][0] + ""] = categoryCacheData[o];
			}
		})();
		
		if ( modules.length === 0 ){
			pageCustomParams.article.list = [];
			pageCustomParams.article.pagebar = { from: 0, to: 0 };
		}else{
			articleIdFrom = (pageCustomParams.page - 1) * perPage + 1;
			articleIdTo = pageCustomParams.page * perPage;
			
			if ( articleIdFrom > modules.length ){
				articleIdFrom = modules.length;
				articleIdTo = modules.length;
			}else{
				if ( articleIdFrom < 1 ){
					articleIdFrom = 1;
				}
				if ( articleIdTo > modules.length ){
					articleIdTo = modules.length;
				}
			}
			articleIdFrom--; articleIdTo--;
			
			;(function(){
				for ( var i = articleIdFrom ; i <= articleIdTo ; i++ ){
					var sys_cache_article = cache.load("article", Number(modules[i][0]));
						
						pageCustomParams.article.list.push({
							id: Number(modules[i][0]),
							title: sys_cache_article[0][0],
							postDate: sys_cache_article[0][5],
							editDate: sys_cache_article[0][6],
							category: getCategoryName(sys_cache_article[0][1]),
							tags: getTags(sys_cache_article[0][3]),
							content: sys_cache_article[0][7],
							url: "article.asp?id=" + modules[i][0]
						});
				}
				
				pagebar = fns.pageAnalyze(pageCustomParams.page, Math.ceil(modules.length / perPage));
			})();
			
			
		}
		
		if ( (pageCustomParams.article.list.length > 0) && ( (pagebar.to - pagebar.from) > 0 ) ){
			for ( var n = pagebar.from ; n <= pagebar.to ; n++ ){
				var _url = pageCustomParams.cateID > 0 ? 
								"default.asp?c=" + pageCustomParams.cateID + "&page=" + n :
								"default.asp?page=" + n;
								
				if ( pagebar.current === n ){
					pageCustomParams.article.pagebar.push({
						key: n
					});
				}else{
					pageCustomParams.article.pagebar.push({
						key: n,
						url : _url
					});
				}				
			}
		}
	})();
	
	// '加载对应主题模板
	include("profile/themes/" + pageCustomParams.global.theme + "/default.asp");
	
	// '关闭数据库
	CloseConnect();
%>