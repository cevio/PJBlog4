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
				ResponseText = ret.error + "(7)";
			}
		}catch(e){
			ResponseText = e.message + "(6)";
		}
		
		return ResponseText;
	});
%>