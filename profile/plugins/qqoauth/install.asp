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
				this.sap.addProxy("assets.member.list.photo", function(rets, oauth, photo, size){
					rets[oauth] = photo + "/" + size;
				});
				this.sap.addProxy("response.login", function(rets, custom){
					var cmd = custom.loadPlugin("qqoauth");
					if ( cmd !== null ){
						var cache = require.async("cache"),
							oauth = require.async("profile/plugins/" + cmd.folder + "/oauth"),
							cacheConfigs = custom.configCache(cmd.id),
							cacheGlobals = cache.load("global");
						
						rets.push('<a href="' + oauth.url(cacheConfigs.appid, cacheGlobals.website) + '" target="_blank">腾讯账号登入<a>');
					}
				});
			}catch(e){}
		}
	}
});
%>