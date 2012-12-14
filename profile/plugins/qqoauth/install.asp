<%
define(function( require, exports, module ){
	var dbo = require("DBO"),
	connect = require("openDataBase");
	
	if ( connect === true ){
		try{
			config.conn.Execute("alter table blog_member add qq_token varchar(255)");
			config.conn.Execute("alter table blog_member add qq_openid varchar(255)");
		}catch(e){}
	}
});
%>