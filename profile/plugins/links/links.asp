<%include(pageCustomParams.global.themeFolder + "/header");%>
<link rel="stylesheet" href="<%=pageCustomParams.global.website + "/" + pageCustomParams.global.styleFolder%>/links.css" type="text/css" />
<%
var top="10",per="20",aduit=false;
if (pageCustomParams.configData){
	top=pageCustomParams.configData.top;pernum=pageCustomParams.configData.per;
	top?Number(top):10;pernum?Number(pernum):20;aduit=pageCustomParams.configData.aduit==1||false;
}
pageCustomParams.page = Number(http.get("page"));
if (!pageCustomParams.page||pageCustomParams.page==0||pageCustomParams.page<1)
{
	pageCustomParams.page=1;
}
var a = require("profile/handler/cache");
a.link = function(page){return "select top "+pernum+" * from blog_link where id not in(select top "+(pageCustomParams.page-1)*pernum+" id from blog_link order by id desc) order by id desc"};
a.linknum = function(page){return "select count(id) from blog_link"};
var cache = require("cache");
var linkcache = cache.load("link",pageCustomParams.page);
var linknumcache = cache.load("linknum");
%>
<div class="pj-wrapper fn-clear pj-bodyer">
	<div class="pj-article-list fn-left">
        <div class="links">
        	<div class="link-title fn-clear">
            	<div class="fn-left"><h3>友情链接</h3></div>
                <div class="fn-right"><a href="javascript:;" id="postnewlink">+ 申请友情链接</a></div>
            </div>
            <div class="link-list">

<table border="0" cellpadding="1" cellspacing="1" width="100%">         
<tbody><tr>
<%
if (linkcache==null||linkcache.length==0){
%>
<td height="31" width="100%">
<table>
<tbody><tr>博主还没有添加任何友情链接，快来提交吧</tr>
</tbody></table>
</td>
<%
}
else{

	for (var k=0;k<linkcache.length;k++)
	{
	//id linkname linkinfo linkurl linkmage linkroot linkaduit
%>
	<td height="31" width="33.3333333333333%">
		<table>
        	<tbody><tr>
            	<td style="display:block" align="center" height="31" width="88"><a href="<%=linkcache[k][3]%>" target="_blank"><img src='<%if (!!linkcache[k][4]){%><%=linkcache[k][4]%><%}else{%><%=pageCustomParams.global.website + "/" + pageCustomParams.global.styleFolder%>/linkxlogo.jpg<%}%>' style="width:88px;height:31px; display:block" onerror="" border="0"></a></td>
                <td style=" padding-left:3px;" height="31" valign="top"><div style="overflow:hidden"><%=linkcache[k][1]%><br><a href='<%=linkcache[k][3]%>' title='<%=linkcache[k][2]%>' target="_blank"><%=linkcache[k][3]%></a></div></td>
            </tr>
        </tbody></table>
     </td>	
<%
	}
}
%>
</tr></tbody></table>
            </div>
<%	if ( linknumcache > 1 ){
		console.log('<div class="pagebar fn-clear"><span class="fn-left join"></span>');
		var fns = require.async("fn"),
		pages = fns.pageAnalyze(pageCustomParams.page, Math.ceil(linknumcache / pernum));
		fns.pageOut(pages, function(i, isCurrent){
			if ( isCurrent === true ){
				console.log('<span class="fn-left">' + i + '</span>');
			}else{
				console.log('<a href="plugin.asp?mark='+mark+'&page='+i+'" class="fn-left pages">' + i + '</a>');
			}
		});
		console.log('</div>');
	}
%>
	</div>
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
    	<li><a href='<%=oauth.url("100299901", "http://lols.cc/server/oauth.asp?type=qq&dir=" + escape( fns.localSite() ))%>'>登入</a></li>
    <%
	}
    %>
			</ul>
		</div>
	</div>
</div>
<script language="javascript">
	var pluginFolder="<%=pageCustomParams.pluginFolder%>",aduit=<%=aduit?"true":"false"%>;
	require("assets/js/config.js", function( route ){
		route.load("<%=pageCustomParams.global.themeFolder%>/js/links");
	});
</script>
<%include(pageCustomParams.global.themeFolder + "/footer")%>