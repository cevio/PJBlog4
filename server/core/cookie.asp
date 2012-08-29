<%
define(function(require, exports, module){
	exports.set = function(){
		
		var args = arguments.length,
			_arguments = arguments;
			root = [], key = [], value = [];
		
		switch ( args ){
			case 3:
				root.push(_arguments[0]);
				key.push(_arguments[1]);
				value.push(_arguments[2]);
				break;
			
			case 2:
				root.push(_arguments[0]);
				key.push(null);
				value.push(_arguments[1]);
				break;
				
			case 1:
				(function(){
					for ( var i in _arguments[0] ){
						var m = _arguments[0][i];
						for ( var j in m ){
							root.push(i);
							key.push(j);
							value.push(m[j]);
						}
					}
				})();
				break;
				
			default: 
				root = [];
				key = [];
				value = [];
		}
		
		for ( var o = 0 ; o < root.length ; o++ ){
			if ( key[o] === null ){
				Response.Cookies(root[o]) = value[o];
			}else{
				Response.Cookies(root[o])(key[o]) = value[o];
			}
		}
		
	}
	
	exports.get = function(root, key){
		if ( key === undefined ){
			return Request.Cookies(root);
		}else{
			return Request.Cookies(root)(key);
		}
	}
	
	exports.expire = function(root, times){
		var date = require.async("DATE"),
			NowDate = new Date().getTime(),
			targetDate = NowDate + times;
			
		Response.Cookies(root).Expires = date.format(targetDate, "y-m-d h:i:s");
	}
	
	exports.clear = function(root){
		Response.Cookies(root).Expires = "1980-1-1 0:0:0";
	}
});
%>