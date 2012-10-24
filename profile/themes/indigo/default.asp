<%include(config.params.themeFolder + "/header");%>

<div class="main">
    <div class="content">
        <%
			LoadCacheModule("cache_article", function( cache_article ){
				var date = require("DATE");
				for ( var i = 0 ; i < cache_article.length ; i++ ){
		%>
        <h1><a href="article.asp?id=<%=cache_article[i].id%>"><%=cache_article[i].log_title%></a></h1>
        <div class="descr">Date <%=date.format(cache_article[i].log_updatetime, "y-m-d h:i:s")%> Category <a href="default.asp?c=<%=cache_article[i].log_category%>" title="<%=cache_article[i].log_categoryInfo%>"><%=cache_article[i].log_categoryName%></a> Count <%=cache_article[i].log_views%></div>
        <div class="contentarea"><%=cache_article[i].log_content%></div>
        <%	
				}
			});
		%>
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
<%include(config.params.themeFolder + "/footer")%>
