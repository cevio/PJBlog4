<%
;define(function(){
	var stream = require("STREAM");
	function RePairConfigText(){
		var dot = "%";
		var text = '<' + dot + '\n;(function(){\nconfig.base="' + config.base + '";config.appName="' + config.appName + '";config.cacheFileNamePixer="' + config.cacheFileNamePixer + '";config.access="' + config.access + '";config.cookie="' + config.cookie + '";\n})();\n' + dot + '>';
		stream.save(text, "profile/handler/config.asp");
	}
	RePairConfigText();
});
%>