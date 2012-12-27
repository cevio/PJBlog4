<!--#include file="config.asp" -->
<%
	pageCustomParams.tempModules.cache = require("cache");
	pageCustomParams.tempModules.dbo = require("DBO");
	pageCustomParams.tempModules.connect = require("openDataBase");
	pageCustomParams.tempModules.fns = require("fn");
	pageCustomParams.tempModules.tags = require("tags");
	pageCustomParams.tempModules.sap = require("sap");
	pageCustomParams.tempModules.GRA = require("gra");
	pageCustomParams.tempCaches.globalCache = require("cache_global");
	
	if ( !pageCustomParams.tempCaches.globalCache.webstatus ){
		console.end("抱歉，网站暂时被关闭。");
	}
	
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
	
	function getUserPhoto(id, name, mail){
		var userInfo = {};
		id = Number(id);
		if ( id === -1 ){
			if ( config.user.login ){
				if ( config.user.id === -1 ){
					userInfo.photo = config.user.photo;
					userInfo.name = config.user.name;
				}else{
					userInfo.photo = pageCustomParams.tempModules.GRA(pageCustomParams.global.authoremail);
					userInfo.name = pageCustomParams.global.nickname;
				}
			}else{
				userInfo.photo = pageCustomParams.tempModules.GRA(pageCustomParams.global.authoremail);
				userInfo.name = pageCustomParams.global.nickname;
			}
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
				userInfo = {};
				
			if (userCache.length === 1){
				userInfo.photo = userCache[0][0];
				userInfo.name = userCache[0][1];
				userInfo.poster = userCache[0][2];
				userInfo.oauth = userCache[0][3];
				userInfo.login = userCache[0][4];
				userInfo.logindate = userCache[0][5];
				userInfo.loginip = userCache[0][6];
			}
		}
		
		return userInfo;
	}

	function str2Array(str){
		return (new Function("return " + str))();
	}
	
	(function(dbo){
		var seArticleId = str2Array(Session("readArticles") + "");
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
					pageCustomParams.article.user = getUserPhoto(rs("log_uid").value);
					if ( !seArticleId ){ seArticleId = []; }
					if ( seArticleId.indexOf(pageCustomParams.article.id) === -1 ){
						var views = rs("log_views").value;
						rs("log_views") = views + 1;
						rs.Update();
						seArticleId.push(pageCustomParams.article.id);
						pageCustomParams.article.views = views + 1;
						Session("readArticles") = JSON.stringify(seArticleId);
					}else{
						pageCustomParams.article.views = rs("log_views").value;
					}
				}
			}
		});
		pageCustomParams.article.other = {};
		dbo.trave({
			conn: config.conn,
			sql: "Select top 1 * From blog_article Where id<" + pageCustomParams.article.id + " Order By log_posttime DESC",
			callback: function(rs){
				if ( rs.Bof || rs.Eof ){
				}else{
					pageCustomParams.article.other.prev = {
						title: rs("log_title").value,
						id: rs("id").value,
						url: "article.asp?id=" + rs("id").value,
						cover: rs("log_cover").value
					}
				}
			}
		});
		dbo.trave({
			conn: config.conn,
			sql: "Select top 1 * From blog_article Where id>" + pageCustomParams.article.id + " Order By log_posttime ASC",
			callback: function(rs){
				if ( rs.Bof || rs.Eof ){
				}else{
					pageCustomParams.article.other.next = {
						title: rs("log_title").value,
						id: rs("id").value,
						url: "article.asp?id=" + rs("id").value,
						cover: rs("log_cover").value
					}
				}
			}
		});
	})(pageCustomParams.tempModules.dbo);
	
	(function(dbo){
		var totalSum = Number(String(config.conn.Execute("Select count(id) From blog_comment Where commentid=0 And commentlogid=" + pageCustomParams.article.id)(0))),
			perpage = pageCustomParams.tempCaches.globalCache.commentperpagecount,
			_mod = 0,
			_pages = 0,
			totalPages = 0,
			sql = "",
			globalCommentAduit = pageCustomParams.tempCaches.globalCache.commentaduit === true;

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

		function getCommentReplyList(root){
			var commentReplyList = [];
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_comment Where commentid=" + root + " And commentlogid=" + pageCustomParams.article.id + " Order By commentpostdate DESC",
				callback: function(){
					this.each(function(){
						var canpush = true;
						if ( globalCommentAduit === true ){
							if ( this("commentaudit").value !== true ){
								if ( (config.user.id !== this("commentuserid").value) || (this("commentuserid").value === 0) ){
									canpush = false;
								}
							}
						}
						if ( canpush === false ){
							if ( config.user.admin === true ){
								canpush = true;
							}
						}
						
						if ( canpush === true ){
							commentReplyList.push({
								id: this("id").value,
								commid: this("commentid").value,
								content: this("commentcontent").value,
								date: this("commentpostdate").value,
								ip: this("commentpostip").value,
								user: getUserPhoto(this("commentuserid").value, this("commentusername").value, this("commentusermail").value),
								website: this("commentwebsite").value
							});
						}
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
					var canpush = true;
					if ( globalCommentAduit === true ){
						if ( this("commentaudit").value !== true ){
							if ( (config.user.id !== this("commentuserid").value) || (this("commentuserid").value === 0) ){
								canpush = false;
							}
						}
					}
					if ( canpush === false ){
						if ( config.user.admin === true ){
							canpush = true;
						}
					}

					if ( canpush === true ){
						pageCustomParams.comments.lists.push({
							id: this("id").value,
							commid: this("commentid").value,
							content: this("commentcontent").value,
							date: this("commentpostdate").value,
							ip: this("commentpostip").value,
							user: getUserPhoto(this("commentuserid").value, this("commentusername").value, this("commentusermail").value),
							website: this("commentwebsite").value,
							childrens: getCommentReplyList(this("id").value)
						});
					}
				});
			}
		});
		
		pageCustomParams.tempParams.pages = pageCustomParams.tempModules.fns.pageAnalyze(pageCustomParams.page, totalPages);
		
		if ( 
			( pageCustomParams.comments.lists.length > 0 ) && 
			( (pageCustomParams.tempParams.pages.to - pageCustomParams.tempParams.pages.from) > 0 ) 
		){
			for ( i = pageCustomParams.tempParams.pages.from ; i <= pageCustomParams.tempParams.pages.to ; i++ ){
				var url = "article.asp?id=" + pageCustomParams.id + "&page=" + i;
								
				if ( pageCustomParams.tempParams.pages.current === i ){
					pageCustomParams.comments.pages.push({ key: i });
				}else{
					pageCustomParams.comments.pages.push({ key: i, url : url });
				}				
			}
		}
	})(pageCustomParams.tempModules.dbo);
	
	delete pageCustomParams.tempCaches;
	delete pageCustomParams.tempModules;
	delete pageCustomParams.tempParams;

	include("profile/themes/" + pageCustomParams.global.theme + "/article.asp");
	CloseConnect();
%>