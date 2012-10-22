<!--#include file="config.asp" -->
<%
	require("status");
	require("cache_global");
	
	var pageArticleCustomParams = {};
	
	pageArticleCustomParams.page = http.get("page");
	if ( pageArticleCustomParams.page.length === 0 ){ 
		pageArticleCustomParams.page = 1; 
	}else{
		pageArticleCustomParams.page = Number(pageArticleCustomParams.page);
		if ( pageArticleCustomParams.page < 1 ){
			pageArticleCustomParams.page = 1;
		}
	}
	
	pageArticleCustomParams.id = http.get("id");
	if ( pageArticleCustomParams.id.length === 0 ){
		pageArticleCustomParams.id = 0;
	}else{
		pageArticleCustomParams.id = Number(pageArticleCustomParams.id);
	}
	
	if ( pageArticleCustomParams.id === 0 ){
		console.log("日志ID错误");
	}
	
	include("profile/themes/" + config.params.theme + "/article.asp");
	
	CloseConnect();
%>