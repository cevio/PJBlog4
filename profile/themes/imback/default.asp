<%include(pageCustomParams.global.themeFolder + "/header");%>
<%
	var date = require("DATE");
%>
<div class="pj-wrapper fn-clear pj-bodyer">
	<div class="pj-article-list fn-left">
    
<%
;(function(lists, pages){		
	for ( var i = 0 ; i < lists.length ; i++ ){
%>
<div class="pj-article-content">
    <h1><a href="<%=lists[i].url%>"><%=lists[i].title%></a></h1>
    <div class="pj-content"><%=lists[i].content%></div>
    <div class="pj-article-infos">
        <span class="more"><a href="<%=lists[i].url%>" title="详细阅读 <%=lists[i].title%>">阅读全文</a></span>
        <span class="date">发布：<%=(date.format(lists[i].postDate, "y-m-d"))%></span>
        <span class="date">分类：<a href="<%=lists[i].category.url%>"><%=lists[i].category.name%></a></span>
        <span class="date">阅读：<%=lists[i].views%>次</span>
        <span class="date">评论：<%=lists[i].comments%>条</span>
    </div>
</div>
<%
	}
	if ( pages.length > 0 ){
%>
		<div class="pj-article-pagebar fn-clear"><div class="pagebar">
<%

		for ( i = 0 ; i < pages.length ; i++ ){
			if ( pages[i].url === undefined ){
%>
			<a href="javascript:;"><span class="fn-left"><%=pages[i].key%></span></a>
<%
			}else{
%>
				<a href="<%=pages[i].url%>" class="fn-left"><span><%=pages[i].key%></span></a>
<%			
			}
		}
%>
		</div></div>		
<%
}
})(pageCustomParams.articles.lists, pageCustomParams.articles.pages);
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
                %>
    			<li><a href="control.asp">管理后台（需要权限）</a></li>
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
</div>
<script language="javascript">
	require("assets/js/config.js", function( route ){
		route.load("<%=pageCustomParams.global.themeFolder%>/js/default");
	});
</script>
<%include(pageCustomParams.global.themeFolder + "/footer")%>