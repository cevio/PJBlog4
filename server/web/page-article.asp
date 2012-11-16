<%
var dbo = require("DBO"),
	connecte = require("openDataBase"),
	_page = http.get("page"),
	cate
	pageInfo = [];
	
%>
<div class="tpl-space fn-clear">
    <div class="article-zone">
        <h3><span class="iconfont">&#367;</span> 日志列表</h3>
        <div class="lsit-area">
        	<div class="fn-clear">
                <ul class="filter">
                    <li>筛选：</li>
                    <li><a href="javascript:alert('暂未开放');">根据分类</a></li>
                </ul>
            </div>
            <table cellspacing="0" class="table">
                <!-- cellspacing='0' is important, must stay -->
                <tbody>
                    <tr>
                        <th>标题</th>
                        <th width="150">分类</th>
                        <th width="100">&nbsp;</th>
                    </tr>
                    <!-- Table Header -->
         <%	
			if ( _page.length === 0 ){
				_page = 1;
			}else{
				_page = Number(_page);
			}
			
			if ( _page < 1 ){
				_page === 1;
			}
			
			if ( connecte === true ){
				var categoryBeyondArray = {};
				
				dbo.trave({
					conn: config.conn,
					sql: "Select * From blog_category",
					callback: function(){
						this.each(function(){
							categoryBeyondArray[this("id").value + ""] = {
								id: this("id").value,
								name: this("cate_name").value
							}
						});
					}
				});
			
				dbo.trave({
					conn: config.conn,
					sql: "Select * From blog_article Order By log_posttime DESC",
					callback: function(rs){
						if ( !(rs.Bof || rs.Eof) ){
							pageInfo = this.serverPage(_page, 10, function(i){
								var even = "";
								if ( (i + 1) % 2 === 0 ){
									even = ' class="even"';
								}
		%>
						<tr<%=even%>>
							<td><%=this("log_title").value%></td>
							<td><%=categoryBeyondArray[this("log_category").value + ""].name%></td>
							<td><a href="?p=writeArticle&id=<%=this("id").value%>">编辑</a> <a href="javascript:;" data-id="<%=this("id").value%>" class="action-del">删除</a></td>
						</tr>
		<%	
							});
						}else{
		%>
        			<tr><td colspan="3">没有数据，请<a href="?p=writeArticle">添加</a>。</td></tr>
        <%
						}
					}
				});
			}else{
		%>
        			<tr><td colspan="3">数据库连接失败，请检查数据库连接配置文件。</td></tr>
        <%		
			}
		 %>
                </tbody>
            </table>
            
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
