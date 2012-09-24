// JavaScript Document
// set default params for sizzle
define(["assets/js/core/jQuery"], function(){
	
	// build upload module
	config("debug", true);
	config("base", "/");
	
	// map modules
	config.map("upload", "assets/js/upload");
	config.map("form", "assets/js/core/form");
	config.map("tpl-category", "assets/js/tpl/tpl-category");
	config.map("overlay", "assets/js/core/overlay");
	
	config.ajaxUrl = { assets: {}, server: {} }
	
	config.ajaxUrl.server.getCateInfo = "server/category.asp?j=getcateinfo";
	config.ajaxUrl.server.updateCate = "server/category.asp?j=updatecate";
	config.ajaxUrl.server.addCate = "server/category.asp?j=addcates";
	config.ajaxUrl.server.destoryCate = "server/category.asp?j=destorycates";
	config.ajaxUrl.server.iconList = "server/category.asp?j=iconlist";
	
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