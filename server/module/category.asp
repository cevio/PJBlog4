<%
define(function( require, exports, module ){
	var categoryCache = pageCustomParams.tempModules.cache.load("category");
		
		pageCustomParams.categorys = categoryCache.arrays;
	
	return categoryCache.list;
});
%>