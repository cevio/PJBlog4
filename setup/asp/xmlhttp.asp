<%
define(function(require, exports, module){
	exports.createXmlHttp = function(){
		return new ActiveXObject(config.nameSpace.xmlhttp);
	}
	
	exports.auto = function(callback, object){
		if ( object === undefined ){
			object = this.createXmlHttp();
		}
		
		if (typeof callback === "function") { 
			return callback.call(this, object);
		}
	}
	
	exports.ajax = function(options, object){
		if ( options.method === undefined ) { options.method = "GET"; }
		if ( options.async === undefined ) { options.async = false; }	
		if ( options.data === undefined ){ options.data = {} }
		
		options.data = this.param(options.data);
		
		if ( options.method === "GET" ){
			options.url = this.paramUrl(options.url, options.data);
			options.data = null;
		}
		
		return this.auto(function(object){
			var ret = null;
			
			object.open(options.method, options.url, options.async);
			object.onreadystatechange = function() {
				if (object.readyState === 4) {
					if (object.status === 200){
						if (typeof options.success === "function"){ 
							ret = options.success.call(object, object.responseBody); 
						}else{
							ret = object.responseBody;
						}
					}
				}
			}
			object.send(options.data);
			
			return ret;
		}, object);
	}
	
	exports.paramUrl = function(url, param){
		if ( url.indexOf("?") > -1 ){
			return url + "&" + param;
		}else{
			return url + "?" + param;
		}
	}
	
	exports.parseJSON = function(str){
		return (new Function('return ' + str))();
	}
	
	exports.isJSONP = function(str, callStr){
		return (new RegExp(callStr + "\\((.+?)\\)\\;?")).test(str);
	}
	
	exports.parseJSONP = function(str, callStr){
		var exps = new RegExp(callStr + "\\((.+?)\\)\\;?");
		str = str.replace(exps, "$1").trim();
		return this.parseJSON(str);
	}
	
	exports.compentJSON = function(str, callStr){
		if ( this.isJSONP(str, callStr) ){
			return this.parseJSONP(str, callStr);
		}else{
			return this.parseJSON(str);
		}
	}
	
	exports.bin = function(text){
		var obj = new ActiveXObject(config.nameSpace.stream), ret;
			obj.Type = 1;
			obj.Mode = 3;
			obj.Open;
			obj.Write(text);
			obj.Position = 0;
			obj.Type = 2;
			obj.Charset = config.charset;
			ret = obj.ReadText;
			obj.Close;
			
		return ret;
	}
	
	exports.get = function(url, params, callback){
		var _this = this;
		
		return this.ajax({
			url : url,
			data : params,
			success : function(binary){
				if ( typeof callback === "function" ){
					return callback.call(this, _this.bin(binary));
				}else{
					return _this.bin(binary);
				}
			}
		});
	}
	
	exports.getJSON = function(url, params, callback){
		var _this = this;
		
		return this.get(url, params, function(text){
			if ( typeof callback === "function" ){
				return callback.call(this, _this.parseJSON(text));
			}else{
				return _this.parseJSON(text);
			}
		});
	}
	
	exports.param = function(keyCode){
		if ( typeof keyCode === "object" ){
			var ret = [], i;
			
			for ( i in keyCode ){
				ret.push(i + "=" + keyCode[i]);
			}
			
			ret = ret.join("&");
			
			return ret;
		}else{
			return keyCode;
		}
	}
	
	exports.unParam = function(keyCode){
		if ( typeof keyCode === "string" ){
			var ret, i, len = keyCode.split("&"), j = {};
		
			for ( i = 0 ; i < len.length ; i++ ){
				var _t = len[i].split("="),
					l = _t[0].trim(),
					r = _t[1].trim();
					
				j[l] = r;
			}
			
			ret = j;
			
			return ret;
		}else{
			return keyCode;
		}
	}
});
%>