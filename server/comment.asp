<!--#include file="../config.asp" -->
<%
	http.service(function(req, dbo){
		var fns = require("fn"),
			date = require("DATE"),
			sap = require.async("sap");
		
		this.reply = function(){
			var id = req.form.id,
				logid = req.form.logid,
				content = fns.SQLStr(req.form.content)
				_id = 0,
				_date = new Date(),
				_ip = fns.getIP();
			
			sap.proxy("system.comment.reply.begin");
				
			dbo.add({
				conn: config.conn,
				table: "blog_comment",
				data: {
					commentid: id,
					commentlogid: logid,
					commentuserid: config.user.id,
					commentcontent: content,
					commentpostdate: date.format(_date, "y/m/d h:i:s"),
					commentpostip: _ip,
					commentaudit: true,
					commentusername: "",
					commentusermail: ""
				},
				callback: function(){
					_id = this("id").value;
				}
			});
			
			var cache = require("cache");
				cache.build("artcomm", logid);
				
			if ( _id > 0 ){
				sap.proxy("system.comment.reply.end");
				return {
					success: true,
					data: {
						id: _id,
						name: config.user.name,
						date: date.format(_date, "y-m-d h:i:s"),
						ip: _ip,
						aduit: true,
						photo: config.user.photo
					}
				}
			}else{
				return {
					success: false,
					error: "数据存储失败"
				}
			}
		}
		
		this.destory = function(){
			var id = req.query.id,
				logid = req.query.logid;
			
			try{
				sap.proxy("system.comment.destory.begin");
				dbo.trave({
					conn: config.conn,
					sql: "select * From blog_comment Where commentid=" + id,
					callback: function(rs){
						if ( rs.Bof || rs.Eof ){}else{
							rs.Delete();
						}
					}
				});
				
				config.conn.Execute("Delete From blog_comment Where id=" + id);
				
				var cache = require("cache");
					cache.build("artcomm", logid);
					
				sap.proxy("system.comment.destory.end");
					
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
		
		this.pass = function(){
			var id = req.query.id,
				logid = req.query.logid;
				
			try{
				sap.proxy("system.comment.pass.begin");
				dbo.update({
					conn: config.conn,
					table: "blog_comment",
					data: {
						commentaudit: true
					},
					key: "id",
					keyValue: id,
					callback: function(){}
				});
				
				var cache = require("cache");
					cache.build("artcomm", logid);
				
				sap.proxy("system.comment.pass.end");
					
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
		
		this.unpass = function(){
			var id = req.query.id,
				logid = req.query.logid;
				
			try{
				sap.proxy("system.comment.unpass.begin");
				dbo.update({
					conn: config.conn,
					table: "blog_comment",
					data: {
						commentaudit: false
					},
					key: "id",
					keyValue: id,
					callback: function(){}
				});
				
				var cache = require("cache");
					cache.build("artcomm", logid);
				
				sap.proxy("system.comment.unpass.end");
					
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
	});
%>