<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta name="Description" content="<%=config.params.webdescription%>" />
<meta name="Keywords" content="<%=config.params.webkeywords%>" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="Author" content="<%=config.params.nickname%> - <%=config.params.authoremail%>" />
<link rel="stylesheet" href="<%=config.params.website + "/" + config.params.styleFolder%>/default.css" type="text/css" />
<title><%=config.params.seotitle%></title>
</head>

<body>

<div class="container">

	<div class="navigation">

		<div class="title">
			<h1><%=config.params.title%></h1>
			<h2>- <%=config.params.description%> -</h2>
		</div>
		<%
			var cache_category = require("cache_category");
			for ( var cache_category_item in cache_category ){
				if ( cache_category[cache_category_item].cate_outlink === true ){
		%><a href="<%=cache_category[cache_category_item].cate_outlinktext%>" title="<%=cache_category[cache_category_item].cate_info%>"><%=cache_category[cache_category_item].cate_name%></a><%
				}else{
		%><a href="default.asp?c=<%=cache_category_item%>" title="<%=cache_category[cache_category_item].cate_info%>"><%=cache_category[cache_category_item].cate_name%></a><%		
				}
			}
		%>
		<div class="clearer"><span></span></div>

	</div>

	<div class="holder_top"></div>