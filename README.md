PJBlog4
=======

PJBLOG4轻博客系统

---------------
require("status");

if ( config.user.login === true ){
	console.log('您已登入 <a href="server/logout.asp">退出登入</a>');
}else{
	var oauth = require("server/oAuth/qq/oauth"),
		fn = require("fn");
		
	console.log('<a href="' + oauth.url("100299901", "http://lols.cc/server/oauth.asp?type=qq&dir=" + escape( fn.localSite() )) + '">登入</a>');
}

//require(["XML"], function(xml){
//	var _object = xml.load("1.xml");
//	var x = xml("t c", _object.root, _object.object);
//	
//	x.first().create("evio").html("<span>evio is good</span>");
//
//	x.save("2.xml");
//
////	for ( var i = 0 ; i < x.length ; i++ ){
////		console.push(xml.type(x[i]) + "<br />");
////	}
//	//console.debug();
//});

require(["PACKAGE"], function(package){
//	package.merge(".", "3.xml", function(name){
//		return name.replace(/^\.\//, "");
//	});
	package.separate("3.xml", "test");
});