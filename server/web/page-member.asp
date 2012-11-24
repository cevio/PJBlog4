<%
var dbo = require("DBO"),
	connecte = require("openDataBase"),
	_page = http.get("page"),
	pageInfo = [];
	
	if ( _page.length === 0 ){
		_page = 1;
	}else{
		_page = Number(_page);
	}
	
	if ( _page < 1 ){
		_page === 1;
	}
	
	if ( connecte === true ){
%>
<div class="tpl-space fn-clear">
    <div class="article-zone">
        <h3><span class="iconfont">&#367;</span> 用户列表</h3>
        
        <div class="mem-list">
        	<ul class="fn-clear">
            <%
				dbo.trave({
					conn: config.conn,
					sql: "Select * From blog_member Order By id DESC",
					callback: function(){
						pageInfo = this.serverPage(_page, 20, function(i){
			%>
            	<li>
                	<div class="zone">
                    	<div class="area">
                        	<div class="img"><img src="<%=this("photo").value + "/100"%>" /></div>
                            <div class="info"><div class="name"><%=this("nickname").value%></div></div>
                            <div class="tools">
                            	<a href="javascript:;" class="action-delete" data-id="<%=this("id").value%>">删除</a>
                                <%
									if ( this("canlogin").value === true ){
								%> 
                                <a href="javascript:;" class="action-force" data-id="<%=this("id").value%>">禁止</a> 
                                <%
									}else{
								%>
                                <a href="javascript:;" class="action-unforce" data-id="<%=this("id").value%>">恢复</a>
                                <%		
									};
									
									if ( this("isAdmin").value === true ){
								%>
                                <a href="javascript:;" class="action-down" data-id="<%=this("id").value%>">降阶</a>
                                <%		
									}else{
								%>
                                <a href="javascript:;" class="action-up" data-id="<%=this("id").value%>">提升</a>
                                <%		
									}
								%>
                                
                            </div>
                        </div>
                    </div>
                </li>
            <%	
						});
					}
				});
			%>
            </ul>
            
            <%
				if ( pageInfo.length > 0 ){
					if ( pageInfo[3] > 1 ){
						console.log('<div class="pagebar"><span>分页：</span>');
						var fns = require.async("fn"),
							pages = fns.pageAnalyze(pageInfo[2], pageInfo[3], 9);
							
						fns.pageOut(pages, function(i, isCurrent){
							if ( isCurrent === true ){
								console.log('<span>' + i + '</span>');
							}else{
								console.log('<a href="?p=article&page=' + i + '">' + i + '</a>');
							}
						});
						console.log('</div>');
					}
				}
			 %>  
        </div>
        
    </div>
</div>
<%
	}else{
		console.log("数据库连接失败");
	}
%>