<div class="tpl-space fn-clear">
	<div class="cate-zone">
    	<h3><span class="iconfont">&#367;</span> 分类管理</h3>
        <div class="tools fn-clear"> <div class="fn-left">暂时无法拖动存放改变分类结构</div> </div>
        
        <div class="list">
<%
	var dbo = require("DBO"),
		connecte = require("openDataBase");
		
	if ( connecte === true ){
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_category Where cate_root=0 Order By cate_order Asc",
			callback: function(rs){
				if ( rs.Bof || rs.Eof ){
					console.log("没有数据，请添加");
				}else{
					this.each(function(){
%>
			<div class="one items">
            	<div class="scroll-wrap">
                    <div class="view fn-clear">
                        <div class="label tpl-button-gray"><div class="box"><i></i> <span title="<%=this("cate_name").value%>"><%=this("cate_name").value%></span></div></div>
                        <div class="edit-info" title="<%=this("cate_info").value%>"><%=this("cate_info").value%></div>
                        <div class="action"><a href="javascript:;" class="action-add" data-id="<%=this("id").value%>"><span class="iconfont">&#410;</span>添加</a> <a href="javascript:;" class="action-edit" data-id="<%=this("id").value%>"><span class="iconfont">&#355;</span>编辑</a>  <a href="javascript:;" class="action-del" data-id="<%=this("id").value%>"><span class="iconfont">&#356;</span>删除</a></div>
                    </div>
                    <div class="editzone fn-clear"></div>
                </div>
            </div>
<%
						dbo.trave({
							conn: config.conn,
							sql: "Select * From blog_category Where cate_root=" + rs("id").value + "  Order By cate_order Asc",
							callback: function(crs){
								if ( rs.Bof || rs.Eof ){}else{
									this.each(function(){
%>
			            <div class="two items">
            	<div class="scroll-wrap">
                    <div class="view fn-clear">
                        <div class="label tpl-button-green"><div class="box"><i></i> <span title="<%=this("cate_name").value%>"><%=this("cate_name").value%></span></div></div>
                        <div class="edit-info" title="<%=this("cate_info").value%>"><%=this("cate_info").value%></div>
                        <div class="action"><a href="javascript:;" class="action-edit" data-id="<%=this("id").value%>"><span class="iconfont">&#355;</span>编辑</a>  <a href="javascript:;" class="action-del" data-id="<%=this("id").value%>"><span class="iconfont">&#356;</span>删除</a></div>
                    </div>
                    <div class="editzone fn-clear"></div>
                </div>
            </div>
<%
									});
								}
							}
						});
					});
				}
			}
		});
	}else{
%>
	数据库连接失败。
<%	
	}
%>            
        </div>
        
        <div class="action-tools"><a href="javascript:;" class="action-add tpl-button-blue cate-add-button">添加新一级分类目录</a></div>
    </div>
</div>