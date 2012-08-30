<%
define(["openDataBase"], function(require, exports, module){
	var oauth = require.async("server/oAuth/qq/oauth"),
		dbo = require.async("DBO"),
		APPID,
		APPKEY,
		WEBSITE,
		token,
		openid,
		info;
		
	var getInfoFromDBO = function(){
		if ( config.conn !== null ){
			dbo.select({
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
		var ret;
	
		if ( getInfoFromDBO() === true ){
			token = oauth.token(APPID, APPKEY, code, WEBSITE);
			if ( token.success === true ){
				openid = oauth.openid(token.data.access_token);
				if ( openid.success === true ){
					info = oauth.getInfo(token.data.access_token, openid.data.openid, APPID);
					if ( info.success === true ){
						try{
							var sha1 = require.async("SHA1"),
								iddbo = openid.data.openid;
							dbo.select({
								conn : config.conn,
								sql : "Select * From blog_member Where qq_openid=" + openid.data.openid,
								callback : function(rs){
									if ( rs.Bof || rs.Eof ){
										dbo.add({
											conn : config.conn,
											table : "blog_member",
											data : {
												isAdmin : false,
												adminPass : sha1("admin888"),
												sex : info.data.gender === "男",
												photo : info.data.figureurl.split("/").slice(0, -1).join("/"),
												nickname : info.data.nickname,
												oauth : "qq",
												qq_token : token.data.access_token,
												qq_openid : openid.data.openid
											}
										});
									}else{
										dbo.update({
											conn : config.conn,
											table : "blog_member",
											data : {
												sex : info.data.gender === "男",
												photo : info.data.figureurl.split("/").slice(0, -1).join("/"),
												nickname : info.data.nickname,
												qq_token : token.data.access_token
											},
											key : "qq_openid",
											keyValue : openid.data.openid
										})
									}
								}
							});
							
							var cookie = require.async("COOKIE");
								
								cookie.set(config.cookie + "_user", "id", openid.data.openid);
								cookie.set(config.cookie + "_user", "token", token.data.access_token);
								
								cookie.expire(config.cookie + "_user", 30 * 24 * 60 * 60 * 1000);
							
							ret = {
								success : true,
								photo : info.data.figureurl,
								nickname : info.data.nickname
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
		}
		
		(config.conn !== null) && config.conn.Close();
		
		return ret;
	}
	
	return login;
});
%>