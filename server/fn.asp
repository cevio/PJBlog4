<%
define(function(require, exports, module){
	exports.randoms = function(n){
		var chars = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'],
			res = "";
			
		for(var i = 0; i < n ; i ++) {
			var id = Math.ceil(Math.random() * (chars.length - 1));
			res += chars[id];
		}
			
		return res;
	}
	
	exports.localSite = function(){
		return "http://" + Request.ServerVariables("Http_Host") + Request.ServerVariables("Url") + "?" + Request.ServerVariables("Query_String");
	}
	
	exports.getIP = function(){
		var userip = String(Request.ServerVariables("HTTP_X_FORWARDED_FOR")).toLowerCase();
		if ( userip == "undefined" ) userip = String(Request.ServerVariables("REMOTE_ADDR")).toLowerCase();
		return userip;
	}
	
	exports.SQLStr = function( str ){
		if ( !str ){
			return "";
		}
		try{
			str = str + "";
		}catch(e){
			return "";
		}
		var reglist = [
			[/(w)(here)/ig, "$1h&#101;re"],
			[/(s)(elect)/ig, "$1el&#101;ct"],
			[/(i)(nsert)/ig, "$1ns&#101;rt"],
			[/(c)(reate)/ig, "$1r&#101;ate"],
			[/(d)(rop)/ig, "$1ro&#112;"],
			[/(a)(lter)/ig, "$1lt&#101;r"],
			[/(d)(elete)/ig, "$1el&#101;te"],
			[/(u)(pdate)/ig, "$1p&#100;ate"],
			[/(\s)(or)/ig, "$1o&#114;"],
			[/(java)(script)/ig, "$1scri&#112;t"],
			[/(j)(script)/ig, "$1scri&#112;t"],
			[/(vb)(script)/ig, "$1scri&#112;t"],
			[/(expression)/ig, "e&#173;pression"],
			[/(c)(ookie)/ig, "&#99;ookie"],
			[/(Object)/ig, "&#79;bject"],
			[/(script)/ig, "scri&#112;t"]
		];
		
		for ( var i = 0 ; i < reglist.length ; i++ ){
			str = str.replace( reglist[i][0], reglist[i][1] );
		}
		
		return str;
	}
	
	exports.unSQLStr = function( str ){
		if ( !str ){
			return "";
		}
		try{
			str = str + "";
		}catch(e){
			return "";
		}
		var reglist = [
			[/(w)(h&#101;re)/ig, "$1here"],
			[/(s)(el&#101;ct)/ig, "$1elect"],
			[/(i)(ns&#101;rt)/ig, "$1nsert"],
			[/(c)(r&#101;ate)/ig, "$1reate"],
			[/(d)(ro&#112;)/ig, "$1rop"],
			[/(a)(lt&#101;r)/ig, "$1lter"],
			[/(d)(el&#101;te)/ig, "$1elete"],
			[/(u)(p&#100;ate)/ig, "$1pdate"],
			[/(\s)(o&#114;)/ig, "$1or"],
			[/(java)(scri&#112;t)/ig, "$1script"],
			[/(j)(scri&#112;t)/ig, "$1script"],
			[/(vb)(scri&#112;t)/ig, "$1script"],
			[/(e&#173;pression)/ig, "expression"],
			[/&#99;(ookie)/ig, "c$1"],
			[/&#79;(bject)/ig, "O$1"],
			[/(scri)&#112;(t)/ig, "$1p$2"]
		];
		
		for ( var i = 0 ; i < reglist.length ; i++ ){
			str = str.replace( reglist[i][0], reglist[i][1] );
		}
		
		return str;
	}
	
	exports.HTMLStr = function( str ){
		if ( !str ){
			return "";
		}
		try{
			str = str + "";
		}catch(e){
			return "";
		}
		var reglist = [
			[/\</g, "&#60;"],
			[/\>/g, "&#62;"],
			[/\'/g, "&#39;"],
			[/\"/g, "&#34;"]
		];
		
		for ( var i = 0 ; i < reglist.length ; i++ ){
			str = str.replace( reglist[i][0], reglist[i][1] );
		}
		
		return str;
	}
	
	exports.removeHTML = function(html){
		if ( !html ){
			return "";
		}
		try{
			html = html + "";
		}catch(e){
			return "";
		}
		html = html.replace(/\<(\w+?)([^\>]+)?\>([\s\S]+?)\<\/\1\>/g, "$3")
				   .replace(/<(\w+?)(\s([^\/]+)?)?\/>/g, "");
				
		if ( /\<(\w+?)([^\>]+)?\>[\s\S]+?\<\/\1\>/g.test(html) || /<(\w+?)(\s([^\/]+)?)?\/>/g.test(html) ){
			html = this.removeHTML(html);
		}
		
		return html;
	}
	
	exports.unHTMLStr = function( str ){
		if ( !str ){
			return "";
		}
		try{
			str = str + "";
		}catch(e){
			return "";
		}
		var reglist = [
			[/\&\#60\;/g, "<"],
			[/\&\#62\;/g, ">"],
			[/\&\#39\;/g, "'"],
			[/\&\#34\;/g, '"']
		];
		
		for ( var i = 0 ; i < reglist.length ; i++ ){
			str = str.replace( reglist[i][0], reglist[i][1] );
		}
		
		return str;
	}
	
	exports.textareaStr = function( str ){
		if ( !str ){
			return "";
		}
		try{
			str = str + "";
		}catch(e){
			return "";
		}
		var reglist = [
			[/textarea/ig, "t&#101;xtarea"]
		];
		
		for ( var i = 0 ; i < reglist.length ; i++ ){
			str = str.replace( reglist[i][0], reglist[i][1] );
		}
		
		return str;
	}
	
	exports.unTextareaStr = function( str ){
		if ( !str ){
			return "";
		}
		try{
			str = str + "";
		}catch(e){
			return "";
		}
		var reglist = [
			[/t&#101;xtarea/ig, "textarea"]
		];
		
		for ( var i = 0 ; i < reglist.length ; i++ ){
			str = str.replace( reglist[i][0], reglist[i][1] );
		}
		
		return str;
	}
	
	/*
	 * s: 字符串
	 * n: 切割字数
	 * c: 是否使用中文编排
	 * r: 省略的符号
	 */
	exports.cutStr = function( s, n, c, r ){
		if ( !s ){
			return "";
		}
		try{
			s = s + "";
		}catch(e){
			return "";
		}
		var _s = "", j = 0;
		for ( var i = 0 ; i < s.length ; i++ ){
			var t = s.charAt(i);
				if ( c ){
					var g = /[^\u4E00-\u9FA5]/g.test(t);
						if ( g && ( j + 1 <= n ) ){
							j++;
							_s += t;
						}else{
							if ( j + 2 <= n ){ 
								j = j + 2; 
								_s += t;
							}else{ break; }
						}
				}else{
					if ( j + 1 <= n ){ 
						j++; 
						_s += t; 
					}else{ break; }
				}
		}
		if ( _s != s ){ _s += (r || "...") };
		return _s;
	}
	
	exports.pageAnalyze = function(currentPage, totalPages, perPageCount){
		if ( perPageCount === undefined ){ perPageCount = 9; }
		if ( perPageCount > totalPages ){ perPageCount = totalPages; }
		
		var isEven = perPageCount % 2 === 0 ? false : true,
			o = Math.floor(perPageCount / 2),
			l = isEven ? o : o - 1,
			r = o;
		
		var _l = currentPage - l,
			_r = currentPage + r;
		
		if ( _l < 1 ){
			_l = 1;
			_r = _l + perPageCount - 1;
			if ( _r > totalPages ){
				_r = totalPages;
			}
		}else if ( _r > totalPages ){
			_r = totalPages;
			_l = _r - perPageCount + 1;
			if ( _l < 1 ){
				_l = 1;
			}
		}
		
		return {
			prev : currentPage - 1 < 1 ? 1 : currentPage - 1,
			next : currentPage + 1 > totalPages ? totalPages : currentPage + 1,
			from : _l,
			to : _r,
			current : currentPage
		}
	}
	
	exports.pageOut = function(options, callback){
		for ( var i = options.from ; i <= options.to ; i++ ){
			if ( typeof callback === "function" ){
				callback(i, i === options.current);
			}
		}
	}
	
	exports.pageFormTo = function( page, perpage, total ){
		var leftid = ( page - 1 ) * perpage + 1,
			rightid = page * perpage;
			
		if ( leftid > total ){
			leftid = total;
			rightid = total;
		}else{
			if ( leftid < 1 ){
				leftid = 1;
			}
			if ( rightid > total ){
				rightid = total;
			}
		}
		
		leftid--; rightid--;
		
		return {
			from: leftid,
			to: rightid
		}
	}
	
	exports.getUserInfo = function(id, name, mail){
		var userInfo = {},
			cache = require.async("cache"),
			global = cache.load("global"),
			GRA = require.async("gra");
			
		id = Number(id);
		
		if ( id === -1 ){
			if ( config.user.id === -1 ){
				userInfo.photo = config.user.photo;
				userInfo.name = config.user.name;
				userInfo.website = config.user.website;
			}else{
				userInfo.photo = GRA(global.authoremail);
				userInfo.name = global.nickname;
				userInfo.website = global.website;
			}
			userInfo.poster = true;
			userInfo.oauth = "system";
			userInfo.login = config.user.login;
			userInfo.logindate = "";
			userInfo.loginip = "";
		}
		else if ( id === 0 ){
			userInfo.photo = GRA(mail);
			userInfo.name = name;
			userInfo.poster = false;
			userInfo.oauth = "";
			userInfo.login = false;
			userInfo.logindate = "";
			userInfo.loginip = "";
			userInfo.website = "";
		}
		else{
			var userCache = cache.load("user", id),
				userInfo = {};
				
			if (userCache.length === 1){
				userInfo.photo = userCache[0][0];
				userInfo.name = userCache[0][1];
				userInfo.poster = userCache[0][2];
				userInfo.oauth = userCache[0][3];
				userInfo.login = userCache[0][4];
				userInfo.logindate = userCache[0][5];
				userInfo.loginip = userCache[0][6];
				userInfo.loginip = userCache[0][7];
			}
		}
		
		return userInfo;
	}
});
%>