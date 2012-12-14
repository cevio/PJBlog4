<%
define(function( require, exports, module ){
	exports.init = function(){
		var dbo = require.async("DBO"),
			connect = require.async("openDataBase");
		
		if ( connect === true ){
			try{
				config.conn.Execute("alter table blog_member add qq_token varchar(255)");
				config.conn.Execute("alter table blog_member add qq_openid varchar(255)");
				this.sap.addProxy("system.member.list.photo", function(rets, oauth, photo){
					rets[oauth] = photo + "/50";
				});
			}catch(e){}
		}
	}
});
%>