<%
	var dbo = require("DBO"),
		connecte = require("openDataBase");
		
	if ( connecte === true ){
%>
<div class="ui-position fn-clear">
  <div class="fn-left ui-position-title">分类管理</div>
  <div class="fn-right ui-position-tools"></div>
</div>
<div class="ui-context">
	<ul class="categorylist">
    
    <%
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_category Where cate_root=0 Order By cate_order Asc",
			callback: function(rs){
				if ( rs.Bof || rs.Eof ){
					console.log("没有数据，请添加");
				}else{
					this.each(function(){
	%>
    
    	<li data-id="<%=this("id").value%>" data-root="<%=this("cate_root").value%>">
        	<div class="data-value fn-clear">
        		<div class="icon fn-left ui-wrapshadow"><img src="profile/icons/<%=this("cate_icon").value%>" /></div>
            	<div class="info ui-wrapshadow fn-clear">
                	<div class="action fn-right">
                    	<a href="javascript:;" class="ac-add">添加</a><a href="javascript:;" class="ac-edit">编辑</a><a href="javascript:;" class="ac-del">删除</a>
                    </div>
                    <span title="<%=this("cate_info").value%>"><%=this("cate_name").value%></span>
                    <div class="editbox"></div>
                </div>
            </div>
            <ul>
                <%
                    dbo.trave({
                        conn: config.conn,
                        sql: "Select * From blog_category Where cate_root=" + rs("id").value + "  Order By cate_order Asc",
                        callback: function(crs){
                            if ( rs.Bof || rs.Eof ){}else{
                                this.each(function(){
                %>
                <li data-id="<%=this("id").value%>" data-root="<%=this("cate_root").value%>">
                    <div class="data-value fn-clear">
                        <div class="icon fn-left ui-wrapshadow"><img src="profile/icons/<%=this("cate_icon").value%>" /></div>
                        <div class="info ui-wrapshadow">
                        	<div class="action fn-right">
                                <a href="javascript:;" class="ac-edit">编辑</a><a href="javascript:;" class="ac-del">删除</a>
                            </div>
                        	<span title="<%=this("cate_info").value%>"><%=this("cate_name").value%></span>
                            <div class="editbox"></div>
                        </div>
                    </div>
                </li>
                <%
                                });
                            }
                        }
                    });
                %>
            </ul>
        </li>
    <%
					});
				}
			}
		});
	%>
    	<li><button class="button" id="addFirstCategory">添加一级分类</button></li>
    </ul>
</div>
<%
	}else{
		console.log("数据库链接失败");
	}
%>