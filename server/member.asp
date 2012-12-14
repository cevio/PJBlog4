<!--#include file="../config.asp" -->
<%
http.service(function( req, dbo, sap ){
	this.mdelete = function(){
		var id = req.query.id;
		if ( id.length === 0 ){
			return {
				success: false,
				error: "参数错误"
			}
		}					
		try{
			var cache = require("cache");
			config.conn.Execute("Delete From blog_member Where id=" + id);
			config.conn.Execute("Delete From blog_comment Where commentuserid=" + id);
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
	}
	
	this.mforce = function(){	
		var id = req.query.id;
		if ( id.length === 0 ){
			return {
				success: false,
				error: "参数错误"
			}
		}					
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
	}
	
	this.munforce = function(){
		var id = req.query.id;
		if ( id.length === 0 ){
			return {
				success: false,
				error: "参数错误"
			}
		}
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
	}
	
	this.toadmin = function(){			
		var id = req.query.id;
		if ( id.length === 0 ){
			return {
				success: false,
				error: "参数错误"
			}
		}
		try{
			var cache = require("cache");
			dbo.trave({
				type: 3,
				conn: config.conn,
				sql: "Select * From blog_member Where id=" + id,
				callback: function(rs){
					rs("isposter") = true;
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
	}
	
	this.untoadmin = function(){			
		var id = req.query.id;
		if ( id.length === 0 ){
			return {
				success: false,
				error: "参数错误"
			}
		}
		try{
			var cache = require("cache");
			dbo.trave({
				type: 3,
				conn: config.conn,
				sql: "Select * From blog_member Where id=" + id,
				callback: function(rs){
					rs("isposter") = false;
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
	}
	
	this.searchuser = function(){
		var keyword = req.form.keyword;

		if ( keyword.length > 0 ){
			var ret = [];
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_member Where nickName like '%" + keyword + "%' Order By logindate DESC",
				callback: function(rs){
					this.each(function(){
						ret.push({
							photo: this("photo").value,
							nickname: this("nickName").value,
							isadmin: this("isAdmin").value,
							canlogin: this("canlogin").value,
							id: this("id").value
						});
					});
				}
			});
			
			return {
				success: true,
				data: ret
			}
		}else{
			return {
				success: false,
				error: "参数错误"
			}
		}
	}
});
%>