<%
define(function(require, exports, module){
	exports.randoms = function(l){
		var Str = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", 
			tmp = "";
			
		for( var i = 0 ; i < l ; i++ ) { 
			tmp += Str.charAt( Math.ceil(Math.random() * 100000000) % Str.length ); 
		}
		
		return tmp;
	}
	
	exports.localSite = function(){
		return "http://" + Request.ServerVariables("Http_Host") + Request.ServerVariables("Url") + "?" + Request.ServerVariables("Query_String");
	}
	
	exports.getIP = function(){
		var userip = String(Request.ServerVariables("HTTP_X_FORWARDED_FOR")).toLowerCase();
		if ( userip == "undefined" ) userip = String(Request.ServerVariables("REMOTE_ADDR")).toLowerCase();
		return userip;
	}
});
%>