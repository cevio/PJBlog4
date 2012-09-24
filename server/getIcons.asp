<%
define(function(require, exports, module){
	var fso = require.async("FSO");
	return fso.collect("profile/icons");
});
%>