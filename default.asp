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
	
	function getUserPhoto(id, name, mail){
		var userInfo = {};
		
		if ( id === -1 ){
			userInfo.photo = config.user.photo;
			userInfo.name = config.user.name;
			userInfo.poster = true;
			userInfo.oauth = "system";
			userInfo.login = config.user.login;
			userInfo.logindate = "";
			userInfo.loginip = "";
		}
		else if ( id === 0 ){
			userInfo.photo = pageCustomParams.tempModules.GRA(mail);
			userInfo.name = name;
			userInfo.poster = false;
			userInfo.oauth = "";
			userInfo.login = false;
			userInfo.logindate = "";
			userInfo.loginip = "";
		}
		else{
			var userCache = pageCustomParams.tempModules.cache.load("user", id),
				userInfo = {},
				proxyPhoto = {};
				
			if (userCache.length === 1){
				userInfo.photo = userCache[0][0];
				userInfo.name = userCache[0][1];
				userInfo.poster = userCache[0][2];
				userInfo.oauth = userCache[0][3];
				userInfo.login = userCache[0][4];
				userInfo.logindate = userCache[0][5];
				userInfo.loginip = userCache[0][6];
				pageCustomParams.tempModules.sap.proxy("assets.member.list.photo", [proxyPhoto, userInfo.oauth, userInfo.photo, 100]);
				userInfo.photo = proxyPhoto[userInfo.oauth];
			}
		}
		
		return userInfo;
	}
	
	(function(dbo){
		var sql = "",
			perpage = pageCustomParams.tempCaches.globalCache.articleperpagecount,
			totalSum = 0,
			_pages = 0,
			_mod = 0,
			totalPages = 0;
			
		if ( pageCustomParams.cateID > 0 ){
			totalSum = Number(String(config.conn.Execute("Select count(id) From blog_article Where log_category=" + pageCustomParams.cateID)(0)));
		}else{
			totalSum = Number(String(config.conn.Execute("Select count(id) From blog_article")(0)));
		}
		
		if ( totalSum < perpage ){ perpage = totalSum; }
		_mod = totalSum % perpage;
		_pages = Math.floor(totalSum / perpage);
		if ( _mod > 0 ){ totalPages = _pages + 1; }else{ totalPages = _pages; }
		if ( pageCustomParams.page > totalPages ){ pageCustomParams.page = totalPages;}

		if ( pageCustomParams.page > _pages ){
			if ( pageCustomParams.cateID > 0 ){
				sql = "Select top " + _mod + " * From blog_article Where log_category=" + pageCustomParams.cateID + " Order By id ASC";
			}else{	
				sql = "Select top " + _mod + " * From blog_article Order By id ASC";
			}
			sql = "Select * From (" + sql + ") Order By id DESC";
		}else{
			if ( pageCustomParams.cateID > 0 ){
				sql = "Select top " 
					+ (pageCustomParams.page * perpage) 
					+ " * From blog_article Where log_category=" 
					+ pageCustomParams.cateID 
					+ " Order By id DESC";
			}else{
				sql = "Select top " 
					+ (pageCustomParams.page * perpage) 
					+ " * From blog_article Order By id DESC";
			}
			sql = "Select * From (Select top " + perpage + " * From (" + sql + ") Order By id) Order By id DESC";
		}
		
		pageCustomParams.tempParams.pages = pageCustomParams.tempModules.fns.pageAnalyze(pageCustomParams.page, totalPages);
		
		if ( 
			( pageCustomParams.articles.lists.length > 0 ) && 
			( (pageCustomParams.tempParams.pages.to - pageCustomParams.tempParams.pages.from) > 0 ) 
		){
			for ( i = pageCustomParams.tempParams.pages.from ; i <= pageCustomParams.tempParams.pages.to ; i++ ){
				var url = "default.asp?c=" + pageCustomParams.cateID + "&page=" + i;
								
				if ( pageCustomParams.tempParams.pages.current === i ){
					pageCustomParams.articles.pages.push({ key: n });
				}else{
					pageCustomParams.articles.pages.push({ key: n, url : url });
				}				
			}
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
						content: this("log_content").value,
						url: "article.asp?id=" + this("id").value,
						views: this("log_views").value,
						uid: getUserPhoto(this("log_uid").value)
					});
				});
			}
		});
		
	})(pageCustomParams.tempModules.dbo);
	
	delete pageCustomParams.tempCaches;
	delete pageCustomParams.tempModules;
	delete pageCustomParams.tempParams;

	include("profile/themes/" + pageCustomParams.global.theme + "/default.asp");
	CloseConnect();
%>