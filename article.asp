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
	
	pageCustomParams.article = {};
	pageCustomParams.comments = {
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
		var seArticleId = Session("readArticles");
		dbo.trave({
			type: 3,
			conn: config.conn,
			sql: "Select * From blog_article Where id=" + pageCustomParams.id,
			callback: function( rs ){
				if ( rs.Bof || rs.Eof ){
				}else{
					pageCustomParams.article.id = pageCustomParams.id;
					pageCustomParams.article.title = rs("log_title").value;
					pageCustomParams.article.category = getCategoryName(rs("log_category").value);
					pageCustomParams.article.content = rs("log_content").value;
					pageCustomParams.article.tags = getTags(rs("log_tags").value);
					pageCustomParams.article.postDate = rs("log_posttime").value;
					pageCustomParams.article.editDate = rs("log_updatetime").value;
					pageCustomParams.global.seotitle = pageCustomParams.article.title;
					if ( !seArticleId ){ seArticleId = []; }
					if ( seArticleId.indexOf(pageCustomParams.article.id) === -1 ){
						rs("log_views") = rs("log_views").value + 1;
						rs.Update();
						seArticleId.push(pageCustomParams.article.id);
					}
					Session("readArticles") = seArticleId;
				}
			}
		});
	})(pageCustomParams.tempModules.dbo);
	
	(function(dbo){
		var totalSum = Number(String(config.conn.Execute("Select count(id) From blog_comment")(0))),
			perpage = pageCustomParams.tempCaches.globalCache.commentperpagecount,
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
			sql = "Select top " + _mod + " * From blog_comment Where commentid=0 And commentlogid=" + pageCustomParams.article.id + " Order By id ASC";
			sql = "Select * From (" + sql + ") Order By id DESC";
		}else{
			sql = "Select top " 
				+ (pageCustomParams.page * perpage) 
				+ " * From blog_comment Where commentid=0 And commentlogid=" + pageCustomParams.article.id + " Order By id DESC";
			sql = "Select * From (Select top " + perpage + " * From (" + sql + ") Order By id) Order By id DESC";
		}
		
		pageCustomParams.comments.pages = pageCustomParams.tempModules.fns.pageAnalyze(pageCustomParams.page, totalPages);
		
		function getCommentReplyList(root){
			var commentReplyList = [];
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_comment Where commentid=" + root + " And commentlogid=" + pageCustomParams.article.id + " Order By commentpostdate DESC",
				callback: function(){
					this.each(function(){
						commentReplyList.push({
							id: this("id").value,
							commid: this("commentid").value,
							content: this("commentcontent").value,
							date: this("commentpostdate").value,
							ip: this("commentpostip").value,
							user: this("commentuserid").value
						});
					});
				}
			});
			return commentReplyList;
		}
		
		dbo.trave({
			conn: config.conn,
			sql: sql,
			callback: function(){
				this.each(function(){
					pageCustomParams.comments.lists.push({
						id: this("id").value,
						commid: this("commentid").value,
						content: this("commentcontent").value,
						date: this("commentpostdate").value,
						ip: this("commentpostip").value,
						user: this("commentuserid").value,
						childrens: getCommentReplyList(this("id").value)
					});
				});
			}
		});
	})(pageCustomParams.tempModules.dbo);
	
	delete pageCustomParams.tempCaches;
	delete pageCustomParams.tempModules;
	delete pageCustomParams.tempParams;
	
	include("profile/themes/" + pageCustomParams.global.theme + "/article.asp");
	CloseConnect();
%>