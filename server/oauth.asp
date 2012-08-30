<!--#include file="../config.asp" -->
<%
	http.write(function(req){
		var type = req.query.type,
			code = req.query.code,
			ResponseText;
			
		try{
			var oauth = require.async("server/oAuth/" + type + "/logic"),
				ret = oauth(code);
				
			if ( ret.success === true ){
				ResponseText = '<img src="' + ret.photo + '" />' + ret.nickname + ' 登入成功.';
			}else{
				ResponseText = ret.error + "(7)";
			}
		}catch(e){
			ResponseText = e.message + "(6)";
		}
		
		return ResponseText;
	});
%>