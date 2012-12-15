<%include(pageCustomParams.global.themeFolder + "/header");%>
<% 
	var date = require("DATE");
%>
<script language="javascript">
var postid = <%=pageCustomParams.article.id%>;
</script>
	<div class="pj-wrapper fn-clear pj-bodyer">
        <div class="pj-article-content">
        	<h1><%=pageCustomParams.article.title%></a></h1>
            <div class="pj-article-infos">
            	<span class="date"><%=date.format(pageCustomParams.article.postDate, "M d y - h:i")%></span>
            </div>
            <div class="pj-content"><%=pageCustomParams.article.content%></div>
            <div class="information">
            	<div class="category">Category: <a href="<%=pageCustomParams.article.category.url%>" title="<%=pageCustomParams.article.category.info%>"><%=pageCustomParams.article.category.name%></a></div>
                <%
					if ( pageCustomParams.article.tags.length > 0 ){
				%>
                <div class="tags">Tags: 
                <%
						for ( var tagitems = 0 ; tagitems < pageCustomParams.article.tags.length ; tagitems++ ){
				%>
                	<a href="<%=pageCustomParams.article.tags[tagitems].url%>"><%=pageCustomParams.article.tags[tagitems].name%></a>
                <%			
						}
				%>
                </div>
                <%	
					}
				%>
            </div>
        </div>
        
        <div class="comments">
        	<div class="comment-title fn-clear">
            	<div class="fn-left"><h3>评论</h3></div>
                <div class="fn-right"><a href="javascript:;" id="postnewcomment">+ 发表评论</a></div>
            </div>
            <div class="comment-list">
            <%
				var comsList = pageCustomParams.comments.lists,
					pages = pageCustomParams.comments.pages;
				
				if ( comsList.length > 0 ){
			%>
            	<ul>
            <%
					for ( var comsListItem = 0 ; comsListItem < comsList.length ; comsListItem++ ){
						var items = comsList[comsListItem].childrens;
			%>
            		<li class="fn-clear">
                    	<div class="img fn-left"><img src="<%=comsList[comsListItem].user.photo%>" /></div>
                        <div class="comment-content fn-left">
                        	<div class="comment-who fn-clear"><span class="fn-left"><%=comsList[comsListItem].user.name%></span><span class="fn-right comment-who-time"><%=date.format(comsList[comsListItem].date, "M d y - h:i")%></span></div>
                            <div class="comment-des"><%=comsList[comsListItem].content%></div>
                            <div class="actiontools">操作：<a href="javascript:;" data-id="<%=comsList[comsListItem].id%>" class="postreply">回复</a></div>
                            <%
								if ( items.length > 0 ){
							%>
                            <div class="comment-items">
                            <%
									for ( var ck = 0 ; ck < items.length ; ck++ ){
							%>
                            	<div class="fn-clear cline">
                                    <div class="cimg fn-left"><img src="<%=items[ck].user.photo%>" /></div>
                                    <div class="ccontent fn-left">
                                        <div class="cwho"><%=items[ck].user.name%></div>
                                        <div class="cinfo"><%=date.format(items[ck].date, "M d y - h:i")%></div>
                                        <div class="cdes"><%=items[ck].content%></div>
                                    </div>
                                </div>
                            <%			
									}
							%>
                            </div>
                            <%
								}
							%>
                        </div>
                    </li>
            <%			
					}
			%>
                </ul>
            <%	
				}
				if ( pages.length > 0 ){
			%>
            
            <div class="pj-article-pagebar fn-clear">
			<%
                        for ( var n = 0 ; n < pages.length ; n++ ){
                            if ( pages[n].url === undefined ){
            %>
                <span class="fn-left"><%=pages[n].key%></span>
            <%
                            }else{
            %>
                <a href="<%=pages[n].url%>" class="fn-left"><%=pages[n].key%></a>
            <%				
                            }
                        }
            %>
            </div>
            <%
				}
			%>
            </div>
        </div>
    </div>
    <script language="javascript">
    	require("assets/js/config.js", function( route ){
			route.load("<%=pageCustomParams.global.themeFolder%>/js/article");
		});
    </script>
<%include(pageCustomParams.global.themeFolder + "/footer")%>
