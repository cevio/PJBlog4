<%include(config.params.themeFolder + "/header");%>
<div class="pj-wrapper fn-clear pj-bodyer">
	<div class="pj-article-list fn-left">
    	<%
			LoadCacheModule("cache_article", function( cache_article ){
				var date = require("DATE"),
					cache_article_pagebar = cache_article.page,
					cache_article_list = cache_article.list;
					
				for ( var i = 0 ; i < cache_article_list.length ; i++ ){
		%>
        <div class="pj-article-content">
        	<h1><a href="article.asp?id=<%=cache_article_list[i].id%>"><%=cache_article_list[i].log_title%></a></h1>
            <div class="pj-article-infos">
            	<span class="date"><%=date.format(cache_article_list[i].log_updatetime, "M d y - h:i")%></span>
                <span class="tags"><%
					for ( var j = 0 ; j < cache_article_list[i].log_tags.length ; j++ ){
				%>
                	<a href="tags.asp?id=<%=cache_article_list[i].log_tags[j].id%>"><%=cache_article_list[i].log_tags[j].name%></a> 
                <%	
					}
				%></span>
            </div>
            <div class="pj-content"><%=cache_article_list[i].log_content%></div>
        </div>
        <%		
				}
				if ( cache_article_list.length > 0 && (cache_article_pagebar.to - cache_article_pagebar.from > 0) ){
		%>
        <div class="pj-article-pagebar fn-clear">
        <%
					for ( var n = cache_article_pagebar.from ; n <= cache_article_pagebar.to ; n++ ){
						if ( cache_article_pagebar.current === n ){
		%>
        	<span class="fn-left"><%=n%></span>
        <%
						}else{
		%>
        	<a href="default.asp?c=<%=pageIndexCustomParams.cateID%>&page=<%=n%>" class="fn-left"><%=n%></a>
        <%				
						}
					}
		%>
        </div>
        <%
				}
			});
		%>
        
    </div>
    <div class="pj-sidebar fn-right">
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
<%include(config.params.themeFolder + "/footer")%>