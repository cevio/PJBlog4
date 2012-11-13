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
	}
	
	// '获取页面ID参数（ID参数必须存在，否则无法读取文章数据）
	pageCustomParams.id = http.get("id");
	// 'id参数的逻辑判断和过滤
	if ( pageCustomParams.id.length === 0 ){
		console.end("article id error.");
	}else{
		if ( !isNaN( pageCustomParams.id ) ){
			// '统一转成数字类型
			pageCustomParams.id = Number(pageCustomParams.id);
			if ( pageCustomParams.id < 1 ){
				console.end("article id can not find");
			}
		}else{
			console.end("article ids type error.");
		}
	}
	
	// '开始对文章页面进行数据处理
	(function(){
		try{
			var cache = require("cache");
			
			// '处理文章数据
			;(function(){
				// '获取所有category数据列表
				var categoryCacheData = cache.load("category"),
					categoryJSON = categoryCacheData.list,
					categoryArray = categoryCacheData.arrays,
					tagsCacheData = require("tags"), // 'tags模块加载
					singleArticleCacheData = cache.load( "article", pageCustomParams.id ), // '本文章具体缓存
					singleArticleContainer = {}; // 文章解析容器
				
				// '排序
				pageCustomParams.categorys = categoryArray.sort(function( A, B ){
					return A.order > B.order;
				});
				
				// '获取category具体信息的方法
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
				
				// '获取tag具体信息的方法
				function getTags( tagStr ){
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
				
				// '将缓存数据放入新容器
				if ( singleArticleCacheData.length === 1 ){
					singleArticleContainer.id = pageCustomParams.id;
					singleArticleContainer.title = singleArticleCacheData[0][0];
					singleArticleContainer.category = getCategoryName(singleArticleCacheData[0][1]);
					singleArticleContainer.content = singleArticleCacheData[0][2];
					singleArticleContainer.tags = getTags(singleArticleCacheData[0][3]);
					singleArticleContainer.postDate = singleArticleCacheData[0][5];
					singleArticleContainer.editDate = singleArticleCacheData[0][6];
				}
				
				// '将新容器继承到全局数据变量 pageCustomParams.article.
				pageCustomParams.article = singleArticleContainer;
			})();
			
			// '评论列表数据处理
			;(function(){
				pageCustomParams.comments = {
					list: [],
					pagebar: []
				};
				
				// '辅助变量和参数以及模块
				var commentDataFromLogs = cache.load( "artcomm", pageCustomParams.id ), // '获取该文章下的评论数据
					commentContainer = {},
					commentOrderIDArray = [],
					commentArrayData = [],
					GRATE = require("gra"),
					perPage = pageCustomParams.tempCaches.globalCache.commentperpagecount,
					commentIdsFrom = 0,
					commentIdsTo = 0,
					commentCurrentPage = pageCustomParams.page,
					commentDataAnyle,
					commentDataAnyleFrom,
					commentDataAnyleTo,
					commentLists = [],
					commentPageList;
				
				// '检测是否为空数据
				if ( commentDataFromLogs.length === 0 ){
					return;
				};
				
				// '获取用户具体信息方法
				function getUserGRA( id, name, mail ){
					if ( Number(id) === 0 ){
						return { name: name, photo: GRATE( mail ), id: 0 };
					}else{
						var user = cache.load( "user", id );
						return { name: user[0][2], photo: user[0][1] + "/50", id: id }
					}
				}
				
				// '处理评论父子关系
				for ( var i = 0 ; i < commentDataFromLogs.length ; i++ ){
					var commentItemData = commentDataFromLogs[i],
						commId = commentItemData[0],
						commRootID = commentItemData[1],
						commContent = commentItemData[3],
						commUserInfo = getUserGRA( commentItemData[2], commentItemData[7], commentItemData[8] ),
						commDate = commentItemData[4],
						commIp = commentItemData[5],
						commAduit = commentItemData[6];
						
					commentOrderIDArray.push(commId);
					
					if ( commRootID === 0 ){
						if ( commentContainer[commId + ""] === undefined ){
							commentContainer[commId + ""] = {
								id: commId,
								commid: commRootID,
								content: commContent,
								date: commDate,
								ip: commIp,
								aduit: commAduit,
								user: commUserInfo,
								items: []
							};
						}else{
							commentContainer[commId + ""].id = commId;
							commentContainer[commId + ""].commid = commRootID;
							commentContainer[commId + ""].content = commContent;
							commentContainer[commId + ""].date = commDate;
							commentContainer[commId + ""].ip = commIp;
							commentContainer[commId + ""].aduit = commAduit;
							commentContainer[commId + ""].user = commUserInfo;
						}
					}else{
						if ( commentContainer[commRootID + ""] === undefined ){
							commentContainer[commRootID + ""] = {
								items: []
							}
						}
						
						commentContainer[commRootID + ""].items.push({
							id: commId,
							commid: commRootID,
							content: commContent,
							date: commDate,
							ip: commIp,
							aduit: commAduit,
							user: commUserInfo
						});
					}
				}
				
				// '处理评论顺序
				for ( i = 0 ; i < commentOrderIDArray.length ; i++ ){
					if ( commentContainer[commentOrderIDArray[i] + ""] !== undefined ){
						commentArrayData.push( commentContainer[commentOrderIDArray[i] + ""] );
					}
				}
				
				commentDataAnyle = pageCustomParams.tempModules.fns.pageFormTo( commentCurrentPage, perPage, commentArrayData.length);
				commentDataAnyleFrom = commentDataAnyle.from;
				commentDataAnyleTo = commentDataAnyle.to;
				
				for ( i = commentDataAnyleFrom ; i <= commentDataAnyleTo ; i++ ){
					commentLists.push( commentArrayData[i] );
				}
				
				pageCustomParams.comments.list = commentLists;
				
				// '处理分页列表数据
				commentPageList = pageCustomParams.tempModules.fns.pageAnalyze( commentCurrentPage, Math.ceil(commentArrayData.length / perPage) );
				if ( (pageCustomParams.comments.list.length > 0) && ( (commentPageList.to - commentPageList.from) > 0 ) ){
					for ( i = commentPageList.from ; i <= commentPageList.to ; i++ ){
						var url = "article.asp?id=" + pageCustomParams.id + "&page=" + i;
										
						if ( commentPageList.current === i ){
							pageCustomParams.comments.pagebar.push({
								key: i
							});
						}else{
							pageCustomParams.comments.pagebar.push({
								key: n,
								url : url
							});
						}				
					}
				}
			})();	
		}catch(e){
			console.end(e.message);
		}
	})();
	
	pageCustomParams.global.seotitle = pageCustomParams.article.title;
	
	delete pageCustomParams.tempCaches;
	delete pageCustomParams.tempModules;
	delete pageCustomParams.tempParams;
	
	include("profile/themes/" + pageCustomParams.global.theme + "/article.asp");
	CloseConnect();
%>