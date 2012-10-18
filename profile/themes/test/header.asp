<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta name="Description" content="<%=config.params.webdescription%>" />
<meta name="Keywords" content="<%=config.params.webkeywords%>" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="Distribution" content="Global" />
<meta name="Author" content="<%=config.params.nickname%> - <%=config.params.authoremail%>" />
<meta name="Robots" content="index,follow" />
<link rel="stylesheet" href="<%=config.params.website + "/" + config.params.styleFolder%>/images/Envision.css" type="text/css" />
<title><%=config.params.seotitle%></title>
</head>

<body>
<!-- wrap starts here -->
<div id="wrap"> 
    
    <!--header -->
    <div id="header">
        <h1 id="logo-text"><a href="<%=config.params.website%>"><%=config.params.title%></a></h1>
        <p id="slogan"><%=config.params.description%></p>
        <div id="header-links">
            <p> <a href="index.html">Home</a><!-- | 
				<a href="index.html">Contact</a> | 
				<a href="index.html">Site Map</a>--> 
            </p>
        </div>
    </div>
    
    <!-- menu -->
    <div  id="menu">
        <ul>
        	<%
				var cache_category = require("cache_category");
				
				(function(){
					for ( var id in cache_category ){
						if ( cache_category[id].cate_outlink === true ){
			%>
            			<li><a href="<%=cache_category[id].cate_outlinktext%>" title="<%=cache_category[id].cate_info%>"><%=cache_category[id].cate_name%></a></li>
            <%			
						}else{
			%>
            			<li><a href="default.asp?c=<%=id%>" title="<%=cache_category[id].cate_info%>"><%=cache_category[id].cate_name%></a></li>
            <%		
						}
					}
				})();
			%>
        </ul>
    </div>	