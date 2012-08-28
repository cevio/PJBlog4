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
				openText, info;
				
				tokenJSON = oAuth.qq.token(APPID, APPKEY, code, WEBSITE);
				
				if ( tokenJSON.success === true ){
					openText = oAuth.qq.openid(tokenJSON.data.access_token);
					
					if ( openText.success === true ){
						info = oAuth.qq.getInfo(tokenJSON.data.access_token, openText.data.openid, APPID);
						
						if ( info.success === true ){
							return '<img src="' + info.data.figureurl + '" /> ' + info.data.nickname + ' welcome!';
						}else{
							return errorOut(info);
						}
						
					}else{
						return errorOut(openText);
					}
					
				}else{
					return errorOut(tokenJSON);
				}
		}
		
		function errorOut(err){
			return 'error <' + err.error + '>: ' + err.msg;
		}
			
		switch ( type ){
			case "qq" : ResponseText = oAuth_qq(); break;
			case "sina" : ResponseText = oAuth_sina(); break;
			default : ResponseText = custom();
		}
		
		return ResponseText;
	});
%>