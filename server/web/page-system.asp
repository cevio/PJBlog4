<%
	var t = http.get("t");
	if ( t.length === 0 ){
		t = "com";
	}
%>
<div class="ui-position fn-clear">
  <div class="fn-left ui-position-title">插件管理</div>
  <div class="fn-right ui-position-tools">
  	<a href="?p=system" class="<%=( t == "com" ? "active" : "" )%>">组件支持</a> 
    <a href="?p=system&t=cache" class="<%=( t == "cache" ? "active" : "" )%>">缓存清理</a> 
    <a href="?p=system&t=factory" class="<%=( t == "factory" ? "active" : "" )%>">数据库管理</a>
  </div>
</div>
<div class="ui-context <%=t%>">
	<%
		if ( t === "cache" ){
	%>
    	<ul>
        	<li><input type="checkbox" value="global" /> 全局变量缓存清理<span></span></li>
            <li><input type="checkbox" value="user" /> 清理所有用户登入缓存<span></span></li>
            <li><input type="checkbox" value="article_pages" /> 清理首页日志索引<span></span></li>
            <li><input type="checkbox" value="article_pages_cate" /> 清理首页日志分类索引<span></span></li>
            <li><input type="checkbox" value="articles" /> 清理所有日志缓存（同时清理该日志下的评论缓存）<span></span></li>
            <li><input type="checkbox" value="category" /> 清理所有分类列表缓存<span></span></li>
            <li><input type="checkbox" value="plugins" /> 清理插件列表缓存（同时清理插件下的信息缓存）<span></span></li>
            <li><input type="checkbox" value="tags" /> 清理所有TAG缓存<span></span></li>
            <li><input type="checkbox" value="attments" /> 清理所有附件缓存<span></span></li>
        </ul>
        <div class="start"><button class="button" id="checkall">全选</button> <button class="button" id="clear">开始清理</button></div>
    <%
		}else if ( t === "factory" ){
			
		}else{
			//' 组件支持
			(function(){
	%>
    	<div class="fn-clear">
    <%
				for ( var com in config.nameSpace ){
					var status = "";
					 try{
                        new ActiveXObject(config.nameSpace[com]);
                        status = "green";
                    }catch(e){
                        status = "red";
                    }
	%>
    		<div class="comlist ui-wrapshadow fn-textoverhide fn-left <%=status%>"><%=config.nameSpace[com].toUpperCase()%></div>
    <%
				}
	%>
    	</div>
        <div class="fn-clear" style="margin-top:10px;">
        	<div class="fn-left intro green"></div><div class="fn-left words">支持</div>
            <div class="fn-left intro red"></div><div class="fn-left words">不支持</div>
        </div>
    <%
			})();
		}
	%>
</div>