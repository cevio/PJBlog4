<!--#include file="config.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta property="qc:admins" content="04426474743633" />
<title>无标题文档</title>
</head>

<body>
<%
var url = null, d;

	require(["server/oAuth/qq/oauth", "COOKIE"], function(oauth, cookie){
		url = oauth.url("100299901", "http://lols.cc/server/oauth.asp?type=qq&times=" + (new Date().getTime()));
		//cookie.set("a", "b", "e");
		//cookie.expire("a", 30 * 1000);
		d = cookie.get("a", "b");
	});
%>
<a href="<%=url%>">登入</a><%=d%>
</body>
</html>
