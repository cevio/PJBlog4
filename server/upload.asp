<!--#include file="../config.asp" -->
<%
require(["UPLOAD"], function(upload){
	var route = upload({});
	console.log(JSON.stringify(route));
	
});
%>