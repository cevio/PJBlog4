<%
define(function(require, exports, module){
	exports.url = function(){
		return 'https://graph.qq.com/oauth2.0/authorize?response_type=code&client_id=' + pageCustomParams.global.qq_appid + '&redirect_uri=' + escape(pageCustomParams.global.website + '/server/oauth.asp?type=qq&dir=' + pageCustomParams.global.website);
	}
	
	exports.token = function(APPID, APPKEY, code, website){
		var qqObject = require.async("XMLHTTP"), 
				ret,
				url = 'https://graph.qq.com/oauth2.0/token',
				data = {
					grant_type : "authorization_code", 
					client_id : APPID,
					client_secret : APPKEY,
					code : code,
					state : ( new Date().getTime() ),
					redirect_uri : escape(website + '/server/oauth.asp?type=qq')
				}
			
		qqObject.get(url, data, function(text){ ret = text; });

		if ( qqObject.isJSONP(ret, "callback") ){
			var t = qqObject.parseJSONP(ret, "callback");
			ret = {
				success : false,
				error : t.error,
				msg : t.error_description
			}
		}else{
			ret = {
				success : true,
				data : qqObject.unParam(ret)
			};
		}
		
		return ret;
	}
	
	exports.openid = function(token){
		var qqObject = require.async("XMLHTTP"),
				url = "https://graph.qq.com/oauth2.0/me",
				data = {
					access_token : token
				},
				ret;
			
		qqObject.get(url, data, function(text){ ret = qqObject.compentJSON(text, "callback"); });
		
		if ( ret.error === undefined ){
			ret = {
				success : true,
				data : ret
			}
		}else{
			ret.success = false;
			ret.msg = ret.error_description;
		}
		
		return ret;
	}
	
	exports.getInfo = function(token, openid, APPID){
		var qqObject = require.async("XMLHTTP"),
				url = "https://graph.qq.com/user/get_user_info",
				data = {
					access_token : token,
					oauth_consumer_key : APPID,
					openid : openid,
					format : "json"
				},
				ret;
				
		qqObject.get(url, data, function(text){ ret = qqObject.compentJSON(text); });
		
		if ( ret.ret === 0 ){
			ret = {
				success : true,
				data : ret
			}
		}else{
			ret = {
				success : false,
				error : ret.ret,
				msg : ret.msg
			}
		}
		
		return ret;
	}
	
	exports.share = function( token, openid, appid, title, fromurl, imageurl ){
		var qqObject = require.async("XMLHTTP"),
			url = "https://graph.qq.com/share/add_share",
			data = {
				access_token: token,
				oauth_consumer_key: appid,
				openid: openid,
				title: encodeURIComponent(title),
				images: encodeURIComponent(imageurl),
				url: encodeURIComponent(url),
				site: "",
				fromurl: fromurl,
				format: "json"
			},
			ret;
			
		qqObject.post(url, data, function(text){
			ret = qqObject.compentJSON(text);
		});
		
		if ( ret.ret === 0 ){
			ret = {
				success : true,
				data : ret
			}
		}else{
			ret = {
				success : false,
				error : ret.ret,
				msg : ret.msg
			}
		}
		
		return ret;
	}
});
%>