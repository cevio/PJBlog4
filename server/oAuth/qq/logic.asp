<%
define(["openDataBase"], function(require, exports, module){
	var oauth = require.async("server/oAuth/qq/oauth"),
		dbo = require.async("DBO"),
		fns = require.async("fn"),
		APPID,
		APPKEY,
		WEBSITE,
		token,
		openid,
		info;
		
	var getInfoFromDBO = function(){
		if ( config.conn !== null ){
			dbo.trave({
				conn : config.conn,
				sql : "Select * From blog_global Where id=1",
				callback : function( rs ){
					APPID = rs("qq_appid").value;
					APPKEY = rs("qq_appkey").value;
					WEBSITE = rs("website").value;
				}
			});
			return true;
		}else{
			console.push("Open DataBase Error!");
			return false;
		}
	}
	
	var login = function(code){
		var ret, id = 0;
	
		if ( getInfoFromDBO() === true ){
			token = oauth.token(APPID, APPKEY, code, WEBSITE);
			if ( token.success === true ){
				openid = oauth.openid(token.data.access_token);
				if ( openid.success === true ){
					info = oauth.getInfo(token.data.access_token, openid.data.openid, APPID);
					if ( info.success === true ){
						try{
							var sha1 = require.async("SHA1"),
								iddbo = openid.data.openid,
								salt = fns.randoms(40),
								saltSHA1 = sha1(salt);
								
							dbo.trave({
								conn : config.conn,
								sql : "Select * From blog_member Where qq_openid='" + openid.data.openid + "'",
								callback : function(rs){
									if ( rs.Bof || rs.Eof ){
										dbo.add({
											conn : config.conn,
											table : "blog_member",
											data : {
												isAdmin : false,
												adminPass : sha1("admin888"),
												sex : info.data.gender === "男" ? 1 : 2,
												photo : info.data.figureurl.split("/").slice(0, -1).join("/"),
												nickname : info.data.nickname,
												oauth : "qq",
												qq_token : token.data.access_token,
												qq_openid : openid.data.openid,
												hashkey: salt
											},
											callback: function(){
												id = this("id").value;
											}
										});
									}else{
										dbo.update({
											conn : config.conn,
											table : "blog_member",
											data : {
												sex : info.data.gender === "男" ? 1 : 2,
												photo : info.data.figureurl.split("/").slice(0, -1).join("/"),
												nickname : info.data.nickname,
												qq_token : token.data.access_token,
												hashkey: salt
											},
											key : "qq_openid",
											keyValue : "'" + openid.data.openid + "'",
											callback: function(){
												id = this("id").value;
											}
										});
									}
								}
							});
							
							if ( id > 0 ){
								var cookie = require.async("COOKIE");
									
									cookie.set(config.cookie + "_user", "id", id);
									cookie.set(config.cookie + "_user", "hashkey", saltSHA1);
									cookie.set(config.cookie + "_user", "oauth", "qq");
									
									cookie.expire(config.cookie + "_user", 30 * 24 * 60 * 60 * 1000);
								
								ret = {
									success : true,
									photo : info.data.figureurl,
									nickname : info.data.nickname
								}
							}else{
								ret = {
									success : false,
									error : "数据录入失败"
								}
							}
						}catch(e){
							ret = {
								success : false,
								error : e.message
							}
						}
						
					}else{
						ret = {
							success : false,
							error : "info error"
						}
					}
				}else{
					ret = {
						success : false,
						error : "openid error"
					}
				}
			}else{
				ret = {
					success : false,
					error : "token error"
				}
			}
		}else{
			ret = {
				success : false,
				error : "dbo error"
			}
		}
		CloseConnect();
		return ret;
	}
	
	return login;
});
%>