<!--#include file="../config.asp" -->
<%
	http.write(function(req){
		var type = req.query.type,
			code = req.query.code,
			ResponseText;
			
		function oAuth_qq(){
			var oAuth = require.async("OAUTH"),
				APPID = "100299901",
				APPKEY = "d6f6e47dae337b2c742e82b46735ea6d",
				WEBSITE = "http://lols.cc",
				tokenJSON = oAuth.qq.token(APPID, APPKEY, code, WEBSITE),
				openText = oAuth.qq.openid(tokenJSON.access_token);
			
			var info = oAuth.qq.getInfo(tokenJSON.access_token, openText.openid, APPID);
			
			return '<img src="' + info.figureurl + '" /> ' + info.nickname + ' 欢迎登入本站。';
		}
			
		switch ( type ){
			case "qq" : ResponseText = oAuth_qq(); break;
			case "sina" : ResponseText = oAuth_sina(); break;
			default : ResponseText = custom();
		}
		
		return ResponseText;
	});
%>