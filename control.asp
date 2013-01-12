<!--#include file="config.asp" --><%
try{
	require("status")();
	var page = http.get("p");
	function checkStatusAndCustomPage(){
		if ( config.user.poster !== true ){
			return "login";
		}else{
			return page.length === 0 ? "index" : page;
		}
	}
	var __pages = checkStatusAndCustomPage();
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
<script language="javascript" src="<%=config.platform%>/proxy/update.js"></script>
<script language="javascript">
var userid = '<%=config.user.id%>',
	userhashkey = '<%=config.user.hashkey%>',
	useroauth = '<%=config.user.oauth%>',
	userphoto = '<%=config.user.photo%>';

config.version = "<%=config.version%>";
config.platform = "<%=config.platform%>";
config.limits = {};
config.limits.admin = <%=config.user.admin ? "true" : "false"%>;
</script>
</head>
<body>
	<div class="ui-header fn-clear">
		<div class="ui-user fn-right fn-clear">
            <div class="icon-user fn-rightspace fn-left"><%=config.user.name%></div>
			<%if ( config.user.admin === true ){%><a href="javascript:;" class="fn-rightspace fn-left modify-password">修改密码</a><%}%>
			<%if ( config.user.poster === true ){%>
				<a href="server/logout.asp" class="fn-left">注销</a>
			<%}%>
		</div>
		<div class="ui-guide">
			<a class="ui-logo fn-left fn-rightspace">PJBlog4</a>
			<ul class="fn-clear">
				<li><a href="default.asp" target="_blank">前台</a></li>
				<li><a href="?p=documents">文档</a></li>
				<li><a href="http://webkits.cn" target="_blank">官方</a></li>
			</ul>
		</div>
        <div class="ui-updateArea">
        	<div class="vers">升级版本：<span id="updateversionnumber"></span></div>
            <div class="vers">当前版本： v <%=config.version%></div>
            <div class="goupdate"><a href="javascript:;" id="hurryUpdate">马上升级？</a><a href="#" id="viewupdateinfo" target="_blank">详细</a><a href="javascript:;" id="updateclose">关闭</a></div>
        </div>
	</div>
    <%
		if ( config.user.poster === true ){
	%>
    <div class="ui-body fn-clear">
		<div class="ui-nav">
			<div class="ui-nav-list">
            	<ul>
					<li><a href="?p=index" class="ui-customspace <%=(__pages === "index"?"active":"")%>"><span>后台首页</span><i></i></a></li>
                </ul>
            	<ul>
					<li><a href="?p=system" class="ui-customspace <%=(__pages === "system"?"active":"")%>"><span>系统清理</span><i></i></a></li>
                    <li><a href="?p=globalconfigure" class="ui-customspace <%=(__pages === "globalconfigure"?"active":"")%>"><span>系统设置</span><i></i></a></li>
				</ul>
				<ul>
					<li><a href="?p=category" class="ui-customspace <%=(__pages === "category"?"active":"")%>"><span>分类管理</span><i></i></a></li>
                    <li><a href="?p=writeArticle" class="ui-customspace <%=(__pages === "writeArticle"?"active":"")%>"><span>新建日志</span><i></i></a></li>
					<li><a href="?p=article" class="ui-customspace <%=(__pages === "article"?"active":"")%>"><span>日志管理</span><i></i></a></li>
					<li><a href="?p=comment" class="ui-customspace <%=(__pages === "comment"?"active":"")%>"><span>评论管理</span><i></i></a></li>
					<li><a href="?p=member" class="ui-customspace <%=(__pages === "member"?"active":"")%>"><span>用户管理</span><i></i></a></li>
				</ul>
                <ul>
					<li><a href="?p=theme" class="ui-customspace <%=(__pages === "theme"?"active":"")%>"><span>主题管理</span><i></i></a></li>
					<li><a href="?p=plugin" class="ui-customspace <%=(__pages === "plugin"?"active":"")%>"><span>插件管理</span><i></i></a></li>
				</ul>
			</div>
		</div>
		<div class="ui-content">
			<%
                try{
					if ( config.user.admin || ( config.user.poster && (__pages === "article" || __pages === "writeArticle") ) ){
                    	include("server/web/page-" + __pages);
					}else{
						console.log("您无权进入该模块");
					}
                }catch(e){
                    console.log("语法错误或者未找到模板。 [" + e.message + "]");
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
    	<div class="ui-wrapper fn-clear">
            <div class="ui-copyright fn-left">PJBlog v<%=config.version%> Copyright @ 2004-2012 PJHome.Net. All Rights Reserved.<br />Code Design By <a href="http://webkits.cn" target="_blank">Evio</a>, Blog CopyRight For <a href="http://www.pjhome.net" target="_blank">PuterJam</a>. Run Time <%=config.timers()%></div>
           <div class="ui-links fn-right">
            	<a href="http://webkits.cn" target="_blank">Evio</a> - 
                <a href="http://www.pjhome.net" target="_blank">PuterJam</a> - 
                <a href="http://bbs.pjhome.net" target="_blank">BBS</a> - 
                <a href="http://webkits.cn" target="_blank">Support</a>
            </div>
        </div>
    </div>
<%
	if ( config.user.admin || ( config.user.poster && (__pages === "article" || __pages === "writeArticle") ) || (__pages === "login") ){
%>
<script language="javascript">
require(['assets/js/config'], function( custom ){
	if ( custom.status === true ){
		custom.load(['assets/js/page-<%=checkStatusAndCustomPage()%>', 'tips', 'update']);
	}else{
		if ( $.browser.msie ){
			alert("Getting Config File Error.");
		} else {
			console.log("Getting Config File Error.");
		}
	}
});
</script>
<%
	}
%>
</body>
</html>
<%
	CloseConnect();
}catch(e){
	ConsoleClose(e.message);
}
%>