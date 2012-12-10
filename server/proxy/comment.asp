<!--#include file="../../config.asp" -->
<%
http.async(function(req){
	var j = req.query.j,
		c = {};
		
	c.post = function(){
		require("status");
	
		var date = require("DATE"),
			sap = require("sap"),
			logid = req.form.logid,
			commid = req.form.commid,
			userid = config.user.id,
			content = req.form.content,
			username = req.form.username,
			usermail = req.form.usermail,
			fns = require("fn"),
			ip = fns.getIP();
			
		if ( !logid || logid.length === 0 ){
			return {
				success: false,
				error: "未找到文章ID"
			}
		}
		
		if ( !commid || commid.length === 0 ){
			commid = 0;
		}
		
		if ( !userid || userid.toString().length === 0 || Number(userid) === 0 ){
			userid = 0;
		}

		logid = Number(logid);
		commid = Number(commid);
		userid = Number(userid);
		
		var dbo = require("DBO"),
			connecte = require("openDataBase"),
			id = 0;
			
		if ( connecte === true ){
			
			sap.proxy("assets.comment.post.begin");
			
			dbo.add({
				conn: config.conn,
				table: "blog_comment",
				data: {
					commentid: commid,
					commentlogid: logid,
					commentuserid: userid,
					commentcontent: fns.textareaStr(fns.HTMLStr(fns.SQLStr(content))),
					commentpostdate: date.format(new Date(), "y/m/d h:i:s"),
					commentpostip: ip,
					commentaudit: false,
					commentusername: username,
					commentusermail: usermail
				},
				callback: function(){
					id = this("id").value;
				}
			});
			
			if ( id > 0 ){
				
				var cache = require("cache");
					cache.build("artcomm", logid);
				
				sap.proxy("assets.comment.post.end");
				
				return {
					success: true,
					data: {
						id: id
					}
				}
			}else{
				return {
					success: false,
					error: "数据存储失败"
				}
			}
			
		}else{
			return {
				success: false,
				error: "连接数据库失败"
			}
		}
	}
	
	if ( config.user.login !== true ){
		if ( c[j] !== undefined ){
			return c[j]();
		}else{
			return {
				success: false,
				error: "参数错误"
			}
		}
	}else{
		return {
			success: false,
			error: "未登入，请先登入。"
		}
	}
});
CloseConnect();
%>