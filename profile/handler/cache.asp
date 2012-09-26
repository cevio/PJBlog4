<%
define(function(require, exports, module){
	exports["global"] = function(){
		return "Select title, qq_appid, qq_appkey, website, description, theme, style From blog_global Where id=1";
	}
	
	exports["category"] = function(){
		return "Select id, cate_name, cate_info, cate_root, cate_count, cate_icon, cate_outlink, cate_outlinktext From blog_category Where cate_show=False Order By cate_order ASC";
	}
});
%>