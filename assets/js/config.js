// JavaScript Document
// set default params for sizzle
define(["assets/js/core/jQuery"], function(){
	
	// build upload module
	config("debug", true);
	config("base", "/");
	
	// map modules
	config.map("upload", "assets/js/upload");
	config.map("form", "assets/js/core/form");
	
	config.ajaxUrl = { assets: {}, server: {} }
	
	config.ajaxUrl.server.getCateInfo = "server/category.asp?j=getcateinfo";
	
	return {
		status : true,
		load : function( args ){
			require.async(args, function( customs ){
				if ( customs.init !== undefined ){
					customs.init();
				}
			});
		}
	};
});