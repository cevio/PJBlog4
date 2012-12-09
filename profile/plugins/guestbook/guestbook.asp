<%include(pageCustomParams.global.themeFolder + "/header");%>
<link rel="stylesheet" href="<%=pageCustomParams.global.website + "/" + pageCustomParams.global.styleFolder%>/guestbook.css" type="text/css" />
<div class="pj-wrapper fn-clear pj-bodyer">
	<div class="pj-article-list fn-left">
<%
var top="10",date="y-m-d h:i:s",aduit="1",series="2",seriesnum="5",seriestmp=null;
if (pageCustomParams.configData){
	top=pageCustomParams.configData.top;
	date=pageCustomParams.configData.date;
	aduit=pageCustomParams.configData.aduit;
	series=pageCustomParams.configData.series;series=series?Number(series):2;
	seriesnum=pageCustomParams.configData.seriesnum;seriesnum=seriesnum?Number(seriesnum):5;
}
var rnd_gblist=function(rid,i){
	i=i||0;
	seriestmp=i;
	rid=Number(rid);
	dbo.trave({
		conn: config.conn,
		sql: "Select top "+seriesnum+" * From blog_guestbook WHERE bookroot="+rid+(aduit=="1"?" and bookaduit=true":"")+"  order by id desc",
		callback: function(){
			this.each(function(){
%><blockquote id="b<%=this("id").value%>" class="b">
<span style="padding: 5px 3px; ght: 20px;"><%=this("bookusername").value%>(<%=this("bookpostip").value%>)&nbsp;&nbsp;&nbsp;&nbsp;<a id="a<%=this("id").value%>" href="javascript:void(0)"<%if (series==0||i<series){%> onclick='showrepBox(2,"repbox","<%=this("id").value%>")'<%}%>>盖楼</a></span>
<p><%=this("bookcontent").value%></p><%
if (series==0||i<series){//可以去除判断修改为无限级
	i=seriestmp+1;
	rnd_gblist(this("id").value,i);
}
%></blockquote><%
			});
		}
	});
};
var dbo = require("DBO"),
connecte = require("openDataBase");
if ( connecte === true ){
	rnd_gblist(0);
}else{
	console.log("error");
}
%>
	<a id="gb" href="javascript:void(0)" onclick='showrepBox(1,"repbox")'>点我留言</a>
	</div>
	<div class="pj-sidebar fn-right">
		<div class="pj-sidepannel">
			<h3>登入信息</h3>
			<ul>
    <%
	if ( config.user.login === true ){
	%>
    	<li><a href="server/logout.asp">您已登入  退出登入</a></li>
        <li><a href="control.asp">管理后台（需要权限）</a></li>
    <%
	}else{
		var oauth = require("server/oAuth/qq/oauth"),
			fns = require("fn");
			
	%>
    	<li><a href="<%=oauth.url("100299901", "http://lols.cc/server/oauth.asp?type=qq&dir=" + escape( fns.localSite() ))%>">登入</a></li>
    <%
	}
    %>
			</ul>
		</div>
	</div>
</div>
<div class="bg" id="bg"></div>
<div id="repbox" class="detail_repbox" style="">
<form action="<%=pageCustomParams.pluginFolder%>/ajax.asp" method="post" id="gb_list" onsubmit="">
	<input id="bookroot_id" name="id" type="hidden" value="0"/>
	<input name="j" type="hidden" value="post"/>
	<p class="tar"><a onclick="showrepBox(0,'repbox')" target="_self" href="javascript:void(0)"><img src="<%=pageCustomParams.global.website + "/" + pageCustomParams.global.styleFolder%>/detail_11.jpg"></a></p>
	<p class="person"></p>
<%if ( config.user.login !== true ){%>
	<p>&nbsp;昵称：<input id="cname" name="name" type="text"  value=""/></p>
<%}%>
	<p>&nbsp;网站地址：<input id="cwebsite" name="website" type="text" value=""/></p>
	<p>&nbsp;电子邮箱：<input id="cemail" name="email" type="text" value=""/></p>
	<p class="cont btnbox">您说：<br>
		<textarea id="ccontent" rows="" cols="" name="content"></textarea>
		<span class="replay" onclick="">
			<span style="float:right"><em></em><input type="submit" value="留言"/><em class="right"></em></span>
		</span>
	</p>
</form>
</div>
<script language="javascript">
	var pluginFolder="<%=pageCustomParams.pluginFolder%>";
	require("assets/js/config.js", function( route ){
		route.load("<%=pageCustomParams.global.themeFolder%>/js/guestbook");
	});
</script>
<%include(pageCustomParams.global.themeFolder + "/footer")%>