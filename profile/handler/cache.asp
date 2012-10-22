<%
define(function(require, exports, module){
	exports["global"] = function(){
		return "Select title, qq_appid, qq_appkey, website, description, theme, style, nickname, webstatus, articleprivewlength, articleperpagecount, webdescription, webkeywords, authoremail,seotitle, themename, themeauthor, themewebsite, themeemail, themeversion, commentaduit From blog_global Where id=1";
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
		return "Select id, pluginname, pluginmark, pluginfolder, pluginstatus, plugininfo, pluginauthor, pluginemail, pluginwebsite, pluginqqweibo, pluginsinaweibo, pluginpublishdate, pluginversion From blog_plugin";
	}
	
	exports["artcomm"] = function(id){
		return "Select id, commentid, commentuserid, commentcontent, commentpostdate, commentpostip, commentaudit From blog_comment Where commentlogid=" + id + " Order By commentpostdate DESC";
	}
	
	exports["user"] = function(id){
		return "Select sex, photo, nickName, isAdmin From blog_member Where id=" + id;
	}
});
%>