<div class="ui-position fn-clear">
  <div class="fn-left ui-position-title">评论管理</div>
  <div class="fn-right ui-position-tools"></div>
</div>
<div class="ui-context">
<%
	var dbo = require("DBO"),
		connecte = require("openDataBase"),
		GRA = require("gra"),
		date = require("DATE"),
		page = http.get("page");
		
	if ( page.length === 0 ){ page = 1; }else{ page = Number(page); }
	if ( page < 1 ){ page = 1; }
		
	if ( connecte === true ){
		
		function getUserInfo(id){
			var userData = {};
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_member Where id=" + id,
				callback: function(rs){
					userData.sex = rs("sex").value;
					userData.photo = rs("photo").value;
					userData.nickName = rs("nickName").value;
					userData.type = "qq";
				}
			});
			return userData
		}
		
		var pageInfo = [];
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_comment Where commentid=0 Order By commentpostdate Desc, commentaudit Desc",
			callback: function(rs){
				if ( rs.Bof || rs.Eof ){
					console.log("没有评论数据");
				}else{
%>
	<ul>
<%
					pageInfo = this.serverPage(page, 10, function(){
						var user = this("commentuserid").value,
							userData = {};
							
						if ( !user ){
							userData.type = "guest";
							userData.sex = 0;
							userData.photo = GRA(this("commentusermail").value);
							userData.nickName = this("commentusername").value;
						}else{
							userData = getUserInfo(this("commentuserid").value);
						}
%>
		<li class="comment-li comment-root" data-id="<%=this("id").value%>" data-logid="<%=this("commentlogid").value%>">
        	<div class="comment-zone fn-clear">
            	<div class="comment-photo fn-left">
                	<div class="user-photo ui-wrapshadow"><img src="<%=userData.type==="guest" ? userData.photo : userData.photo + "/50"%>" /></div>
                </div>
                <div class="comment-context">
                	<div class="comment-content">
                    	<div class="comment-name"><%=userData.nickName%> 于 <%=date.format(this("commentpostdate").value, "y-m-d h:i:s")%>发表评论： [ <%=this("commentpostip").value%> ]</div>
                        <div class="comment-word"><%=this("commentcontent").value%></div>
                        <div class="comment-else">
                        	<a href="javascript:;" class="ac-reply">回复</a>
                            <a href="javascript:;" class="ac-del">删除</a>
                            <%
								if ( this("commentaudit").value ){
							%>
                            <a href="javascript:;" class="ac-noaduit">取消</a>
                            <%
								}else{
							%>
                            <a href="javascript:;" class="ac-aduit">通过</a>
                            <%	
								}
							%>
                        </div>
                    </div>
                </div>
            </div>
            <div class="comment-children">
				<%
                    dbo.trave({
                        conn: config.conn,
                        sql: "Select * From blog_comment Where commentid=" + this("id").value + " Order By commentpostdate Desc, commentaudit Desc",
                        callback: function(ts){
                            if ( ts.Bof || ts.Eof ){}else{
                %>
                <ul class="comment-children-area">
                <%
                                this.each(function(){
                                    var _user = this("commentuserid").value,
										_userData = {};
										
									if ( !_user ){
										_userData.type = "guest";
										_userData.sex = 0;
										_userData.photo = GRA(this("commentusermail").value);
										_userData.nickName = this("commentusername").value;
									}else{
										_userData = getUserInfo(this("commentuserid").value);
									}
				%>
                	<li class="comment-li" data-id="<%=this("id").value%>" data-logid="<%=this("commentlogid").value%>">
                    	<div class="comment-zone fn-clear">
                            <div class="comment-photo fn-left">
                                <div class="user-photo ui-wrapshadow"><img src="<%=_userData.type==="guest" ? _userData.photo : _userData.photo + "/30"%>" /></div>
                            </div>
                            <div class="comment-context">
                                <div class="comment-content">
                                    <div class="comment-name"><%=_userData.nickName%> 于 <%=date.format(this("commentpostdate").value, "y-m-d h:i:s")%>发表评论： [ <%=this("commentpostip").value%> ]</div>
                                    <div class="comment-word"><%=this("commentcontent").value%></div>
                                    <div class="comment-else">
                                    	<a href="javascript:;" class="ac-reply">回复</a>
                                        <a href="javascript:;" class="ac-del">删除</a>
                                        <%
											if ( this("commentaudit").value ){
										%>
										<a href="javascript:;" class="ac-noaduit">取消</a>
										<%
											}else{
										%>
										<a href="javascript:;" class="ac-aduit">通过</a>
										<%	
											}
										%>
                            		</div>
                                </div>
                            </div>
                        </div>
                    </li>
                <%
                                });
                %>
                </ul>
                <%
                            }
                        }
                    })
                %>
            </div>
        </li>
<%
					});
%>
	</ul>
<%
				}
			}
		});
		
		if ( pageInfo.length > 0 ){
			if ( pageInfo[3] > 1 ){
				console.log('<div class="pagebar fn-clear"><span class="fn-left join"></span>');
				var fns = require.async("fn"),
					pages = fns.pageAnalyze(pageInfo[2], pageInfo[3], 9);
					
				fns.pageOut(pages, function(i, isCurrent){
					if ( isCurrent === true ){
						console.log('<span class="fn-left pages">' + i + '</span>');
					}else{
						console.log('<a href="?p=comment&page=' + i + '" class="fn-left pages">' + i + '</a>');
					}
				});
				console.log('</div>');
			}
		}
		
	}else{
		console.log("连接数据库失败");
	}
%>
</div>