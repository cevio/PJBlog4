<!--#include file="../config.asp" -->
<%
	http.service(function(req, dbo, sap){
		var fns = require("fn"),
			date = require("DATE");
		
		this.reply = function(){
			var id = req.form.id,
				logid = req.form.logid,
				content = fns.HTMLStr(fns.SQLStr(req.form.content)),
				_id = 0,
				_date = new Date(),
				_ip = fns.getIP(),
				rets = {};
				
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_global Where id=1",
				callback: function(rs){
					rets.commentid = id;
					rets.commentlogid = logid;
					rets.commentuserid = config.user.id;
					rets.commentcontent = content;
					rets.commentpostdate = date.format(_date, "y/m/d h:i:s");
					rets.commentpostip = _ip;
					rets.commentaudit = true;
					rets.commentusername = rs("authoremail").value;
					rets.commentusermail = rs("website").value;
				}
			});
			
			sap.proxy("system.comment.reply.begin", [rets, req]);
				
			dbo.add({
				conn: config.conn,
				table: "blog_comment",
				data: rets,
				callback: function(){
					_id = this("id").value;
				}
			});
			
			config.conn.Execute("UPDATE blog_article SET log_comments=log_comments+1 Where id=" + logid);
			config.conn.Execute("UPDATE blog_global SET totalcomments=totalcomments+1 Where id=1");

			if ( _id > 0 ){
				var cache = require.async("cache");
					cache.build("global");
					
				return {
					success: true,
					data: {
						id: _id,
						name: config.user.name,
						date: rets.commentpostdate,
						ip: _ip,
						aduit: true,
						photo: config.user.photo,
						logid: logid,
						root: id
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
				logid = req.query.logid,
				count = 0;
			
			try{
				dbo.trave({
					conn: config.conn,
					sql: "select * From blog_comment Where commentid=" + id,
					callback: function(rs){
						if ( rs.Bof || rs.Eof ){}else{
							rs.Delete();
							count++;
						}
					}
				});

				config.conn.Execute("Delete From blog_comment Where id=" + id);
				count++;
				
				dbo.trave({
					type: 3,
					conn: config.conn,
					sql: "Select * From blog_article Where id=" + logid,
					callback: function( rs ){
						rs("log_comments") = rs("log_comments").value - count;
						rs.Update();
					}
				});
				
				dbo.trave({
					type: 3,
					conn: config.conn,
					sql: "Select * From blog_global Where id=1",
					callback: function( rs ){
						rs("totalcomments") = rs("totalcomments").value - count;
						rs.Update();
					}
				});
				
				var cache = require.async("cache");
					cache.build("global");
					
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