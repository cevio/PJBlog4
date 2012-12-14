<%
define(function( require, exports, module ){
	var cache = require.async("cache");
	var proxyCustom = require.async("pluginCustom");
	
	exports.url = function(){
		var pluginConfigParams = proxyCustom.configCache(this.id),
			cacheGlobal = cache.load("global"),
			thisURL = "http://" + Request.ServerVariables("Http_Host") + Request.ServerVariables("Url") + "?" + Request.ServerVariables("Query_String");

		return 'https://graph.qq.com/oauth2.0/authorize?response_type=code&client_id=' + pluginConfigParams.appid + '&redirect_uri=' + escape(cacheGlobal.website + '/profile/plugins/' + this.folder + '/callback.asp?pid=' + this.id + '&pmark=' + this.mark + '&f=' + thisURL);
	}
});
%>