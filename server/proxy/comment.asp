<!--#include file="../config.asp" -->
<%
http.async(function(req){
	var j = req.query.j,
		c = {};
		
	c.post = function(){
		var date = require("DATE"),
			logid = req.form.logid,
			commid = req.form.commid,
			userid = config.user.id,
			content = req.form.content,
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
		
		if ( !userid || userid === 0 ){
			return {
				success: false,
				error: "未找到用户"
			}
		}
		
		logid = Number(logid);
		commid = Number(commid);
		userid = Number(userid);
		
		var dbo = require("DBO"),
			connecte = require("openDataBase"),
			id = 0;
			
		if ( connecte === true ){
			
			dbo.add({
				conn: config.conn,
				table: "blog_comment",
				data: {
					commentid: commid,
					commentlogid: logid,
					commentuserid: userid,
					commentcontent: fns.SQLStr(content),
					commentpostdate: date.format(new Date(), "y/m/d h:i:s"),
					commentpostip: ip,
					commentaduit: false
				},
				callback: function(){
					id = rs("id").value;
				}
			});
			
			if ( id > 0 ){
				
				var cache = require("cache");
					cache.build("artcomm", logid);
				
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
	
	if ( config.user.login === true ){
		if ( c[j] === undefined ){
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