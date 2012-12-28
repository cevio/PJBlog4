<!--#include file="config.asp" -->
<%
try{
	pageCustomParams.tempModules.cache = require("cache");
	pageCustomParams.tempModules.dbo = require("DBO");
	pageCustomParams.tempModules.connect = require("openDataBase");
	pageCustomParams.tempModules.fns = require("fn");
	pageCustomParams.tempModules.tags = require("tags");
	pageCustomParams.tempCaches.globalCache = require("cache_global");
	
	if ( !pageCustomParams.tempCaches.globalCache.webstatus ){
		ConsoleClose("抱歉，网站暂时被关闭。");
	}
	
	if ( pageCustomParams.tempModules.connect !== true ){
		ConsoleClose("连接数据库失败");
	}
	
	pageCustomParams.keyword = fns.HTMLStr(fns.SQLStr(http.form("keyword")));
	pageCustomParams.keytype = fns.HTMLStr(fns.SQLStr(http.form("keytype"))); //' all | title | content | tag
	
	if ( pageCustomParams.keyword.length === 0 ){
		ConsoleClose("非法参数");
	}
	
	if ( pageCustomParams.keytype.length === 0 ){
		keytype = "all";
	}
	
	if ( ["title", "content", "tag"].indexOf(pageCustomParams.keytype) === -1 ){
		pageCustomParams.keytype = "all";
	}
	
	pageCustomParams.keyword = pageCustomParams.keyword
								.replace(/^\s+/, "")
								.replace(/\s+$/, "")
								.replace(/\s+/g, " ")
								.replace(/\s/g, ",");
	
	pageCustomParams.keywords = pageCustomParams.keyword.split(",");
	
	require("status")();
	
	pageCustomParams.tempParams.category = require("cache_category");
	pageCustomParams.found = {
		keywords: pageCustomParams.keywords,
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
		var condition = " Where ";
		if ( pageCustomParams.keytype === "title" ){
			condition += "instr(log_title, '" + pageCustomParams.keywird + "')";
		}else if ( pageCustomParams.keytype === "content" ){
			condition += "instr(log_content, '" + pageCustomParams.keywird + "')";
		}else if ( pageCustomParams.keytype === "tag" ){
			
		}else{
			condition += "instr(log_title, '" + pageCustomParams.keywird + "') or instr(log_content, '" + pageCustomParams.keywird + "')";
		}

		var totalSum = Number(String(config.conn.Execute("Select count(id) From blog_article Where log_title like '%{" + pageCustomParams.id + "}%'")(0))),
			perpage = pageCustomParams.tempCaches.globalCache.articleperpagecount,
			_mod = 0,
			_pages = 0,
			totalPages = 0,
			sql = "";
			
		if ( totalSum < perpage ){ perpage = totalSum; }
		_mod = totalSum % perpage;
		_pages = Math.floor(totalSum / perpage);
		if ( _mod > 0 ){ totalPages = _pages + 1; }else{ totalPages = _pages; }
		if ( pageCustomParams.page > totalPages ){ pageCustomParams.page = totalPages;}
		
		if ( pageCustomParams.page > _pages ){
			sql = "Select top " + _mod + " * From blog_article Where log_tags like '%{" + pageCustomParams.id + "}%' Order By id ASC";
			sql = "Select * From (" + sql + ") Order By id DESC";
		}else{
			sql = "Select top " 
				+ (pageCustomParams.page * perpage) 
				+ " * From blog_article Where log_tags like '%{" + pageCustomParams.id + "}%' Order By id DESC";
			sql = "Select * From (Select top " + perpage + " * From (" + sql + ") Order By id) Order By id DESC";
		}
		
		pageCustomParams.tempParams.pages = pageCustomParams.tempModules.fns.pageAnalyze(pageCustomParams.page, totalPages);
		
		if ( 
			( pageCustomParams.tags.lists.length > 0 ) && 
			( (pageCustomParams.tempParams.pages.to - pageCustomParams.tempParams.pages.from) > 0 ) 
		){
			for ( i = pageCustomParams.tempParams.pages.from ; i <= pageCustomParams.tempParams.pages.to ; i++ ){
				var url = "article.asp?id=" + pageCustomParams.id + "&page=" + i;
								
				if ( pageCustomParams.tempParams.pages.current === i ){
					pageCustomParams.tags.pages.push({ key: n });
				}else{
					pageCustomParams.tags.pages.push({ key: n, url : url });
				}				
			}
		}
		
		dbo.trave({
			conn: config.conn,
			sql: sql,
			callback: function(){
				this.each(function(){
					pageCustomParams.tags.lists.push({
						id: this("id").value,
						title: this("log_title").value,
						postDate: this("log_posttime").value,
						editDate: this("log_updatetime").value,
						category: getCategoryName(this("log_category").value),
						tags: getTags(this("log_tags").value),
						content: this("log_content").value,
						url: "article.asp?id=" + this("id").value
					});
				});
			}
		});
	})(pageCustomParams.tempModules.dbo);
	
				
	delete pageCustomParams.tempCaches;
	delete pageCustomParams.tempModules;
	delete pageCustomParams.tempParams;
	
	include("profile/themes/" + pageCustomParams.global.theme + "/search.asp");
	CloseConnect();
}catch(e){
	ConsoleClose(e.message);
}
%>