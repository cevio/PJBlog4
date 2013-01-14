<%
define(function( require, exports, module ){
	var cache = require("cache"),
		sys_cache_global = cache.load("global"),
		MD5 = require("MD5");
	
	var S, R, D;
	
	S = sys_cache_global.gravatarS;
	R = sys_cache_global.gravatarR;
	D = sys_cache_global.gravatarD;
	
	return function( mail ){
		return "http://www.gravatar.com/avatar/" + MD5(mail).toLowerCase() + "?s=" + S + "&r=" + R + "&d=" + escape(D);
	}
});
%>