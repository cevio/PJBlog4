<!--#include file="../../config.asp" -->
<%
http.async(function(req){
	var c = {},
		date = require("DATE"),
		sap = require("sap"),
		fns = require("fn"),
		dbo = require("DBO"),
		connecte = require("openDataBase"),
		j = fns.HTMLStr(fns.SQLStr(req.query.j)),
		cache = require("cache"),
		GRA = require("gra");
	
	if ( connecte !== true ){
		return {
			success: false,
			error: "连接数据库失败"
		}
	}
	
	require("status")();
		
	c.post = function(){
		var logid = fns.HTMLStr(fns.SQLStr(req.form.logid)),
			commid = fns.HTMLStr(fns.SQLStr(req.form.commid)),
			userid = config.user.id,
			content = fns.textareaStr(fns.HTMLStr(fns.SQLStr(req.form.content))),
			username = fns.HTMLStr(fns.SQLStr(req.form.username || "")),
			usermail = fns.HTMLStr(fns.SQLStr(req.form.usermail || "")),
			website = fns.HTMLStr(fns.SQLStr(req.form.website || "")),
			ip = fns.getIP(),
			id = 0,
			datas,
			dates = date.format(new Date(), "y/m/d h:i:s");
			
		if ( !logid || logid.length === 0 ){
			return {
				success: false,
				error: "未找到文章ID"
			}
		}
		
		if ( content.length === 0 ){
			return {
				success: false,
				error: "请输入评论内容"
			}
		}
		
		if ( !commid || commid.length === 0 ){ commid = 0; }
		
		if ( !config.user.login ){
			if ( username.length === 0 ){
				return {
					success: false,
					error: "昵称不能为空"
				}
			}
		}

		logid = Number(logid);
		commid = Number(commid);
		userid = userid;
		
		var getUserPhoto = fns.getUserInfo;
		
		datas = {
			commentid: commid,
			commentlogid: logid,
			commentuserid: userid,
			commentcontent: content,
			commentpostdate: dates,
			commentpostip: ip,
			commentaudit: false,
			commentusername: username,
			commentusermail: usermail,
			commentwebsite: website
		}
			
		sap.proxy("assets.comment.post.begin", [datas, req]);
			
		dbo.add({
			conn: config.conn,
			table: "blog_comment",
			data: datas,
			callback: function(){
				id = this("id").value;
			}
		});
		
		dbo.trave({
			type: 3,
			conn: config.conn,
			sql: "Select * From blog_article Where id=" + logid,
			callback: function( rs ){
				rs("log_comments") = rs("log_comments").value + 1;
				rs.Update();
			}
		});
		
		dbo.trave({
			type: 3,
			conn: config.conn,
			sql: "Select * From blog_global Where id=1",
			callback: function( rs ){
				rs("totalcomments") = rs("totalcomments").value + 1;
				rs.Update();
			}
		});
			
		if ( id > 0 ){
			cache.build("global");
			var reback = {
				id: id,
				commid: commid,
				user: getUserPhoto(userid, username, usermail),
				content: content,
				date: dates,
				ip: ip
			};
			
			sap.proxy("assets.comment.post.end", [reback, req]);
			
			return {
				success: true,
				data: reback
			}
		}else{
			return {
				success: false,
				error: "数据存储失败"
			}
		}
	}
	
	if ( c[j] !== undefined ){
		return c[j]();
	}else{
		return {
			success: false,
			error: "参数错误"
		}
	}
});
CloseConnect();
%>