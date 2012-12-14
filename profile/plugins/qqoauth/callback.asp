<!--#include file="../../../config.asp" -->
<%
try{
	var dbo = require("DBO"),
		connect = require("openDataBase"),
		cache = require("cache"),
		oauth = require("./oauth"),
		pluginCustom = require("pluginCustom"),
		fns = require("fn"),
		SHA1 = require("SHA1"),
		date = require("DATE"),
		cookie = require("COOKIE"),
		loginQQ = false,
		from = fns.HTMLStr(http.get("f"));
	
	if ( connect === true ){
		var code = fns.HTMLStr(http.get("code")),
			pid = fns.HTMLStr(http.get("pid")),
			pmark = fns.HTMLStr(http.get("pmark")),
			cacheGlobal = cache.load("global"),
			website = cacheGlobal.website;
			
		if ( pid.length > 0 && pmark.length > 0 && code.length > 0 ){
			var configCache = pluginCustom.configCache(pid);
			if ( configCache ){
				var token = oauth.token(configCache.appid, configCache.appkey, code, website);
				if ( token.success === true ){
					var openid = oauth.openid(token.data.access_token);
					if ( openid.success === true ){
						var info = oauth.getInfo(token.data.access_token, openid.data.openid, configCache.appid);
						if ( info.success === true ){
							var _openid = openid.data.openid,
								_uid = 0,
								_salt = fns.randoms(6),
								_hashkey = SHA1(_salt);
								
							dbo.trave({
								type: 3,
								conn: config.conn,
								sql: "Select * From blog_member Where qq_openid=" + _openid + " And oauth='qq'",
								callback: function( rs ){
									if ( rs.Bof || rs.Eof ){
										dbo.add({
											conn : config.conn,
											table : "blog_member",
											callback: function(){
												_uid = this("id").value;
											},
											data: {
												hashkey: _hashkey,
												isposter: false,
												photo: info.data.figureurl.split("/").slice(0, -1).join("/"),
												nickName: info.data.nickname,
												oauth: "qq",
												canlogin: true,
												logindate: date.format(new Date(), "y/m/d h:i:s"),
												loginip: fns.getIP(),
												salt: _salt,
												qq_token: token.data.access_token,
												qq_openid : openid.data.openid
											}
										});
									}else{
										_uid = rs("id").value;
										rs("hashkey") = _hashkey;
										rs("photo") = info.data.figureurl.split("/").slice(0, -1).join("/");
										rs("nickname") = info.data.nickname;
										rs("qq_token") = token.data.access_token;
										rs("logindate") = date.format(new Date(), "y/m/d h:i:s");
										rs("loginip") = fns.getIP();
										rs("salt") = _salt;
										rs.Update();
									}
								}
							});
							
							if ( _uid > 0 ){
								cookie.set(config.cookie + "_user", "id", _uid);
								cookie.set(config.cookie + "_user", "hashkey", _hashkey);
								cookie.set(config.cookie + "_user", "oauth", "qq");
								cookie.expire(config.cookie + "_user", 30 * 24 * 60 * 60 * 1000);
								loginQQ = true;
							}else{
								console.end("数据处理出错");
							}
						}else{
							console.end("获取用户资料时候出错");
						}
					}else{
						console.end("获取用户唯一指定的OpenID时候出错");
					}
				}else{
					console.end("获取Token时候出错");
				}
			}else{
				console.end("获取插件内部全局缓存数据出错");
			}
		}else{
			console.end("内部参数错误");
		}
	}else{
		console.end("连接数据库失败");
	}
	if ( loginQQ === true ){
		Response.Redirect(from);
	}
}catch(e){
	console.end(e.message);
}
CloseConnect();
%>