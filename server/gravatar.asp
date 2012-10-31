<%
define(function( require, exports, module ){
	var cache = require("cache"),
		sys_cache_global = cache.load("global"),
		MD5 = require("MD5");
	
	var S, R, D;
	
	S = sys_cache_global[0][22];
	R = sys_cache_global[0][23];
	D = sys_cache_global[0][24];
	
	return function( mail ){
		return "http://www.gravatar.com/avatar/" + MD5(mail).toLowerCase() + "?s=" + S + "&r=" + R + "&d=" + D;
	}
});
%>