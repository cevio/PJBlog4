<%include(config.params.themeFolder + "/header");%>
<% var date = require("DATE"); %>
<script language="javascript">
var postid = <%=articleCache.id%>;
</script>
	<div class="pj-wrapper fn-clear pj-bodyer">
        <div class="pj-article-content">
        	<h1><%=articleCache.log_title%></a></h1>
            <div class="pj-article-infos">
            	<span class="date"><%=date.format(articleCache.log_updatetime, "M d y - h:i")%></span>
            </div>
            <div class="pj-content"><%=articleCache.log_content%></div>
            <div class="information">
            	<div class="category">Category: <a href="default.asp?c=<%=articleCache.log_category%>" title="<%=articleCache.log_categoryInfo%>"><%=articleCache.log_categoryName%></a></div>
                <%
					if ( articleCache.log_tags.length > 0 ){
				%>
                <div class="tags">Tags: 
                <%
						for ( var tagitems = 0 ; tagitems < articleCache.log_tags.length ; tagitems++ ){
				%>
                	<a href="tags.asp?id=<%=articleCache.log_tags[tagitems].id%>"><%=articleCache.log_tags[tagitems].name%></a>
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
				var coms = require("cache_comment"),
					comsList = coms.commentList(articleCache.id),
					pages = comsList.page,
					comsList = comsList.list;
				
				if ( comsList.length > 0 ){
			%>
            	<ul>
            <%
					for ( var comsListItem = 0 ; comsListItem < comsList.length ; comsListItem++ ){
						var items = comsList[comsListItem].items;
			%>
            		<li class="fn-clear">
                    	<div class="img fn-left">
                        <%
							if ( comsList[comsListItem].user.id === 0 ){
						%>
                        	<img src="<%=comsList[comsListItem].user.photo%>" />
                        <%	
							}else{
						%>
                        	<img src="<%=comsList[comsListItem].user.photo%>/50" />
                        <%	
							}
						%>
                        </div>
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
                                    <div class="cimg fn-left">
                                    <%
										if ( items[ck].user.id === 0 ){
									%>
                                    	<img src="<%=items[ck].user.photo%>" />
                                    <%	
										}else{
									%>
                                    	<img src="<%=items[ck].user.photo%>/30" />
                                    <%	
										}
									%>
                                    </div>
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
				if ( comsList.length > 0 && (pages.to - pages.from > 0) ){
			%>
            
            <div class="pj-article-pagebar fn-clear">
			<%
                        for ( var n = pages.from ; n <= pages.to ; n++ ){
                            if ( pages.current === n ){
            %>
                <span class="fn-left"><%=n%></span>
            <%
                            }else{
            %>
                <a href="article.asp?id=<%=articleCache.id%>&page=<%=n%>" class="fn-left"><%=n%></a>
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
			route.load("<%=config.params.themeFolder%>/js/article");
		});
    </script>
<%include(config.params.themeFolder + "/footer")%>
