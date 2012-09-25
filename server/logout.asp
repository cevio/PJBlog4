<!--#include file="../config.asp" -->
<%
require(["COOKIE"], function(cookie){
	cookie.clear(config.cookie + "_user");
	Session("admin") = false;
	Response.Redirect(Request.ServerVariables("Http_Referer"));
});
%>