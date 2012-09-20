<!--#include file="../config.asp" -->
<%
	http.async(function( req ){
		var tmpConnection = require.async("openDataBase");
		
		if ( tmpConnection === true ){
			var dbo = require.async("DBO"),
				sha1 = require.async("SHA1"),
				fn = require.async("fn"),
				date = require.async("DATE"),
				password = req.form.password,
				ip = fn.getIP(),
				res = { success: false, error: "" };
			
			dbo.trave({
				type: 3,
				conn: config.conn,
				sql: "Select * From blog_global Where id=1",
				callback: function( Rs ){
					if ( sha1(password) === Rs("password").value ){
						res.success = true;
						Rs("loginip") = ip;
						Rs("logindate") = date.format(new Date(), "y-m-d h:i:s");
						Rs.Update();
						Session("admin") = true;
					}else{
						res.error = "密码错误，无法登入。";
					}
				}
			});
			
			return res;
		}else{
			return {
				success: false,
				error: "打开数据库失败"
			}
		}
	});
%>