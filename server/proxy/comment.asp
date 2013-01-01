<!--#include file="../../config.asp" -->
<%
try{
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
				dates = date.format(new Date(), "y/m/d h:i:s"),
			    globalCaches = cache.load("global");

			var nowTimer = new Date().getTime(),
			    cookiePostTimer = Session(config.cookie + "_commentTimer");

			if ( cookiePostTimer && (!isNaN(cookiePostTimer)) ){
				if ( (nowTimer - cookiePostTimer) <= (globalCaches.commentdelaytimer * 1000) ){
					return {
						success: false,
						error: "您发表评论太快了，请过" + globalCaches.commentdelaytimer + "秒后再发表。"
					}
				}
			}
			
			if ( globalCaches.commentvaildor === true ){
				var code = fns.HTMLStr(fns.SQLStr(req.form.code || "")),
					_code = Session("GetCode") + "";
				if ( code !== _code ){
					return {
						success: false,
						error: "验证码不正确"
					}
				}
			}
				
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
			
			if ( content.length > globalCaches.commentmaxlength ){
				return {
					success: false,
					error: "评论内容超出限制，限制为" + globalCaches.commentmaxlength + "字。"
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
			
			var getUserPhoto = fns.getUserInfo,
			    paramsProtypeName = [],
			    paramsProtypeValue = [];

			paramsProtypeName.push(
				"commentid", 
				"commentlogid", 
				"commentuserid", 
				"commentcontent", 
				"commentpostdate", 
				"commentpostip", 
				"commentaudit", 
				"commentusername",
				"commentusermail",
				"commentwebsite"
			);

			paramsProtypeValue.push(
				Number(commid),
				Number(logid),
				Number(userid),
				"'" + content + "'",
				"'" + dates + "'",
				"'" + ip + "'",
				globalCaches.commentaduit === true ? false : true,
				"'" + username + "'",
				"'" + usermail + "'",
				"'" + website + "'"
			);

			sap.proxy("assets.comment.post.begin", [req, paramsProtypeName, paramsProtypeValue]);
			
			config.conn.BeginTrans();
			try{
				config.conn.Execute("INSERT INTO blog_comment ( " + paramsProtypeName.join(",") + " ) VALUES ( " + paramsProtypeValue.join(",") + " )");
				id = Number(String(config.conn.Execute("Select MAX(id) From blog_comment")(0)));
				config.conn.Execute("UPDATE blog_article SET log_comments=log_comments+1 Where id=" + logid);
				config.conn.Execute("UPDATE blog_global SET totalcomments=totalcomments+1 Where id=1");
				config.conn.CommitTrans();
			}catch(e){
				console.push("comment assets post error:" + e.message);
				config.conn.RollBackTrans();
			}
				
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

				Session(config.cookie + "_commentTimer") = nowTimer;
				
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
}catch(e){
	CloseConnect();
	console.log(JSON.stringify({
		success: false,
		error: e.message
	}));
}
%>
