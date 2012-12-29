<%include(pageCustomParams.global.themeFolder + "/header2");%>
<% 
	var date = require("DATE");
	function checkURL(url){
		if ( url.substr(0,7).toLowerCase() === "http://" ){
			return url;
		}else{
			return "http://" + url;
		}
	}
%>
<script language="javascript">
var postid = <%=pageCustomParams.article.id%>;
</script>
	<div class="pj-wrapper fn-clear pj-bodyer">
        <div class="pj-article-content">
<%
;(function(params){
%>
			<h1><%=params.title%></a></h1>
            <div class="pj-article-infos">
            	<span class="date">作者：<%=params.user.name%></span>
                <span class="date">发布：<%=date.format(params.postDate, "y-m-d")%></span>
            	<span class="category">分类：<a href="<%=params.category.url%>" title="<%=params.category.info%>"><%=params.category.name%></a></span>
            	<span class="date">阅读：<%=params.views%>次</span>
            	<span class="date">评论：<%=params.comments%>条</span>
            </div>
            <div class="pj-content"><%=params.content%></div>
            <div class="information">除非注明，本站文章均为原创，转载请注明出处！
                <%
					if ( params.tags.length > 0 ){
				%>
                <span class="tags">标签：
                <%
						for ( var tagitems = 0 ; tagitems < params.tags.length ; tagitems++ ){
				%>
                	<a href="<%=params.tags[tagitems].url%>"><%=params.tags[tagitems].name%></a>
                <%			
						}
				%>
                </span>
                <%	
					}
				%>
            </div>
            <div class="pj-content-nav">
            	<%if ( params.other.prev ){%>
                	<a class="l" href="<%=params.other.prev.url%>">上一篇：<%=params.other.prev.title%></a>
                <%}%>
                <%if ( params.other.next ){%>
                	<a class="r" href="<%=params.other.next.url%>">下一篇：<%=params.other.next.title%></a>
                <%}%>
            </div>
<%
})(pageCustomParams.article);
%>
        </div>

    <div class="pj-sidebar fn-right">
    	<div class="pj-sidepannel">
        	<h3>用户信息</h3>
            <ul class="fn-clear">
    <%
	if ( config.user.login === true ){
	%>
    	<li><a href="server/logout.asp">注销登录</a></li>
    <%
	}else{
		LoadPluginsCacheModule("qqoauth", function(qq){
			console.log('<li><a href="' + qq.url() + '">腾讯账号登入</a></li>');
		});
	}
    %><li><a href="control.asp">管理后台（需要权限）</a></li>
    		</ul>
    	</div>
        
    	<%
			LoadPluginsCacheModule("newarticles", function(articles){
				if ( articles ){
					var datas = articles.datas();
					if ( datas.length > 0 ){
		%>
        <div class="pj-sidepannel">
        	<h3>最新日志</h3>
            <ul class="fn-clear">
        <%
						for ( var i = 0 ; i < datas.length; i++ ){
		%>
            	<li><a href="<%=datas[i].url%>"><%=datas[i].title%></a></li>
        <%
						}
		%>
            </ul>
        </div>
        <%
					}
				}
			});
			LoadPluginsCacheModule("newcomments", function(comments){
				if ( comments ){
					var datas = comments.datas();
					if ( datas.length > 0 ){
		%>
        <div class="pj-sidepannel">
        	<h3>最新评论</h3>
            <ul class="fn-clear">
        <%
						for ( var i = 0 ; i < datas.length; i++ ){
		%>
            	<li><a href="<%=datas[i].url%>"><%=datas[i].content%></a></li>
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
    	<div class="pj-sidepannel">
        	<h3>网站统计</h3>
            <ul class="fn-clear">
    	   <li style="width:50%;">文章总数：<%=pageCustomParams.global.totalarticles%>篇</li>
    	    <li style="width:50%;">评论总数：<%=pageCustomParams.global.totalcomments%>条</li>
            <li style="width:50%;">留言条数：85条</li>
    	    <li style="width:50%;">浏览总数：3248次</li>
    	    </ul>
        </div>
    	<div class="pj-sidepannel">
        	<h3>友情链接</h3>
            <ul>
        <li style="width:50%;"><a href="http://www.lsnote.com" target="_blank" title="生活博客">林肆随笔</a></li>
    	<li style="width:50%;"><a href="http://www.maosay.com" target="_blank" title="技术博客">猫言猫语</a></li>
        <li style="width:50%;"><a href="http://www.pjhome.net" target="_blank" title="PJblog程序创建者">舜子博客</a></li>
    	<li style="width:50%;"><a href="http://bbs.pjhome.net" target="_blank" title="访问PJblog论坛">官方论坛</a></li>
        <div class="fn-clear"></div>
    	    </ul>
    	</div>
    </div>

        <div class="relate">
            <h3>相关日志</h3>
            <ul class="fn-clear">
            <li><a >全新的PJblog4给你全新的感受</a></li>
            <li><a >相关日志这里需要插件才能使用</a></li>
            <li><a >童鞋们看到的这块区域是静态展示</a></li>
            <li><a >更多的精彩内容，请关注官方网站</a></li>
            </ul>
        </div>        
        <div class="comments">
        	<div class="comment-title fn-clear">
            	<div class="fn-left"><h3>评论列表</h3></div>
                <div class="fn-right"><a href="javascript:;" id="postnewcomment">+ 发表评论</a></div>
            </div>
            <div class="comment-list">
<%
;(function(lists, pages){
	if ( lists.length > 0 ){
%>
	<ul>
<%
	for ( var i = 0 ; i < lists.length ; i++ ){
		var items = lists[i].childrens,
			website = lists[i].website;
			
		if ( !website || website.length === 0 ){
			website = "javascript:;";
		}else{
			website = checkURL(website);
		}
%>
	<li class="fn-clear" id="comment_<%=lists[i].id%>">
        <div class="img fn-left"><img src="<%=lists[i].user.photo%>" /></div>
        <div class="comment-content fn-left">
            <div class="comment-who fn-clear">
            	<span class="fn-left"><a href="<%=website%>"><%=lists[i].user.name%></a></span>
                <span class="fn-right comment-who-time"><%=date.format(lists[i].date, "y-m-d h:i")%></span>
            </div>
            <div class="comment-des"><%=lists[i].content%></div>
            <div class="actiontools"><a href="javascript:;" data-id="<%=lists[i].id%>" class="postreply">回复该留言</a></div>
            <%
                if ( items.length > 0 ){
            %>
                    <div class="comment-items">
                    <%
                            for ( var j = 0 ; j < items.length ; j++ ){
								var _website = items[j].website;
								if ( !_website || _website.length === 0 ){
									_website = "javascript:;";
								}else{
									_website = checkURL(_website);
								}
                    %>
                        <div class="fn-clear cline" id="comment_<%=items[j].id%>">
                            <div class="cimg fn-left"><img src="<%=items[j].user.photo%>" /></div>
                            <div class="ccontent fn-left">
                                <div class="cwho"><a href="<%=_website%>"><%=items[j].user.name%></a></div>
                                <div class="cinfo"><%=date.format(items[j].date, "y-m-d h:i")%></div>
                                <div class="cdes"><%=items[j].content%></div>
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
	<div class="pj-article-pagebar fn-clear"><div class="pagebar">
	<%
                for ( var n = 0 ; n < pages.length ; n++ ){
                    if ( pages[n].url === undefined ){
    %>
       <a href="javascript:;"><span class="fn-left"><%=pages[n].key%></span></a>
    <%
                    }else{
    %>
        <a href="<%=pages[n].url%>" class="fn-left"><span><%=pages[n].key%></span></a>
    <%				
                    }
                }
    %>
        </div></div>
    <%
	}
})(pageCustomParams.comments.lists, pageCustomParams.comments.pages);
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
