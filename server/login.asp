<!--#include file="../config.asp" -->
<%
	require("status")();
	http.async(function( req ){
		var dbo = require("DBO"),
			connecte = require("openDataBase"),
			fns = require("fn"),
			SHA1 = require("SHA1"),
			cookie = require("COOKIE");

		if ( connecte === true ){
			var username = fns.HTMLStr(fns.SQLStr(req.form.username)),
				password = fns.HTMLStr(fns.SQLStr(req.form.password)),
				salt = fns.randoms(6),
				rets = {},
				_hashkey;
			
			dbo.trave({
				type: 3,
				conn: config.conn,
				sql: "Select * From blog_global Where id=1",
				callback: function(rs){
					if ( rs("nickname").value === username ){
						if ( SHA1(password + rs("salt").value) === rs("hashkey").value ){
							rets.success = true;
							rs("salt") = salt;
							_hashkey = SHA1(password + salt);
							rs("hashkey") = _hashkey;
							rs.Update();
						}else{
							rets.success = false;
							rets.error = "密码错误";
						}
					}else{
						rets.success = false;
						rets.error = "未找到该用户";
					}
				}
			});
			
			if ( rets.success === true ){
				cookie.set(config.cookie + "_user", "id", -1);
				cookie.set(config.cookie + "_user", "hashkey", _hashkey);
				cookie.set(config.cookie + "_user", "oauth", "system")
				cookie.expire(config.cookie + "_user", 30 * 24 * 60 * 60 * 1000);
			}
			
			return rets;
		}else{
			return {
				success: false,
				error: "连接数据库失败"
			}
		}
	});
%>