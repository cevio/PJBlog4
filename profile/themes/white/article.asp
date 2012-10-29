<%include(config.params.themeFolder + "/header");%>
	<div class="pj-wrapper fn-clear pj-bodyer">
    	<% var articleCache = require("cache_article_detail"), date = require("DATE"); %>
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
					comsList = coms.commentList(articleCache.id);
				
				if ( comsList.length > 0 ){
			%>
            	<ul>
            <%
					for ( var comsListItem = 0 ; comsListItem < comsList.length ; comsListItem++ ){
						var items = comsList[comsListItem].items;
			%>
            		<li class="fn-clear">
                    	<div class="img fn-left"><img src="<%=comsList[comsListItem].user.photo%>/50" /></div>
                        <div class="comment-content fn-left">
                        	<div class="comment-who fn-clear"><span class="fn-left"><%=comsList[comsListItem].user.name%></span><span class="fn-right comment-who-time"><%=date.format(comsList[comsListItem].date, "M d y - h:i")%></span></div>
                            <div class="comment-des"><%=comsList[comsListItem].content%></div>
                            <div class="actiontools">操作：<a href="javascript:;" data-id="<%=comsList[comsListItem].user.id%>">回复</a></div>
                            <%
								if ( items.length > 0 ){
							%>
                            <div class="comment-items fn-clear">
                            <%
									for ( var ck = 0 ; ck < items.length ; ck++ ){
							%>
                            	<div class="cimg fn-left"><img src="<%=comsList[comsListItem].user.photo%>/30" /></div>
                                <div class="ccontent fn-left">
                                	<div class="cwho"><%=items[ck].user.name%></div>
                                    <div class="cinfo"><%=date.format(items[ck].user.date, "M d y - h:i")%></div>
									<div class="cdes"><%=items[ck].content%></div>
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
			%>
            </div>
        </div>
        
<!--        <blockquote><p>发表评论</p></blockquote>
        <p>
        	<form action="server/proxy/comment.asp?j=post" id="postcomment" method="post">
            <input type="hidden" name="logid" value="%=articleCache.id%" />
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
        </p>-->
    </div>
    <script language="javascript">
    	require("assets/js/config.js", function( route ){
			route.load("<%=config.params.themeFolder%>/article");
		});
    </script>
<%include(config.params.themeFolder + "/footer")%>
