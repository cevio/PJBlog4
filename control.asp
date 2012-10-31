<!--#include file="config.asp" --><%
	require("status");
	if ( !config.user.login ){
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="assets/css/control.css" media="all" />
<link rel="stylesheet" href="assets/css/page-<%=checkStatusAndCustomPage()%>.css" media="all" />
<script language="javascript" src="assets/js/core/sizzle.js"></script>
<title>PJBlog4 管理后台</title>
</head>
<body>
<div id="navtion" class="tpl-navtion fn-black-opacity">
	<div class="tpl-wrapper fn-clear">
    	<div class="logo"></div>
        <div class="nav-list">
        	<ul>
            	<li><a href="control.asp">首页</a></li>
                <li><a href="?p=category">分类</a></li>
                <li><a href="?p=article">日志</a></li>
                <li><a href="?p=theme">主题</a></li>
                <li><a href="?p=plugin">插件</a></li>
                <li><a href="?p=documents">文档</a></li>
            </ul>
        </div>
        <div class="nav-user">
        	<%if ( Session("admin") !== true ){ %><a href="default.asp">前台</a><%}%>
        	<%if ( Session("admin") === true ){ %><span class="name">sevio</span><%}%>
            <%if ( Session("admin") === true ){ %><a href="javascript:;" class="item">设置<ul><li class="sdk-globalconfigure"><span class="iconfont">&#355;</span> 全局设置</li><li><span class="iconfont">&#226;</span> 修改密码</li></ul></a><%}%>
            <%if ( Session("admin") === true ){ %><a href="?p=writeArticle">写日志</a><%}%>
            <a href="javascript:;">官方</a>
            <%if ( Session("admin") === true ){ %><a href="server/logout.asp">退出</a><%}%>
        </div>
    </div>   
</div>
<div id="slogen" class="tpl-wrapper">
	<div class="Alogo">创新技术、创新架构、创新分享<div class="Blogo">不能承受的重博客之轻！</div></div>
    <div class="update">发现新版本 请点击升级</div>
</div>
<div id="content" class="tpl-wrapper">
	<%
		try{
			include("server/web/page-" + checkStatusAndCustomPage());
		}catch(e){
			console.log("未找到模板。 [" + e.message + "]");
		}
	%>
</div>

<div id="footer" class="tpl-wrapper">
	<div class="foot-zone fn-clear">
    	<div class="fn-left">&copy; 2012 <a href="http://pjhome.net" target="_blank">PJHome.net</a>. Valid <a href="http://jigsaw.w3.org/css-validator/check/referer" target="_blank">CSS</a> &amp; <a href="http://validator.w3.org/check?uri=referer" target="_blank">XHTML</a> Timer <%=config.timers()%></div>
        <div class="fn-right">code by <a href="http://sizzle.cc" target="_blank">evio</a> . design by <a href="http://sizzle.cc" target="_blank">evio</a></div>
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