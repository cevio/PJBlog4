<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta name="Description" content="<%=pageCustomParams.global.webdescription%>" />
    <meta name="Keywords" content="<%=pageCustomParams.global.webkeywords%>" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="Author" content="<%=pageCustomParams.global.nickname%> - <%=pageCustomParams.global.authoremail%>" />
    <link rel="stylesheet" href="<%=pageCustomParams.global.website + "/" + pageCustomParams.global.styleFolder%>/common.css" type="text/css" />
    <script language="javascript" src="<%=pageCustomParams.global.website + "/assets/js/core/sizzle.js"%>"> </script>
    <script language="javascript" src="<%=pageCustomParams.global.website + "/profile/handler/configure.js"%>"> </script>
    <title><%=pageCustomParams.global.seotitle%>_<%=pageCustomParams.global.title%></title>
</head>
<body>
	<div class="pj-zone">
        <div class="pj-wrapper">
            <div class="pj-top">
                <div class="pj-title">
                    <a href="default.asp"><%=pageCustomParams.global.title%></a>
                    <div class="pj-info"><%=pageCustomParams.global.description%></div>
                </div>
                <div class="pj-search">
                	<form action="search.asp" method="post" style="margin:0; padding:0;">
                    	<div class="pj-search-box fn-clear">
                        	<div class="pj-search-box-input"><input type="text" name="keyword" value="" placeholder="请输入搜索关键字..." /></div>
                            <div class="pj-search-box-btn"><input type="submit" value="搜索" /></div>
                        </div>
                    </form>
                </div>
                <div class="pj-nav">
                	<%var cache_category = pageCustomParams.categorys;if ( cache_category.length > 0 ){%>
                                <ul class="nav-ul-one">
                   		<%for ( var i = 0 ; i < cache_category.length ; i++ ){%>
                    				<li class="nav-li-one"><a href="<%=cache_category[i].link%>" title="<%=cache_category[i].info%>"><%=cache_category[i].name%></a>
                                        <%var childrens = cache_category[i].childrens;if ( childrens.length > 0 ){%>
                                        	<ul class="nav-ul-two">
                                        <%for ( var j = 0 ; j < childrens.length ; j++ ){%>
                                        		<li class="nav-li-two"><a href="<%=childrens[j].link%>" title="<%=childrens[j].info%>"><%=childrens[j].name%></a></li>
                                        <%}%>
                                            </ul>
                                        <%}%>
                                    </li>
                    	<%}%>
                                </ul>
                    <%};%>
                </div>
            </div>
        </div>
    </div>