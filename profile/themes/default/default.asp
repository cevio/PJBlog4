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
            <h3>Sizzle Plugins Demo</h3>
            <ul class="sidemenu">
                <li><a href="demo/sizzleload/" target="_blank">Sizzle Loader</a></li>
                <li><a href="demo/tipshow" target="_blank">Sizzle TipShow</a></li>
                <li><a href="demo/upload" target="_blank">Sizzle Upload</a></li>
                <li><a href="demo/flowlayer" target="_blank">Sizzle Flowlayer</a></li>
                <li><a href="demo/tabs/default.html" target="_blank">Sizzle Tabs</a></li>
            </ul>
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
						%>
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