<!--#include file="config.asp" -->
<%
http.async(function(req){
	var a = require("DBO");
	return a.add("1");
});
%>