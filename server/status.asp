<%
define(["openDataBase"], function(require, exports, module){
	var cookie = require.async("COOKIE"),
		dbo = require.async("DBO"),
		id = cookie.get(config.cookie + "user", "id"),
		hashkey = cookie.get(config.cookie + "user", "hashkey");
	
	if ( config.conn === null ){
		dbo.select({
			sql : "Select * From blog_member Where id=" + id,
			callback : function(rs, conn){
				if ( !(rs.Bof || rs.Eof) ){
					
				}
			}
		});
	}else{
		config.push("Open DataBase Error!");
	}
	
});
%>