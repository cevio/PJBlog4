<!--#include file="config.asp" -->
<%
	pageCustomParams.tempModules.cache = require("cache");
	pageCustomParams.tempModules.dbo = require("DBO");
	pageCustomParams.tempModules.connect = require("openDataBase");
	pageCustomParams.tempModules.fns = require("fn");
	pageCustomParams.tempModules.tags = require("tags");
	pageCustomParams.tempCaches.globalCache = require("cache_global");
	
	if ( pageCustomParams.tempModules.connect !== true ){
		console.end("连接数据库失败");
	}
	
	require("status")();
	
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
			console.end("page params error.");
		}
	}

	pageCustomParams.id = http.get("id");
	if ( pageCustomParams.id.length === 0 ){
		console.end("article id error.");
	}else{
		if ( !isNaN( pageCustomParams.id ) ){
			pageCustomParams.id = Number(pageCustomParams.id);
			if ( pageCustomParams.id < 1 ){
				console.end("article id can not find");
			}
		}else{
			console.end("article ids type error.");
		}
	}
	
	pageCustomParams.tempParams.category = require("cache_category");
	pageCustomParams.tags = {
		name: "",
		id: pageCustomParams.id,
		lists: [],
		pages: []
	};
	
	function getCategoryName( id ){
		var rets = {},
			categoryJSON = pageCustomParams.tempParams.category;
			
		if ( categoryJSON[id + ""] !== undefined ){
			rets.id = id;
			rets.name = categoryJSON[id + ""].name;
			rets.info = categoryJSON[id + ""].info;
			rets.icon = "profile/icons/" + categoryJSON[id + ""].icon;
			rets.url = "default.asp?c=" + id;
		}
		
		return rets;
	}
	
	function getTags( tagStr ){
		var tagsCacheData = pageCustomParams.tempModules.tags,
			tagStrArrays = tagsCacheData.reFormatTags(tagStr),
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
	
	(function(dbo){
		var keyName = pageCustomParams.tempModules.tags.readTagFromCache(pageCustomParams.id);
		console.log(keyName);
	})(pageCustomParams.tempModules.dbo);
	
/*	// '加载用户登入状态
	require("status");
	
	// '加载全局变量模块
	pageCustomParams.tempCaches.globalCache = require("cache_global");
	
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
	}
	
	// '获取页面ID参数（ID参数必须存在，否则无法读取文章数据）
	pageCustomParams.id = http.get("id");
	// 'id参数的逻辑判断和过滤
	if ( pageCustomParams.id.length === 0 ){
		console.end("tags id error.");
	}else{
		if ( !isNaN( pageCustomParams.id ) ){
			// '统一转成数字类型
			pageCustomParams.id = Number(pageCustomParams.id);
			if ( pageCustomParams.id < 1 ){
				console.end("tags id can not find");
			}
		}else{
			console.end("article ids type error.");
		}
	}
	
	// '获取tag
	pageCustomParams.tempModules.tags = require("tags");
	pageCustomParams.tempParams.tagsCache = pageCustomParams.tempModules.tags.readTagFromCache(pageCustomParams.id);
	
	pageCustomParams.tags = {
		list: [],
		pagebar: []
	};
	
	if ( pageCustomParams.tempParams.tagsCache !== undefined ){
		
		// '查询数据库，去的对应的日志ID。
		(function(){
			var dbo = require("DBO"),
				connecte = require("openDataBase"),
				cache = require("cache"),
				tagsCacheData = require("tags"),
				fns = require("fn"),
				categoryCacheData = cache.load("category"),
				categoryJSON = categoryCacheData.list,
				categoryArray = categoryCacheData.arrays,
				perPage = pageCustomParams.tempCaches.globalCache.articleperpagecount,
				i = 0;
				
			// '排序
			categoryArray = categoryArray.sort(function( A, B ){
				return A.order - B.order;
			});
		
			pageCustomParams.categorys = categoryArray;
	
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
				
			if ( connecte === true ){
				dbo.trave({
					conn: config.conn,
					sql: "Select * From blog_article Where log_tags like '%{" + pageCustomParams.tempParams.tagsCache.id + "}%' Order By log_posttime DESC",
					callback: function(rs){
						if ( !(rs.Bof || rs.Eof) ){
							// '处理数据内容
							this.serverPage(pageCustomParams.page, perPage, function(){
								pageCustomParams.tags.list.push({
									id: this("id").value,
									title: this("log_title").value,
									category: getCategoryName(this("log_category").value),
									postDate: this("log_posttime").value,
									editDate: this("log_updatetime").value,
									tags: getTags(this("log_tags").value),
									content: this("log_shortcontent").value,
									url: "article.asp?id=" + this("id").value
								});
							});
							
							// '处理分页内容
							pageCustomParams.tempParams.tagPages = fns.pageAnalyze(pageCustomParams.page, Math.ceil(rs.RecordCount / perPage));
							if ( 
								( pageCustomParams.tags.list.length > 0 ) && 
								( (pageCustomParams.tempParams.tagPages.to - pageCustomParams.tempParams.tagPages.from) > 0 ) 
							){
								for ( i = pageCustomParams.tempParams.tagPages.from ; i <= pageCustomParams.tempParams.tagPages.to ; i++ ){
									var url = "tags.asp?id=" + pageCustomParams.id + "&page=" + i;
													
									if ( pageCustomParams.tempParams.tagPages.current === i ){
										pageCustomParams.tags.pagebar.push({
											key: n
										});
									}else{
										pageCustomParams.tags.pagebar.push({
											key: n,
											url : url
										});
									}				
								}
							}
						}
					}
				});
				
				delete pageCustomParams.tempCaches;
				delete pageCustomParams.tempModules;
				delete pageCustomParams.tempParams;
				
				include("profile/themes/" + pageCustomParams.global.theme + "/tags.asp");
				CloseConnect();
			}else{
				console.log("链接数据库失败");
			}
		})();

	}else{
		console.log("id not find");
	}*/
%>