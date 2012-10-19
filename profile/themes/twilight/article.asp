<%include(config.params.themeFolder + "/header");%>
	<div class="holder">
    	<% var articleCache = require("cache_article_detail"), date = require("DATE"); %>
    	<blockquote><p><%=articleCache.log_title%></p></blockquote>
        <p><%=articleCache.log_content%></p>
        <h3>Information:</h3>
        <ul>
            <li>Tags: <%
                    for ( var tagitems = 0 ; tagitems < articleCache.log_tags.length ; tagitems++ ){
                %>
                        <a href="tags.asp?id=<%=articleCache.log_tags[tagitems].id%>"><%=articleCache.log_tags[tagitems].name%></a> 
                <%
                    }
                %></li>
            <li>Category: <a href="default.asp?c=<%=articleCache.log_category%>" title="<%=articleCache.log_categoryInfo%>"><%=articleCache.log_categoryName%></a></li>
            <li>View Counts: <%=articleCache.log_views%></li>
            <li>Date: <%=date.format(articleCache.log_updatetime, "y-m-d h:i:s")%></li>
        </ul>
    </div>
<%include(config.params.themeFolder + "/footer")%>