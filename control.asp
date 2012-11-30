<!--#include file="config.asp" --><%
	require("status");
	if ( (!config.user.login) || (config.user.isAdmin === false) ){
		Response.Redirect("default.asp");
	}
	
	var page = http.get("p");
	function checkStatusAndCustomPage(){
		if ( Session("admin") !== true ){
			return "login";
		}else if ( page.length === 0 ){
			return "index";
		}else{
			return page;
		}
	}
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>PJBlog4 管理后台</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="assets/css/reset.css" type="text/css" />
<link rel="stylesheet" href="assets/css/ui.css" type="text/css" />
<link rel="stylesheet" href="assets/css/fn.css" type="text/css" />
<link rel="stylesheet" href="assets/css/icon.css" type="text/css" />
<link rel="stylesheet" href="assets/css/page-<%=checkStatusAndCustomPage()%>.css" media="all" />
<script language="javascript" src="assets/js/core/sizzle.js"></script>
<script language="javascript" src="profile/handler/configure.js"></script>
</head>
<body>
	<div class="ui-header fn-clear">
		<div class="ui-user fn-right fn-clear">
			<%
				if ( Session("admin") === true ){ 
			%>
            <div class="icon-user fn-rightspace fn-left"><%=config.user.name%></div>
			<a href="#" class="fn-rightspace fn-left">修改密码</a>
			<a href="?p=writeArticle" class="fn-rightspace fn-left">写新日志</a>
			<a href="server/logout.asp" class="fn-left">退出</a>
            <%
				}else{
					console.log("请先登入");
				}
			%>
		</div>
		<div class="ui-guide">
			<a class="ui-logo fn-left fn-rightspace">PJBlog4</a>
			<ul class="fn-clear">
				<li><a href="default.asp" target="_blank">前台</a></li>
				<li><a href="control.asp">首页</a></li>
				<li><a href="?p=globalconfigure">设置</a></li>
				<li><a href="?p=documents">文档</a></li>
				<li><a href="http://webkits.cn" target="_blank">官方</a></li>
			</ul>
		</div>
	</div>
    
    <%
		if ( Session("admin") === true ){
	%>
    <div class="ui-body fn-clear">
		<div class="ui-nav">
			<div class="ui-nav-list">
				<ul>
					<li><a href="?p=category" class="ui-customspace <%=(page === "category"?"active":"")%>"><span>分类管理</span></a></li>
					<li><a href="?p=article" class="ui-customspace <%=(page === "article"?"active":"")%>"><span>日志管理</span></a></li>
					<li><a href="?p=comment" class="ui-customspace <%=(page === "comment"?"active":"")%>"><span>评论管理</span></a></li>
					<li><a href="?p=member" class="ui-customspace <%=(page === "member"?"active":"")%>"><span>用户管理</span></a></li>
					<li><a href="?p=theme" class="ui-customspace <%=(page === "theme"?"active":"")%>"><span>主题管理</span></a></li>
					<li><a href="?p=plugin" class="ui-customspace <%=(page === "plugin"?"active":"")%>"><span>插件管理</span></a></li>
				</ul>
			</div>
		</div>
		<div class="ui-content">
			<%
                try{
                    include("server/web/page-" + checkStatusAndCustomPage());
                }catch(e){
                    console.log("未找到模板。 [" + e.message + "]");
                }
            %>
    		</div>
		</div>
	</div>
   	<%
		}else{
			include("server/web/page-login");
		}
	%>
    <div class="ui-footer">
    	<div class="ui-wrapper">
        	<div class="ui-links">
            	<a href="http://webkits.cn" target="_blank">Evio</a> | 
                <a href="http://www.pjhome.net" target="_blank">PuterJam</a> | 
                <a href="http://bbs.pjhome.net" target="_blank">BBS</a> | 
                <a href="http://webkits.cn" target="_blank">Support</a>
            </div>
            <div class="ui-copyright">Copyright © 2004-2012 PJHOME LLC. All screenshots © their respective owners.<br />Evio in China, PuterJam in China.</div>
        </div>
    </div>
<script language="javascript">
require(['assets/js/config'], function( custom ){
	if ( custom.status === true ){
		custom.load('assets/js/page-<%=checkStatusAndCustomPage()%>');
	}else{
		if ( $.browser.msie ){
			alert("Getting Config File Error.");
		} else {
			console.log("Getting Config File Error.");
		}
	}
});
</script>
</body>
</html>
<%
	CloseConnect();
%>