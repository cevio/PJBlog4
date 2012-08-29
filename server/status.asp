<%
define(function(require, exports, module){
	var cookie = require("COOKIE"),
		oauth = cookie.get(config.cookie + "user", "oauth");
});
%>