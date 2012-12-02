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
<div class="ui-position fn-clear">
  <div class="fn-left ui-position-title">用户管理</div>
  <div class="fn-right ui-position-tools"><form action="server/member.asp?j=searchuser&id=0" method="post" style="margin:0; padding:0;" id="search"><input type="text" value="" name="keyword" placeholder="搜索已注册的好友" style="width:200px;" /><input type="submit" class="search-submit" value=""></form></div>
</div>
<div class="ui-context">
	<ul class="fn-clear userlist">
    	 <%
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_member Order By id DESC",
				callback: function(){
					pageInfo = this.serverPage(_page, 50, function(i){
		%>
        <li class="fn-left userlist">
        	<div class="list clafn-clear">
        		<div class="photo ui-wrapshadow fn-left"><img src="<%=this("photo").value + "/50"%>" /></div>
            	<div class="info fn-left">
                	<div class="name"><%=this("nickname").value%></div>
                    <div class="action">
                    	<%
							if ( this("id").value !== config.user.id ){
						%>
                    	<a href="javascript:;" class="action-delete" data-id="<%=this("id").value%>" title="删除后无法恢复，请慎重。">删除</a>
						<%
                            	if ( this("canlogin").value === true ){
                        %> 
                        <a href="javascript:;" class="action-force" data-id="<%=this("id").value%>" title="对该用户的登入权限进行限制">禁止</a> 
                        <%
                            	}else{
                        %>
                        <a href="javascript:;" class="action-unforce" data-id="<%=this("id").value%>" title="对该用户的登入权限进行限制">恢复</a>
                        <%		
                            	};
                            
                            	if ( this("isAdmin").value === true ){
                        %>
                        <a href="javascript:;" class="action-down" data-id="<%=this("id").value%>" title="对该用户进行权限上的提升或者降阶，可以进入后台或者还原为普通用户。">降阶</a>
                        <%		
                            	}else{
                        %>
                        <a href="javascript:;" class="action-up" data-id="<%=this("id").value%>" title="对该用户进行权限上的提升或者降阶，可以进入后台或者还原为普通用户。">提升</a>
                        <%		
                            	}
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
    	<li></li>
    </ul>
    <%
		if ( pageInfo.length > 0 ){
			if ( pageInfo[3] > 1 ){
				console.log('<div class="pagebar fn-clear"><span class="fn-left join"></span>');
				var fns = require.async("fn"),
					pages = fns.pageAnalyze(pageInfo[2], pageInfo[3], 9);
					
				fns.pageOut(pages, function(i, isCurrent){
					if ( isCurrent === true ){
						console.log('<span class="fn-left pages">' + i + '</span>');
					}else{
						console.log('<a href="?p=member&page=' + i + '" class="fn-left pages">' + i + '</a>');
					}
				});
				console.log('</div>');
			}
		}
	 %>
</div>
<%
	}else{
		console.log("数据库连接失败");
	}
%>