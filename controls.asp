<!--#include file="config.asp" -->
<%
	var method = http.form("method"),
		files = http.get("files"),
		fso = require("FSO");
	
	if ( files.length === 0 ){
		files = "loading";
	}
		
	function containerHeader(){
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>PJBlog4后台管理</title>
<link rel="stylesheet" href="assetss/bootstrap/css/bootstrap.min.css" media="all" />
<link rel="stylesheet" href="assetss/bootstrap/css/bootstrap-responsive.min.css" media="all" />
<link rel="stylesheet" href="assetss/common/css/custom.css" media="all" />
<script language="javascript" src="assetss/common/js/sysmo/sizzle.js"></script>
<script language="javascript" src="assetss/common/js/configure.js"></script>
</head>
<body>
<div id="metro-wrapper">
    <div id="metro-outer">
    	<div class="metro-inner">
<%
	}
	
	function containerBodyer(){
		if ( fso.exsit("system/pages/" + files + ".asp") ){
			include("system/pages/" + files + ".asp")
		}else{
			include("system/pages/404.asp");
		}
	}
	
	function containerFooter(){
%>
	</div></div>
    <div id="metro-start" class="clearfix">
        <div class="metro-start-btn"><a href="#" class="metro-ui-start">Start</a></div>
        <div class="metro-start-login"></div>
    </div>
</div>
<div class="metro-url-loadbar">
	<div class="progress progress-striped active">
      <div class="bar" style="width: 0%;"></div>
    </div>
</div>
<script language="javascript">
require(['assetss/common/js/config'], function( configure ){ 
	configure.load("<%=files.length === 0 ? "loading" : files%>");
});
</script>
</body>
</html>
<%
	}
	
	if ( method && method === "ajax" ){
		containerBodyer();
	}else{
		containerHeader();
		containerBodyer();
		containerFooter();
	}
%>
