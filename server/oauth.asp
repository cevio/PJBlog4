<!--#include file="../config.asp" -->
<%
	http.write(function(req){
		var type = req.query.type,
			code = req.query.code,
			dirs = req.query.dir,
			ResponseText;
			
		try{
			var oauth = require.async("server/oAuth/" + type + "/logic"),
				ret = oauth(code);
				
			if ( ret.success === true ){
				Response.Redirect(unescape(dirs));
			}else{
				ResponseText = ret.error;
			}
		}catch(e){
			ResponseText = e.message;
		}
		
		return ResponseText;
	});
%>