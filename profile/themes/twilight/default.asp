<%include(config.params.themeFolder + "/header");%>

    <div class="holder">
		<%
			var cache_article = require("cache_article"),
				date = require("DATE");
			
			for ( var cache_article_item = 0 ; cache_article_item < cache_article.length ; cache_article_item++ ){
		%>
        		<blockquote><p><a href="article.asp?id=<%=cache_article[cache_article_item].id%>"><%=cache_article[cache_article_item].log_title%></a></p></blockquote>
                <p><%=cache_article[cache_article_item].log_content%></p>
                <h3>Information:</h3>
                <ul>
                    <li>Tags: <%for ( var tagitems = 0 ; tagitems < cache_article[cache_article_item].log_tags.length ; tagitems++ ){%><a href="tags.asp?id=<%=cache_article[cache_article_item].log_tags[tagitems].id%>"><%=cache_article[cache_article_item].log_tags[tagitems].name%></a> <%}%></li>
                    <li>Category: <a href="default.asp?c=<%=cache_article[cache_article_item].log_category%>" title="<%=cache_article[cache_article_item].log_categoryInfo%>"><%=cache_article[cache_article_item].log_categoryName%></a></li>
                    <li>View Counts: <%=cache_article[cache_article_item].log_views%></li>
                    <li>Date: <%=date.format(cache_article[cache_article_item].log_updatetime, "y-m-d h:i:s")%></li>
                </ul>
        <%
			}
		%>
	</div>
<%include(config.params.themeFolder + "/footer")%>