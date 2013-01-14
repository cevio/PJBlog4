<%
define(function( require, exports, module ){
	exports.init = function(){
		var dbo = require.async("DBO"),
			connect = require.async("openDataBase");
		
		if ( connect === true ){
			try{
				config.conn.Execute("alter table blog_member add qq_token varchar(255)");
				config.conn.Execute("alter table blog_member add qq_openid varchar(255)");
				this.sap.addProxy("response.login", function(rets, custom){
					var cmd = custom.loadPlugin("qqoauth");
					if ( cmd !== null ){						
						rets.push('<a href="' + cmd.url() + '" target="_blank">腾讯账号登入<a>');
					}
				});
			}catch(e){}
		}
	}
});
%>