// JavaScript Document
// set default params for sizzle
define(["assets/js/core/jQuery"], function(){
	
	// build upload module
	config("debug", true);
	config("base", "/");
	
	// map modules
	config.map("upload", "assets/js/upload");
	
	return true;
});