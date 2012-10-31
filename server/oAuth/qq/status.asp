<%
define(["openDataBase"], function(require, exports, module){
	var cookie = require.async("COOKIE"),
		id = cookie.get(config.cookie + "_user", "id"),
		token = cookie.get(config.cookie + "_user", "token"),
		dbo = require.async("DBO");
	
	if ( config.conn !== null ){
		dbo.trave({
			conn : config.conn,
			sql : "Select * From blog_member Where qq_openid='" + id + "'",
			callback : function(rs){
				if ( !(rs.Bof || rs.Eof) ){
					if ( token === rs("qq_token").value ){
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