<%
define(function( require, exports, module ){
	var dbo = require("dbo"),
		connect = require("openDataBase");
	
	pageCustomParams.tempModules.fns = require("fn");
	pageCustomParams.tempParams.category = require("cache_category");
	pageCustomParams.tempModules.tags = require("tags");
	
	var getUserPhoto = pageCustomParams.tempModules.fns.getUserInfo;
		
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
	
	exports.categoryArticles = function( id, top, callback ){
		var rets = [];
		if ( connect === true ){
			dbo.trave({
				sql: "Select top " + top + " From blog_article Where log_category=" + id + " Order By log_posttime DESC",
				conn: config.conn,
				callback: function(){
					this.each(function(){
						rets.push({
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
			
			(typeof callback === "function") && callback(rets);
		}
		return rets;
	}
});
%>