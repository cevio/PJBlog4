<%
define(function(require, exports, module){
	exports["global"] = function(){
		return {
			sql: "Select title, qq_appid, qq_appkey, website, description, theme, style, nickname, webstatus, articleprivewlength, articleperpagecount, webdescription, webkeywords, authoremail, seotitle, themename, themeauthor, themewebsite, themeemail, themeversion, commentaduit, commentperpagecount, gravatarS, gravatarR, gravatarD, binarywhitelist From blog_global Where id=1",
			callback: function( cacheData ){
				return {
					title: cacheData[0][0],
					qq_appid: cacheData[0][1],
					qq_appkey: cacheData[0][2],
					website: cacheData[0][3],
					description: cacheData[0][4],
					theme: cacheData[0][5],
					style: cacheData[0][6],
					nickname: cacheData[0][7],
					webstatus: cacheData[0][8],
					articleprivewlength: cacheData[0][9],
					articleperpagecount: cacheData[0][10],
					webdescription: cacheData[0][11],
					webkeywords: cacheData[0][12],
					authoremail: cacheData[0][13],
					seotitle: cacheData[0][14],
					themename: cacheData[0][15],
					themeauthor: cacheData[0][16],
					themewebsite: cacheData[0][17],
					themeemail: cacheData[0][18],
					themeversion: cacheData[0][19],
					commentaduit: cacheData[0][20],
					commentperpagecount: cacheData[0][21],
					gravatarS: cacheData[0][22],
					gravatarR: cacheData[0][23],
					gravatarD: cacheData[0][24],
					binarywhitelist: cacheData[0][25]
				}
			}
		};
	}
	
	exports["category"] = function(){
		return "Select id, cate_name, cate_info, cate_root, cate_count, cate_icon, cate_outlink, cate_outlinktext From blog_category Where cate_show=False Order By cate_order ASC";
	}
	
	exports["article_pages"] = function(){
		return "Select id From blog_article Order By log_updatetime DESC";
	}
	
	exports["article_pages_cate"] = function(id){
		return "Select id From blog_article Where log_category=" + id;
	}
	
	exports["article"] = function( id ){
		return "Select log_title, log_category, log_content, log_tags, log_views, log_posttime, log_updatetime, log_shortcontent From blog_article Where id=" + id;
	}
	
	exports["tags"] = function(){
		return "Select id, tagname, tagcount From blog_tags";
	}
	
	exports["moden"] = function(id){
		return "Select modekey, modevalue From blog_moden Where modemark=" + id;
	}
	
	exports["plugin"] = function(){
		return "Select id, pluginname, pluginmark, pluginfolder, pluginstatus, plugininfo, pluginauthor, pluginemail, pluginwebsite, pluginqqweibo, pluginsinaweibo, pluginpublishdate, pluginversion, pluginwebpage From blog_plugin";
	}
	
	exports["artcomm"] = function(id){
		return "Select id, commentid, commentuserid, commentcontent, commentpostdate, commentpostip, commentaudit, commentusername, commentusermail From blog_comment Where commentlogid=" + id + " Order By commentpostdate DESC";
	}
	
	exports["user"] = function(id){
		return "Select sex, photo, nickName, isAdmin From blog_member Where id=" + id;
	}
	
	exports["attachments"] = function(){
		return "Select id, attachext, attachpath, attachsize From blog_attachments";
	}
});
%>