<!--#include file="../../../config.asp" -->
<%
	http.async(function(req){
		require("status");
		var j = req.query.j, callbacks = {};
		
		var id = http.get("id");
			
		if ( !id || id.length === 0 ){
			return {
				success: false,
				error: "参数错误"
			}
		}
		
		id = Number(id);
		
		callbacks.gdelete = function(){						
			var dbo = require("DBO"),
				connecte = require("openDataBase");
				
			if ( connecte === true ){
				try{
					var cache = require("cache");
					config.conn.Execute("Delete From blog_guestbook Where id=" + id);
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

		callbacks.aduit = function(){			
			var dbo = require("DBO"),
				connecte = require("openDataBase");
			if ( connecte === true ){
				try{
					dbo.trave({
						type: 3,
						conn: config.conn,
						sql: "Select * From blog_guestbook Where id=" + id,
						callback: function(rs){
							rs("bookaduit") = (rs("bookaduit")==false);
							rs.Update();
						}
					});
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