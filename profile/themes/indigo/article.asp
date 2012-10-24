<%include(config.params.themeFolder + "/header");%>
<% var articleCache = require("cache_article_detail"), date = require("DATE"); %>

<div class="main">
    <div class="content">
        <h1><%=articleCache.log_title%></h1>
        <div class="descr"> Date <%=date.format(articleCache.log_updatetime, "y-m-d h:i:s")%> Category <a href="default.asp?c=<%=articleCache.log_category%>" title="<%=articleCache.log_categoryInfo%>"><%=articleCache.log_categoryName%></a> Count <%=articleCache.log_views%> </div>
        <div class="contentarea"><%=articleCache.log_content%></div>
        <h1>评论区域</h1>
        <ul>
            <%
				var coms = require("cache_comment"),
					comsList = coms.commentList(articleCache.id);
					
				if ( comsList.length > 0 ){
					for ( var comsListItem = 0 ; comsListItem < comsList.length ; comsListItem++ ){
						var items = comsList[comsListItem].items;
			%>
            <li>谁： <%=comsList[comsListItem].user.name%> 头像： <img src="<%=comsList[comsListItem].user.photo%>/30" /> 内容:<%=comsList[comsListItem].content%>
                <%
							if ( items.length > 0 ){
			%>
                <ul>
                    <%
									for ( var ck = 0 ; ck < items.length ; ck++ ){
			%>
                    <li>谁： <%=items[ck].user.name%> 头像： <img src="<%=items[ck].user.photo%>/30" /> 内容：<%=items[ck].content%></li>
                    <%						
									}
			%>
                </ul>
                <%
							}
			%>
            </li>
            <%
					}
				}else{
					console.log("没有数据");
				}
			%>
        </ul>
        <h1>发表评论</h1>
        <form action="server/proxy/comment.asp?j=post" id="postcomment" method="post">
            <input type="hidden" name="logid" value="<%=articleCache.id%>" />
            <input type="hidden" name="commid" value="0" />
            <table width="100%" cellpadding="0" cellspacing="0" style="margin:0; padding:0;">
                <tr>
                    <td valign="top" width="50">内容</td>
                    <td><textarea name="content" style="width:100%; height:150px;"></textarea></td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="submit" value="提交" /></td>
                </tr>
            </table>
        </form>
    </div>
    <div class="sidenav">
        <h1>Login</h1>
        <p>
            <%
			if ( config.user.login === true ){
				console.log('您已登入 <a href="server/logout.asp">退出登入</a>');
			}else{
				var oauth = require("server/oAuth/qq/oauth"),
					fns = require("fn");
					
				console.log('<a href="' + oauth.url("100299901", "http://lols.cc/server/oauth.asp?type=qq&dir=" + escape( fns.localSite() )) + '">登入</a>');
			}
		%>
        </p>
        <h1>Search</h1>
        <form action="index.html">
            <div>
                <input type="text" name="search" class="styled" />
                <input type="submit" value="submit" class="button" />
            </div>
        </form>
        <%
			LoadPluginsCacheModule("hotarticle", function( HotArticle ){
				if ( HotArticle !== null ){
					var _data = HotArticle.data();
					if ( _data.length > 0 ){
		%>
        <h1>最新日志</h1>
        <ul>
            <%
						for ( var i = 0 ; i < _data.length ; i++ ){
		%>
            <li><a href="article.asp?id=<%=_data[i].id%>" target="_blank"><%=_data[i].log_title%></a></li>
            <%
						}
		%>
        </ul>
        <%
					}
				}
			});
		%>
    </div>
    <div class="clearer"><span></span></div>
</div>
<script language="javascript">
	require("assets/js/config.js", function( route ){
		route.load("<%=config.params.themeFolder%>/article");
	});
</script>
<%include(config.params.themeFolder + "/footer")%>
