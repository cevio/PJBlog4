<%include(pageCustomParams.global.themeFolder + "/header");%>
<%
	var date = require("DATE");
%>
<div class="pj-wrapper fn-clear pj-bodyer">
	<div class="pj-article-list fn-left">
    	<%
			(function(){
				var tplList = pageCustomParams.tags.lists,
					tplPagebar = pageCustomParams.tags.pages,
					i, j;
					
				for ( i = 0 ; i < tplList.length ; i++ ){
		%>
        <div class="pj-article-content">
        	<h1><a href="<%=tplList[i].url%>"><%=tplList[i].title%></a></h1>
            <div class="pj-article-infos">
            	<span class="date"><%=date.format(tplList[i].postDate, "M d y - h:i")%></span>
                <span class="tags"><%
				for ( j = 0 ; j < tplList[i].tags.length ; j++ ){
		%>
        			<a href="<%=tplList[i].tags[j].url%>"><%=tplList[i].tags[j].name%></a>
        <%
				}
		%></span>
            </div>
            <div class="pj-content"><%=tplList[i].content%></div>
        </div>	
        <%
				}
				
				if ( tplPagebar.length > 0 ){
		%>
        <div class="pj-article-pagebar fn-clear">
        <%
					for ( i = 0 ; i < tplPagebar.length ; i++ ){
						if ( tplPagebar[i].url === undefined ){
		%>
        	<span class="fn-left"><%=tplPagebar[i].key%></span>
        <%
						}else{
		%>
        	<a href="<%=tplPagebar[i].url%>" class="fn-left"><%=tplPagebar[i].key%></a>
        <%			
						}
					}
		%>
        </div>		
        <%
				}
			})();
		%>
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
    
    <%
		LoadPluginsCacheModule("hotarticle", function( HotArticle ){
			if ( HotArticle !== null ){
				var _data = HotArticle.data();
				if ( _data.length > 0 ){
	%>
    	<div class="pj-sidepannel">
        	<h3>最新日志</h3>
            <ul>
    <%
					for ( var i = 0 ; i < _data.length ; i++ ){
	%>
    			<li><a href="article.asp?id=<%=_data[i].id%>" target="_blank"><%=_data[i].log_title%></a></li>
    <%
					}
	%>
    		</ul>
        </div>
    <%			
				}
			}
		});
	%>
    </div>
</div>
<%include(pageCustomParams.global.themeFolder + "/footer")%>