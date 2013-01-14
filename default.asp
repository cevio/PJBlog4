<!--#include file="config.asp" -->
<%
try{
	pageCustomParams.tempModules.cache = require("cache");
	pageCustomParams.tempModules.dbo = require("DBO");
	pageCustomParams.tempModules.connect = require("openDataBase");
	pageCustomParams.tempModules.fns = require("fn");
	pageCustomParams.tempModules.tags = require("tags");
	pageCustomParams.tempModules.sap = require("sap");
	pageCustomParams.tempCaches.globalCache = require("cache_global");
	
	if ( !pageCustomParams.tempCaches.globalCache.webstatus ){
		ConsoleClose("抱歉，网站暂时被关闭。");
	}
	
	if ( pageCustomParams.tempModules.connect !== true ){
		ConsoleClose("连接数据库失败");
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
			ConsoleClose("page params error.");
		}
	};

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
	
	pageCustomParams.tempParams.category = require("cache_category");
	
	pageCustomParams.articles = {
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
	
	var getUserPhoto = pageCustomParams.tempModules.fns.getUserInfo;
	
	(function(dbo){
		var sql = "",
			perpage = pageCustomParams.tempCaches.globalCache.articleperpagecount,
			totalSum = 0,
			_pages = 0,
			_mod = 0,
			totalPages = 0,
			scondCategory = ["log_category=" + pageCustomParams.cateID];
			
		if ( pageCustomParams.cateID > 0 ){
			if ( pageCustomParams.tempParams.category[pageCustomParams.cateID + ""] !== undefined ){
				var childs = pageCustomParams.tempParams.category[pageCustomParams.cateID + ""].childrens;
				for ( var c in childs ){
					if ( !isNaN(c) ){
						scondCategory.push("log_category=" + childs[c].id);
					}
				}
			}
			totalSum = Number(String(config.conn.Execute("Select count(id) From blog_article Where " + scondCategory.join(" OR "))(0)));
		}else{
			totalSum = Number(String(config.conn.Execute("Select count(id) From blog_article")(0)));
		}
		
		if ( totalSum === 0 ){
			return;
		}

		if ( totalSum < perpage ){ perpage = totalSum; }
		_mod = totalSum % perpage;
		_pages = Math.floor(totalSum / perpage);
		if ( _mod > 0 ){ totalPages = _pages + 1; }else{ totalPages = _pages; }
		if ( pageCustomParams.page > totalPages ){ pageCustomParams.page = totalPages;}
		
		var BaseCategorySQL = scondCategory.join(" OR ");

		if ( pageCustomParams.page > _pages ){
			if ( pageCustomParams.cateID > 0 ){
				sql = "Select top " + _mod + " * From blog_article Where " + BaseCategorySQL + " Order By id ASC, log_istop DESC";
			}else{	
				sql = "Select top " + _mod + " * From blog_article Order By id ASC, log_istop DESC";
			}
			sql = "Select * From (" + sql + ") Order By id DESC";
		}else{
			if ( pageCustomParams.cateID > 0 ){
				sql = "Select top " 
					+ (pageCustomParams.page * perpage) 
					+ " * From blog_article Where " 
					+ BaseCategorySQL
					+ " Order By id DESC";
			}else{
				sql = "Select top " 
					+ (pageCustomParams.page * perpage) 
					+ " * From blog_article Order By id DESC";
			}
			sql = "Select * From (Select top " + perpage + " * From (" + sql + ") Order By id) Order By id DESC";
		}

		dbo.trave({
			conn: config.conn,
			sql: sql,
			callback: function(){
				this.each(function(){
					pageCustomParams.articles.lists.push({
						id: this("id").value,
						title: this("log_title").value,
						postDate: this("log_posttime").value,
						editDate: this("log_updatetime").value,
						category: getCategoryName(this("log_category").value),
						tags: getTags(this("log_tags").value),
						content: this("log_shortcontent").value,
						url: "article.asp?id=" + this("id").value,
						views: this("log_views").value,
						uid: getUserPhoto(this("log_uid").value),
						istop: this("log_istop").value,
						cover: this("log_cover").value,
						comments: this("log_comments").value
					});
				});
			}
		});
		
		pageCustomParams.articles.lists = pageCustomParams.articles.lists.sort(function(A, B){
			var a = A.istop ? 1 : 0, 
				b = B.istop ? 1 : 0;
			return b - a;
		});
		
		pageCustomParams.tempParams.pages = pageCustomParams.tempModules.fns.pageAnalyze(pageCustomParams.page, totalPages);
		
		if ( 
			( pageCustomParams.articles.lists.length > 0 ) && 
			( (pageCustomParams.tempParams.pages.to - pageCustomParams.tempParams.pages.from) > 0 ) 
		){
			for ( i = pageCustomParams.tempParams.pages.from ; i <= pageCustomParams.tempParams.pages.to ; i++ ){
				var url = "default.asp?c=" + pageCustomParams.cateID + "&page=" + i;
								
				if ( pageCustomParams.tempParams.pages.current === i ){
					pageCustomParams.articles.pages.push({ key: i });
				}else{
					pageCustomParams.articles.pages.push({ key: i, url : url });
				}				
			}
		}
		
	})(pageCustomParams.tempModules.dbo);
	
	delete pageCustomParams.tempCaches;
	delete pageCustomParams.tempModules;
	delete pageCustomParams.tempParams;

	include("profile/themes/" + pageCustomParams.global.theme + "/default.asp");
	CloseConnect();
}catch(e){
	ConsoleClose(e.message);
}
%>