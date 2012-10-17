<%include(config.params.themeFolder + "/header");%>

    <div id="content-wrap">
        <div id="sidebar">
            <h3>Download</h3>
            <p>
            <div class="download" onclick="window.location.href='assets/system/javascript/sizzle.js'">Sizzle v4.0</div>
            </p>
            <h3>Wise Words</h3>
            <div class="left-box">
                <p>&quot;Manage your code, make it more perfect.&quot; </p>
                <p class="align-right">- Evio Shen</p>
            </div>
            
            
            <%
				var A = assetsPluginCustom.loadPlugin("hotarticle");
				if ( A !== null ){
					if ( A.length > 0 ){
			%>
					<h3>最新日志</h3>
                    <ul class="sidemenu">
            <%
            		for ( var ai = 0 ; ai < A.length ; ai++ ){
			%>
            		<li><a href="article.asp?id=<%=A[ai].id%>" target="_blank"><%=A[ai].log_title%></a></li>
            <%
					}		
            %>
                    </ul>
            <%
					}
				}
			%>
            <h3>Link</h3>
            <ul class="sidemenu">
                <li><a href="http://bbs.pjhome.net" target="_blank">PJBlog BBS</a></li>
            </ul>
        </div>
        <div id="main">
<%
				var article = require("cache_article"),
					date = require("DATE");
				for ( var articles = 0 ; articles < article.length ; articles++ ){
%>
					<h2><a href="article.asp?id=<%=article[articles].id%>"><%=article[articles].log_title%></a></h2>
                	<p><%=article[articles].log_content%></p>
                    <div style="margin-left:30px;">Tags: 
                    	<%
							for ( var tagitems = 0 ; tagitems < article[articles].log_tags.length ; tagitems++ ){
						%>
                        		<a href="tags.asp?id=<%=article[articles].log_tags[tagitems].id%>"><%=article[articles].log_tags[tagitems].name%></a> 
                        <%
							}
						%> | Category: <a href="default.asp?c=<%=article[articles].log_category%>" title="<%=article[articles].log_categoryInfo%>"><%=article[articles].log_categoryName%></a>
                    </div>
                    <p class="post-footer align-right">					
                        <a href="index.html" class="readmore">Read more</a>
                        <a href="index.html" class="comments">Views (<%=article[articles].log_views%>)</a>
                        <span class="date"><%=date.format(article[articles].log_posttime, "y-m-d h:i:s")%> - <%=date.format(article[articles].log_updatetime, "y-m-d h:i:s")%></span>	
                    </p>
<%
				}
%>
        </div>

    </div>
<%include(config.params.themeFolder + "/footer")%>