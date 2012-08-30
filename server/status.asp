<%
define(["openDataBase"], function(require, exports, module){
	var cookie = require.async("COOKIE"),
		dbo = require.async("DBO"),
		sha1 = require.async("SHA1"),
		id = cookie.get(config.cookie + "_user", "id"),
		hashkey = cookie.get(config.cookie + "_user", "hashkey"),
		token = cookie.get(config.cookie + "_user", "token");
	
	if ( config.conn === null ){
		if ( id && (id.length > 0) ){
			dbo.traverse({
				conn : config.conn,
				sql : "Select * From blog_member Where id=" + id,
				callback : function(rs, conn){
					if ( !(rs.Bof || rs.Eof) ){
						var hashkey = rs("hashkey").value,
							salt = rs("salt").value;
						
						if ( sha1(token + salt) === hashkey ){
							config.user.login = true;
						}
					}
				}
			});
		}
	}else{
		console.push("Open DataBase Error!");
	}
	
});
%>