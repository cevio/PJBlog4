<%
define(function(require, exports, module){
	var cookie = require.async("COOKIE"),
		oauth = cookie.get(config.cookie + "_user", "oauth");
	
	if ( oauth && (oauth.length > 0) ){
		require.async("server/oAuth/" + oauth + "/status");
	}
	
});
%>