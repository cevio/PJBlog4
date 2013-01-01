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
        <span class="date">作者：<%=lists[i].uid.name%></span>
        <span class="date">发布：<%=date.format(lists[i].postDate, "M d y")%></span>
        <span class="date">阅读：<%=lists[i].views%>次</span>
        <span class="tags">标签：<%
        for ( j = 0 ; j < lists[i].tags.length ; j++ ){
%>
            <a href="<%=lists[i].tags[j].url%>"><%=lists[i].tags[j].name%></a>
<%
        }
%></span>
    </div>
</div>
<%
	}
	if ( pages.length > 0 ){
%>
		<div class="pj-article-pagebar fn-clear">
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
		</div>		
<%
}
})(pageCustomParams.tags.lists, pageCustomParams.tags.pages);
%>
    </div>
    <div class="pj-sidebar fn-right">
    	<div class="pj-sidepannel">
        	<h3>登入信息</h3>
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
		LoadPluginsCacheModule("hotarticle", function( HotArticle ){
			if ( HotArticle !== null ){
				var _data = HotArticle.data();
				if ( _data.length > 0 ){
	%>
    	<div class="pj-sidepannel">
        	<h3>最新日志</h3>
            <ul>
    <%
					for ( var i = 0 ; i < _data.length ; i++ ){
	%>
    			<li><a href="article.asp?id=<%=_data[i].id%>" target="_blank"><%=_data[i].log_title%></a></li>
    <%
					}
	%>
    		</ul>
        </div>
    <%			
				}
			}
		});
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
    </div>
</div>
<%include(pageCustomParams.global.themeFolder + "/footer")%>