<!--#include file="../config.asp" -->
<%
require(["COOKIE"], function(cookie){
	cookie.clear(config.cookie + "_user");
	cookie.set(config.cookie + "_login", "false");
	Session("admin") = false;
	Response.Redirect(Request.ServerVariables("Http_Referer"));
});
%>