<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
<meta name="Description" content="<%=config.params.webdescription%>" />
<meta name="Keywords" content="<%=config.params.webkeywords%>" />
<meta name="Author" content="<%=config.params.nickname%> - <%=config.params.authoremail%>" />
<link rel="stylesheet" href="<%=config.params.website + "/" + config.params.styleFolder%>/default.css" type="text/css" />
<script language="javascript" src="<%=config.params.website + "/assets/js/core/sizzle.js"%>"></script>
<title><%=config.params.seotitle%></title>
</head>

<body>
<div class="container">
<div class="header">
    <div class="title">
        <h1><%=config.params.title%> - <%=config.params.description%></h1>
    </div>
    <div class="navigation">
    	<%
			LoadCacheModule("cache_category", function( cache_category ){
				for ( var i in cache_category ){
					if ( cache_category[i].cate_outlink === true ){
		%>
        	<a href="<%=cache_category[i].cate_outlinktext%>" title="<%=cache_category[i].cate_info%>"><%=cache_category[i].cate_name%></a>
        <%
					}else{
		%>
        	<a href="default.asp?c=<%=cache_category[i].id%>" title="<%=cache_category[i].cate_info%>"><%=cache_category[i].cate_name%></a>
        <%			
					}
				}
			});
		%>
        <div class="clearer"><span></span></div>
    </div>
</div>
