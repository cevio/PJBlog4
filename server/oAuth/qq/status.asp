<%
define(["openDataBase"], function(require, exports, module){
	var cookie = require.async("COOKIE"),
		id = cookie.get(config.cookie + "_user", "id"),
		token = cookie.get(config.cookie + "_user", "hashkey"),
		dbo = require.async("DBO"),
		SHA1 = require.async("SHA1");

	if ( config.conn !== null ){
		dbo.trave({
			conn : config.conn,
			sql : "Select * From blog_member Where id=" + id,
			callback : function(rs){
				if ( !(rs.Bof || rs.Eof) ){
					if ( token === SHA1(rs("hashkey").value) ){
						config.user.login = true;
						config.user.id = rs("id").value;
						cookie.set(config.cookie + "_login", "true");
					}else{
						cookie.clear(config.cookie + "_user");
						cookie.set(config.cookie + "_login", "false");
					}
				}
			}
		});
	}
});
%>