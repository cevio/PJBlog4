<!--#include file="../config.asp" -->
<%
	http.async(function(req){
		var j = req.query.j, callbacks = {};
		
		callbacks.mdelete = function(){
			var id = http.get("id");
			
			if ( !id || id.length === 0 ){
				return {
					success: false,
					error: "参数错误"
				}
			}
			
			id = Number(id);
						
			var dbo = require("DBO"),
				connecte = require("openDataBase");
				
			if ( connecte === true ){
				try{
					var cache = require("cache");
					
					config.conn.Execute("Delete From blog_member Where id=" + id);
					dbo.trave({
						conn: config.conn,
						sql: "Select * From blog_comment Where commentuserid=" + id,
						callback: function(){
							var container = [];
								this.each(function(){
									var logid = this("commentlogid").value;
									if ( container.indexOf(logid) === -1 ){
										cache.build("artcomm", logid);
										container.push(logid);
									}
								});
						}
					});
					cache.destory("user", id);
						
					return {
						success: true	
					}
					
				}catch(e){
					return {
						success: false,
						error: e.message
					}
				}
			}else{
				return {
					success: false,
					error: "数据库连接失败"
				}
			}
		}
		
		if ( Session("admin") === true ){
			if ( callbacks[j] !== undefined ){
				return callbacks[j]();
			}else{
				return {
					success: false,
					error: "未找到对应处理模块"
				}
			}
		}else{
			return {
				success: false,
				error: "非法权限操作"
			}
		}
	});
	CloseConnect();
%>