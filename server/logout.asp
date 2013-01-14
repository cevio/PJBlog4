<!--#include file="../config.asp" -->
<%
require(["COOKIE"], function(cookie){
	cookie.clear(config.cookie + "_user");
	CloseConnect();
	Response.Redirect(Request.ServerVariables("Http_Referer"));
});
%>