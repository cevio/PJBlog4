<%
	var id = http.get("id") || "",
		dbo = require("DBO"),
		connecte = require("openDataBase"),
		mode,
		actionURL;
		
	if ( id.length === 0 ){
		mode = "add";
		actionURL = "server/article.asp?j=add";
	}else{
		mode = "edit";
		actionURL = "server/article.asp?j=update";
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
	
		var log_title = "",
			log_category = "",
			log_tags = "",
			log_content = "";
			
		
		if ( mode === "edit" ){
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_article Where id=" + id,
				callback: function(rs){
					if ( rs.Bof || rs.Eof ){}else{
						log_title = rs("log_title").value;
						log_category = rs("log_category").value;
						log_tags = rs("log_tags").value;
						log_content = rs("log_content").value;
						
						var module_tags = require("tags");
						log_tags = module_tags.reFormatTags(log_tags);
						log_tags = (function(modules){
							var arrays = []
						
							for ( var i = 0 ; i < log_tags.length ; i++ ){
								var value = modules.readTag( log_tags[i] );
								
								if ( value.success === true ){
									arrays.push( value.data.name );
								}
							}
							
							return arrays.join(",");
						})(module_tags)
						
					}
				}
			});
		}
%>
<div class="tpl-space fn-clear">
	<div class="article-zone">
    	<div class="write-area">
        	<form action="<%=actionURL%>" method="post" style="margin:0; padding:0;">
            	<input type="hidden" value="<%=id%>" name="id" />
                <h3><span class="iconfont">&#367;</span> <%console.log( mode === "add" ? "新建日志" : "编辑日志" )%></h3>
                <div class="write-zone">
                    <div class="log-title maginbom"><input type="text" value="<%=log_title%>" name="log_title" placeholder="日志标题" /></div>
                    <div class="log-cate maginbom fn-clear">
                        <input type="hidden" value="<%=log_category%>" name="log_category" />
                        <input type="hidden" value="<%=log_category%>" name="log_oldCategory" />
                        <div class="fn-left log-cate-title">
                            <span class="import">分类</span>
                            <span class="gray">点击右边分类名选择或者更换所属分类</span>
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
                        <div class="fn-clear head"><div class="tip-title fn-left">内容区域</div><div class="fn-right tags"><input type="text" value="<%=log_tags%>" name="log_tags" placeholder="标签..."></div></div>
                        <textarea style="height:350px;" name="log_content"><%=log_content%></textarea>
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