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
});
%>