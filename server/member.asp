<!--#include file="../config.asp" -->
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
		
		callbacks.mdelete = function(){						
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
		
		callbacks.mforce = function(){			
			var dbo = require("DBO"),
				connecte = require("openDataBase");
				
			if ( connecte === true ){
				try{
					var cache = require("cache");
					dbo.trave({
						type: 3,
						conn: config.conn,
						sql: "Select * From blog_member Where id=" + id,
						callback: function(rs){
							rs("canlogin") = false;
							rs.Update();
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
		
		callbacks.munforce = function(){			
			var dbo = require("DBO"),
				connecte = require("openDataBase");
				
			if ( connecte === true ){
				try{
					var cache = require("cache");
					dbo.trave({
						type: 3,
						conn: config.conn,
						sql: "Select * From blog_member Where id=" + id,
						callback: function(rs){
							rs("canlogin") = true;
							rs.Update();
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
		
		
		callbacks.toadmin = function(){			
			var dbo = require("DBO"),
				connecte = require("openDataBase");
				
			if ( connecte === true ){
				try{
					var cache = require("cache");
					dbo.trave({
						type: 3,
						conn: config.conn,
						sql: "Select * From blog_member Where id=" + id,
						callback: function(rs){
							rs("isAdmin") = true;
							rs.Update();
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
		
		callbacks.untoadmin = function(){			
			var dbo = require("DBO"),
				connecte = require("openDataBase");
				
			if ( connecte === true ){
				try{
					var cache = require("cache");
					dbo.trave({
						type: 3,
						conn: config.conn,
						sql: "Select * From blog_member Where id=" + id,
						callback: function(rs){
							rs("isAdmin") = false;
							rs.Update();
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
			
				if ( config.user.id !== id ){
					return callbacks[j]();
				}else{
					return {
						success: false,
						error: "不能对自己操作"
					}
				}
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