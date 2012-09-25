<%
	var id = http.get("id") || "",
		dbo = require("DBO"),
		connecte = require("openDataBase"),
		mode;
		
	if ( id.length === 0 ){
		mode = "add";
	}
		
	function getSecondDatas(id){
		dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_category Where cate_root=" + id + " And cate_outlink=False Order By cate_order Asc",
				callback: function(ret){
					if ( ret.Bof || ret.Eof ){}else{
						this.each(function(){
		%>
		<li><span class="fn-wordWrap cate-name" data-id="<%=this("id").value%>" title="<%=this("cate_name").value%>"><%=this("cate_name").value%></span></li>
		<%
						});
					}
				}
			})
	}
		
	if ( connecte === true ){
%>
<div class="tpl-space fn-clear">
	<div class="article-zone">
    	<div class="write-area">
        	<form action="" method="post" style="margin:0; padding:0;">
                <h3><span class="iconfont">&#367;</span> <%console.log( mode === "add" ? "新建日志" : "编辑日志" )%></h3>
                <div class="write-zone">
                    <div class="log-title maginbom"><input type="text" value="" name="log_title" placeholder="日志标题" /></div>
                    <div class="log-cate maginbom fn-clear">
                        <input type="hidden" value="<%=id%>" name="log_category" />
                        <div class="fn-left log-cate-title">
                            <span class="import">分类</span>
                            <span class="gray">选择本文所属的分类，允许只能选择一个分类作为所述分类。</span>
                        </div>
                        <div class="fn-left log-cate-content">
                            <ul>
                            	<%
									dbo.trave({
										conn: config.conn,
										sql: "Select * From blog_category Where cate_root=0 And cate_outlink=False Order By cate_order Asc",
										callback: function(rs){
											if ( rs.Bof || rs.Eof ){}else{
												this.each(function(){
								%>
                                <li class="fn-clear">
                                    <div class="cate-one"><span class="fn-wordWrap cate-name" data-id="<%=this("id").value%>" title="<%=this("cate_name").value%>"><%=this("cate_name").value%></span></div>
                                    <div class="cate-two fn-clear">
                                        <ul><%getSecondDatas(rs("id").value)%></ul>
                                    </div>
                                </li>
                                <%
												});
											}
										}
									});
								%>
                            </ul>
                        </div>
                    </div>
                    <div class="log-content maginbom">
                        <div class="fn-clear head"><div class="tip-title fn-left">内容区域</div><div class="fn-right tags"><input type="text" value="" name="log_tags" placeholder="标签..."></div></div>
                        <textarea style="height:350px;" name="log_content"></textarea>
                    </div>
                    <div class="log-actions"><input type="submit" value="提交" class="tpl-button-blue log-submit" /></div>
                </div>
            </form>
        </div>
    </div>
</div>
<%
	}else{
%>
	<div class="tpl-space fn-clear" style="padding:60px 80px;">打开数据库失败</div>
<%	
	}
%>