<%
;define(function(){
	var stream = require("STREAM"),
		fso = require("FSO");
	function RePairConfigText(){
		var dot = "%";
		var text = '<' + dot + '\n;(function(){\nconfig.base="' + config.base + '";config.appName="' + config.appName + '";config.cacheFileNamePixer="' + config.cacheFileNamePixer + '";config.access="' + config.access + '";config.cookie="' + config.cookie + '";\n})();\n' + dot + '>';
		stream.save(text, "profile/handler/config.asp");
	}
	
	function RePairSQL(){
		var dbo = require("DBO"),
			connecte = require("openDataBase");
			if ( connecte === true ){
				config.conn.Execute("Insert into [blog_Notdownload](blog_Nodownload) values(0x3C25)");
			}
	}
	RePairConfigText();
	RePairSQL();
});
%>