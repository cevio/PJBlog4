<!--#include file="config.asp" -->
<%
/**
 * ' pageCustomParams变量参数实例：
 * ' {
 * '	page: 1,
 * ' 	id: 1,
 * '	article: {
 * '		id: 1,
 * '		title: "...",
 * '		postDate: "1986/10/31 10:31:25",
 * '		editDate: "1986/10/31 10:31:25",
 * '		category: {
 * '			id: 0,
 * '			name: "...",
 * '			info: "...",
 * '			icon: "...",
 * '			url: "..."
 * '		},
 * '		tags: [
 * '			{
 * '				id: 0,
 * '				name: "...",
 * '				url: "..."
 * '			},
 * '			#loop#
 * '		],
 * '		content: "...",
 * '		url: "..."
 * '	}
 * ' }
 */
	// '加载用户登入状态
	require("status");
	
	// '加载全局变量模块
	pageCustomParams.globalCache = require("cache_global");
	
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
		
		// '处理评论
		;(function(){
			
			pageCustomParams.comments = {
				list: [],
				pagebar: []
			};
		
			var commentLogList = cache.load("artcomm", pageCustomParams.article.id),
				firstTreeList = [],
				firstTreeJson = {},
				lastTreeData = [],
				fns = require("fn"),
				GRATE = require("gra"),
				perPage = pageCustomParams.globalCache[0][21],
				currentPage = pageCustomParams.page;
				
			if ( commentLogList.length === 0 ){
				return ;
			}
			
			function getUserGRA( ids, name, mail ){
				if ( Number(ids) === 0 ){
					return {
						name: name,
						photo: GRATE(mail),
						id: 0
					}
				}else{
					var user = cache.load("user", ids);
					return {
						name: user[0][2],
						photo: user[0][1] + "/50",
						id: ids
					}
				}
			}
		
			if ( perPage > commentLogList.length ){
				perPage = commentLogList.length;
			}
			
			if ( perPage < 1 ){ perPage = 1; }
				
			for ( var i = 0 ; i < commentLogList.length ; i++ ){
				var commentItemData = commentLogList[i],
					ids = commentItemData[0],
					commid = commentItemData[1],
					content = commentItemData[3],
					user = getUserGRA(commentItemData[2], commentItemData[7], commentItemData[8]),
					date = commentItemData[4],
					ip = commentItemData[5],
					aduit = commentItemData[6];
				
				firstTreeList.push(ids); // '保证顺序
				
				if ( commid === 0 ){
					if (firstTreeJson[ids + ""] === undefined){
						firstTreeJson[ids + ""] = {
							id: ids,
							commid: commid,
							content: content,
							date: date,
							ip: ip,
							aduit: aduit,
							user: user,
							items: []
						}
					}else{
						firstTreeJson[id + ""].id = ids;
						firstTreeJson[id + ""].commid = commid;
						firstTreeJson[id + ""].content = content;
						firstTreeJson[id + ""].date = date;
						firstTreeJson[id + ""].ip = ip;
						firstTreeJson[id + ""].aduit = aduit;
						firstTreeJson[id + ""].user = user;
					}
				}else{
					if ( firstTreeJson[commid + ""] === undefined ){
						firstTreeJson[commid + ""] = {
							items: []
						}
					}
					
					firstTreeJson[commid + ""].items.push({
						id: ids,
						commid: commid,
						content: content,
						date: date,
						ip: ip,
						aduit: aduit,
						user: user
					});
				}
			}
			
			for ( var j = 0 ; j < firstTreeList.length ; j++ ){
				if ( firstTreeJson[firstTreeList[j] + ""] !== undefined ){
					lastTreeData.push(firstTreeJson[firstTreeList[j] + ""]);
				}
			}
	
			var commentFrom = ( currentPage - 1 ) * perPage + 1,
				commentTo = (currentPage * perPage),
				containers = [];
		
			if ( commentFrom > lastTreeData.length ){
				commentFrom = lastTreeData.length;
				commentTo = lastTreeData.length;
			}else{
				if ( commentFrom < 1 ){
					commentFrom = 1;
				}
				if ( commentTo > lastTreeData.length ){
					commentTo = lastTreeData.length;
				}
			}
			
			commentFrom--; commentTo--;
			
			for ( var j = commentFrom ; j <= commentTo ; j++ ){
				containers.push(lastTreeData[j]);
			}
			
			pageCustomParams.comments.list = containers;
			(function(){
				var _page = fns.pageAnalyze(currentPage, Math.ceil(lastTreeData.length / perPage));
				if ( (pageCustomParams.comments.list.length > 0) && ( (_page.to - _page.from) > 0 ) ){
					for ( var n = _page.from ; n <= _page.to ; n++ ){
						var _url = "default.asp?id=" + id + "&page=" + n;
										
						if ( _page.current === n ){
							pageCustomParams.comments.pagebar.push({
								key: n
							});
						}else{
							pageCustomParams.comments.pagebar.push({
								key: n,
								url : _url
							});
						}				
					}
				}
			})();
		})();	
	})();
	
		
	pageCustomParams.global.seotitle = pageCustomParams.article.log_title;
	
	include("profile/themes/" + pageCustomParams.global.theme + "/article.asp");
	
	CloseConnect();
%>