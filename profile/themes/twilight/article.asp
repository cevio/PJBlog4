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
        
        <blockquote><p>评论区域</p></blockquote>
        <p>评论列表</p>
        <blockquote><p>发表评论</p></blockquote>
        <p>
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
        </p>
    </div>
    <script language="javascript">
    	require("assets/js/config.js", function( route ){
			route.load("<%=config.params.themeFolder%>/article");
		});
    </script>
<%include(config.params.themeFolder + "/footer")%>