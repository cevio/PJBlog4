<%
define(function(require, exports, module){
	exports.randoms = function(l){
		function S4() {
		   return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
		};
		
		var tmp = "";
		
		for ( var i = 0 ; i < l ; i++ ){
			tmp += S4();
		}
		
		return tmp;
	}
});
%>