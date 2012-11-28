// JavaScript Document
define(function(){
	if ( config.plugin.folder !== undefined ){
		require.async(config.plugin.folder + "/configure", function( database ){
			if ( database.init ){
				database.init();
			}
		});
	}
});