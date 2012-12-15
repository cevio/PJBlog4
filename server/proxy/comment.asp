<!--#include file="../../config.asp" -->
<%
http.async(function(req){
	var c = {},
		date = require("DATE"),
		sap = require("sap"),
		fns = require("fn"),
		dbo = require("DBO"),
		connecte = require("openDataBase"),
		j = fns.HTMLStr(fns.SQLStr(req.query.j));
	
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
			ip = fns.getIP(),
			id = 0,
			datas;
			
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

		logid = Number(logid);
		commid = Number(commid);
		userid = userid;
		
		datas = {
			commentid: commid,
			commentlogid: logid,
			commentuserid: userid,
			commentcontent: content,
			commentpostdate: date.format(new Date(), "y/m/d h:i:s"),
			commentpostip: ip,
			commentaudit: false,
			commentusername: username,
			commentusermail: usermail
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
			
		if ( id > 0 ){
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