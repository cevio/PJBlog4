<%
define(function(require, exports, module){
	exports.init = function(){
		var dbo = require("DBO"),
		connect = require("openDataBase");
		
		if ( connect === true ){
			try{
				config.conn.Execute("alter table blog_member drop qq_token");
				config.conn.Execute("alter table blog_member drop qq_openid");
				this.sap.destory("response.login");
			}catch(e){}
		}
	}
});
%>