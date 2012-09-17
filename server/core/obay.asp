<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%
var config = {};

var console = {}, 
	selector, 
	fetch, 
	include, 
	define, 
	require, 
	exports = {}, 
	module,
	map = {},
	asa,
	http;

var JSON = !JSON ? {} : JSON;

// Object prototype
(function(array, string){

	if ( array.indexOf === undefined ){
		array.indexOf = function(value){
			var i = -1;

			for ( var j = 0 ; j < this.length ; j++ ){
				if ( this[j] === value ){
					i = j;
					break;
				}
			}

			return i;
		}
	}

	if ( string.trim === undefined ){
		string.trim = function(){
			return this.replace(/^\s+/, "").replace(/\s+$/, "");
		}
	}

	if ( array.forEach === undefined ){
		array.forEach = function(fn){
			for (var i = 0, len = this.length; i < len; i++) { 
				fn.call(this, this[i], i);
			};
		}
	}

})(Array.prototype, String.prototype);

// config department.
(function(){
	// base host
	config.debug = false;
	config.useApp = true;
	config.appName = "obay";

	config.location = Server.MapPath(".");
	config.rootion = Server.MapPath("/");
	config.base = (function(){
		var depPerMent = config.location.replace( new RegExp("^" + config.rootion.replace(/\\/g, "\\\\")), "" ).substring(1).split("\\").length;
		var xpath = "";

		for ( var i = 0 ; i < depPerMent ; i++ ){
			xpath += "../";
		}

		return xpath;
	})();

	var dota = ".";

	config.nameSpace = {
		conn 	: 	"ADODB" + dota + "CONNECTION",
		record 	: 	"ADODB" + dota + "RECORDSET",
		fso 	: 	"Scripting" + dota + "FileSystemObject",
		stream 	: 	"Adodb" + dota + "Stream",
		xmlhttp : 	"Microsoft" + dota + "XMLHTTP",
		xml 	: 	"Microsoft" + dota + "XMLDOM",
		winhttp : 	"WinHttp" + dota + "WinHttpRequest.5.1"
	};

	config.charset = "utf-8";

	console.log = function(ResponseText){
		Response.Write(ResponseText);
	}

	console.end = function(ResponseText){
		this.log(ResponseText);
		Response.End();
	}

	var debug = [];

	console.push = function(ResponseText){
		debug.push(ResponseText);
	}

	console.debug = function(){
		if ( config.debug && (debug.length > 0) ){
			var tpl = '';

			for ( var i = 0 ; i < debug.length ; i++ ){
				tpl += '<li>' + debug[i] + '</li>';
			}

			tpl = '<ol class="debug">' + tpl + '</ol>';

			this.end(tpl);
		}
	}

})();

// selector department.
(function(){
	selector = function(path, locked){
		if ( map[path] !== undefined ){
			path = map[path];
		}

		var _path = "";

		if ( config.base === undefined ){
			config.base = "/";
		}else{
			if ( !/^\//.test(config.base) ){
				config.base = "/" + config.base;
			}
		}

		// 当前目录
		if ( /^\.\//.test(path) ){
			_path = config.location + "\\" + path.replace(/^\.\//, "").replace(/\//g, "\\");
		}

		// 上一级目录
		else if ( /^\.\.\//.test(path) ){
			_path = (function(){
				var tmpPath = (config.location + "/" + path).replace(/\\/g, "/"),
					tmpArr = tmpPath.split("/"),
					rootStr = config.rootion,
					rootArr = rootStr.replace(/\\/g, "/").split("/"),
					rootIndex = rootArr.length - 1;

				var arrify = function(){
						var index = tmpArr.indexOf("..");
						if ( index - 1 > rootIndex ){
							tmpArr.splice(index - 1, 2);
							return arrify();
						}else{
							return tmpArr;
						}
					};

				return arrify().join("\\");
			})();
		}

		// 根目录
		else if ( /^\//.test(path) ){
			_path = config.rootion + path.replace(/\//g, "\\");
		}

		// 一般目录
		else{
			_path = Server.MapPath((config.base === "/" ? "" : config.base) + "/" + path);
		}

		// 是否添加后缀
		if ( !locked ){
			_path = !/\.asp$/.test(_path) ? _path + ".asp" : _path;
		}

		return _path;
	}

	selector.lock = function(path){
		return selector(path, true);
	}

})();

// loader department
(function(){
	var regExpress = {
		includeExp : /\<\!\-\-\#include\sfile\s?\=\s?\"(.+?)\"\s?\-\->/g,
		includeFileExp : /file\=\"(.+)\"/,
		includeContentForLeftExp : /^[\r\t\s\n]+/,
		includeContentForRightExp : /[\r\t\s\n]+$/
	}

	function ReadFileContainer(id){
		var o = new ActiveXObject(config.nameSpace.stream), Text;
			o.Type = 2; o.Mode = 3; 
			o.Open(); 
				o.Charset = config.charset; 
				o.Position = o.Size; 
				o.LoadFromFile(id);
				Text = o.ReadText;
			o.Close;
			o = undefined;
		
		return reLoadContainerFileRelative(Text, id.split("\\").slice(0, -1).join("\\"));
	}
	
	function reLoadContainerFileRelative(context, localFo){
		var l = 0, text = "", r = 0, p = "", e, t, tempText;
		if ( regExpress.includeExp.test(context) ){
			while ( l > -1 ){
				l = context.indexOf("<" + "!--#include");
				if ( l > -1 ){
					text += context.substring(0, l); // 查找到的include前面部分
					context = context.substring(l + 12); // include文件部分
					r = context.indexOf("-->"); // 搜索结尾
					p = context.substring(0, r); // 得到文件区域
					e = p.replace(/file\s?\=\s?\"/, "").replace(/\"/, "").trim();// 得到文件
					if ( localFo.length == 0 ){
						t = e;
					}else{
						t = localFo + "\\" + e;
					} // 替换文件路径
					context = context.substring(r + 3); // 得到include后面部分
					tempText = ReadFileContainer(t); // 文件打开后的内容
					text += reLoadContainerFileRelative(tempText, t.split("\\").slice(0, -1).join("\\"));
				}else{
					text += context;
					context = "";
				}
			}
			return text;
		}else{
			return context;
		}
	}
	
	function GrepSytax(context){
		context = context.replace(regExpress.includeContentForLeftExp, "").replace(regExpress.includeContentForRightExp, "");
		
		function customReplace(data){
			return data.replace(/\b/g, '\\b')
						.replace(/\\/g, '\\\\')
						.replace(/\"/g, '\\"')
						.replace(/\r/g, '\\r')
						.replace(/\f/g, '\\f')
						.replace(/\n/g, '\\n')
						.replace(/\s/g, ' ')
						.replace(/\t/g, '\\t');
		}
		
		function textformat(t){
			if ( t.length > 0 ){
				return ";Response.Write(\"" + customReplace(t) + "\");";
			}else{
				return "";
			}
		}
		var blank = "", conSplit = context.split("<" + blank + "%"), r = 0, text = "", temp;
		for ( var i = 0 ; i < conSplit.length ; i++ )
		{
			r = conSplit[i].indexOf("%" + blank + ">");
			if ( r > -1 ){
				temp = textformat(conSplit[i].substring(r + 2));
				text += (/^\=/.test(conSplit[i]) ? ";Response.Write(" + conSplit[i].substring(1, r) + ");" : conSplit[i].substring(0, r)) + temp;
			}else{
				text += textformat(conSplit[i]);
			}
		}
		return text;
	}

	fetch = function( pathMark ){
		return GrepSytax(ReadFileContainer(selector(pathMark)));
	}

	include = function(pathMark){
		eval(fetch(pathMark));
	}

})();

// module department
(function(){
	module = function(id, deps, factory){
		this.id = id;
		this.deps = deps || [];
		this.factory = factory;
		this.exports = {};
	}
})();

// define department
(function(){

	function parseDependencies(code) {
		var pattern = /(?:^|[^.])\brequire\s*\(\s*(["'])([^"'\s\)]+)\1\s*\)/g;
		var ret = [], match;
	
		code = removeComments(code);

		while ((match = pattern.exec(code))) {
		  if (match[2]) {
			ret.push(match[2]);
		  }
		}
	
		return unique(ret);
	}
	
	function removeComments(code) {
		return code
			.replace(/(?:^|\n|\r)\s*\/\*[\s\S]*?\*\/\s*(?:\r|\n|$)/g, '\n')
			.replace(/(?:^|\n|\r)\s*\/\/.*(?:\r|\n|$)/g, '\n');
	}

	var unique = function(arr) {
    	var ret = [], o = {};

    	arr.forEach(function(item){
			o[item] = 1;
    	});

    	if (Object.keys) { ret = Object.keys(o); }
    	else { for (var p in o) { if (o.hasOwnProperty(p)) { ret.push(p); } } };

    	return ret;
  	};

	define = function(deps, factory){
		if ( factory === undefined ){
			factory = deps;
			deps = [];
		}

		if ( typeof deps === "string" ){
			deps = [deps];
		}

		if ( typeof factory === "function" ){
			var _deps = parseDependencies(factory.toString());
				deps = deps.concat(_deps);
		}

		exports[config.current] = new module(config.current, deps, factory);
	}
})();

// require department
(function(){
	var loader = function(deps, fn){
		this.deps = deps;
		this.fn = fn;
		this.ret = [];
	}

	var depMents = function(uri){
		this.rootUri = uri;
	}

	loader.prototype.run = function(){
		for ( var i = 0 ; i < this.deps.length ; i++ ){
			var _depments = new depMents(this.deps[i]);
			this.ret.push(_depments.get());
		}
	}

	depMents.prototype.get = function(){
		var _selector = selector(this.rootUri);
		if ( exports[_selector] === undefined ){

			config.current = _selector;
			include(this.rootUri);
			config.current = undefined;
			console.push("loader : " + _selector);

			if ( exports[_selector] === undefined ){
				exports[_selector] = new module(_selector, [], function(){});
			}else{
				var _module = exports[_selector],
					_depsments = _module.deps;

				_require_(_depsments);
			}
		}

		var _module_ = exports[_selector];

		var _ret_ = _module_.factory(_require_, _module_.exports, _module_);

		if ( _ret_ === undefined ){ return _module_.exports; }else{ return _ret_; }
	}

	var _require_ = function(deps, fn){
		if ( typeof deps === "string" ){
			deps = [deps];
		}

		var _loader = new loader(deps, fn);
			_loader.run();

		if ( typeof fn === "function" ){
			fn.apply(null, _loader.ret);
		}else{
			if ( _loader.ret.length > 0 ) {
				if ( _loader.ret.length === 1 ){
					return _loader.ret[0];
				}else{
					return _loader.ret;
				}
			}
		}
	}

	require = _require_;
	require.async = _require_;
})();

// http department
(function(){
	var emtor = function( object, callback ){
		var _object = new Enumerator(object),
			_ret = [];
		
		for (; !_object.atEnd() ; _object.moveNext() ) {
			if ( typeof callback === "function" ){
				_ret.push(callback.call(_object, _object.item()));
			}else{
				_ret.push(_object.item());
			}
		}
		
		return _ret;
	}
	
	http = function( callback ){
		var Req = { query : {}, form : {} }, 
			i = 0,
			value,
			Res;
			
		var queryEmtor = emtor(Request.QueryString);
		var formEmtor = emtor(Request.Form);
		
		for ( i = 0 ; i < queryEmtor.length ; i++ ){
			value = emtor(Request.QueryString(queryEmtor[i]));
			Req.query[queryEmtor[i]] = (value.length === 1 ? value[0] : value);
		}
		
		for ( i = 0 ; i < formEmtor.length ; i++ ){
			value = emtor(Request.Form(formEmtor[i]));
			Req.form[formEmtor[i]] = (value.length === 1 ? value[0] : value);
		}
		
		Res = callback( Req );

		return Res;
	}


	http.async = function(callback){
		var ResponseText = http(callback);
		
		try{
			console.log(JSON.stringify(ResponseText));
		}catch(e){
			console.end(e.message);
		}
	}

	http.write = function(callback){
		var ResponseText = http(callback);

		try{
			console.log(ResponseText.toString());
		}catch(e){
			console.end(e.message);
		}
	}

})();

// JSON department
(function () {
    'use strict';

    function f(n) {
        // Format integers to have at least two digits.
        return n < 10 ? '0' + n : n;
    }

    if (typeof Date.prototype.toJSON !== 'function') {

        Date.prototype.toJSON = function (key) {

            return isFinite(this.valueOf())
                ? this.getUTCFullYear()     + '-' +
                    f(this.getUTCMonth() + 1) + '-' +
                    f(this.getUTCDate())      + 'T' +
                    f(this.getUTCHours())     + ':' +
                    f(this.getUTCMinutes())   + ':' +
                    f(this.getUTCSeconds())   + 'Z'
                : null;
        };

        String.prototype.toJSON      =
            Number.prototype.toJSON  =
            Boolean.prototype.toJSON = function (key) {
                return this.valueOf();
            };
    }

    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        gap,
        indent,
        meta = {    // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"' : '\\"',
            '\\': '\\\\'
        },
        rep;


    function quote(string) {

// If the string contains no control characters, no quote characters, and no
// backslash characters, then we can safely slap some quotes around it.
// Otherwise we must also replace the offending characters with safe escape
// sequences.

        escapable.lastIndex = 0;
        return escapable.test(string) ? '"' + string.replace(escapable, function (a) {
            var c = meta[a];
            return typeof c === 'string'
                ? c
                : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
        }) + '"' : '"' + string + '"';
    }


    function str(key, holder) {

// Produce a string from holder[key].

        var i,          // The loop counter.
            k,          // The member key.
            v,          // The member value.
            length,
            mind = gap,
            partial,
            value = holder[key];

// If the value has a toJSON method, call it to obtain a replacement value.

        if (value && typeof value === 'object' &&
                typeof value.toJSON === 'function') {
            value = value.toJSON(key);
        }

// If we were called with a replacer function, then call the replacer to
// obtain a replacement value.

        if (typeof rep === 'function') {
            value = rep.call(holder, key, value);
        }

// What happens next depends on the value's type.

        switch (typeof value) {
        case 'string':
            return quote(value);

        case 'number':

// JSON numbers must be finite. Encode non-finite numbers as null.

            return isFinite(value) ? String(value) : 'null';

        case 'boolean':
        case 'null':

// If the value is a boolean or null, convert it to a string. Note:
// typeof null does not produce 'null'. The case is included here in
// the remote chance that this gets fixed someday.

            return String(value);

// If the type is 'object', we might be dealing with an object or an array or
// null.

        case 'object':

// Due to a specification blunder in ECMAScript, typeof null is 'object',
// so watch out for that case.

            if (!value) {
                return 'null';
            }

// Make an array to hold the partial results of stringifying this object value.

            gap += indent;
            partial = [];

// Is the value an array?

            if (Object.prototype.toString.apply(value) === '[object Array]') {

// The value is an array. Stringify every element. Use null as a placeholder
// for non-JSON values.

                length = value.length;
                for (i = 0; i < length; i += 1) {
                    partial[i] = str(i, value) || 'null';
                }

// Join all of the elements together, separated with commas, and wrap them in
// brackets.

                v = partial.length === 0
                    ? '[]'
                    : gap
                    ? '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']'
                    : '[' + partial.join(',') + ']';
                gap = mind;
                return v;
            }

// If the replacer is an array, use it to select the members to be stringified.

            if (rep && typeof rep === 'object') {
                length = rep.length;
                for (i = 0; i < length; i += 1) {
                    if (typeof rep[i] === 'string') {
                        k = rep[i];
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            } else {

// Otherwise, iterate through all of the keys in the object.

                for (k in value) {
                    if (Object.prototype.hasOwnProperty.call(value, k)) {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            }

// Join all of the member texts together, separated with commas,
// and wrap them in braces.

            v = partial.length === 0
                ? '{}'
                : gap
                ? '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}'
                : '{' + partial.join(',') + '}';
            gap = mind;
            return v;
        }
    }

// If the JSON object does not yet have a stringify method, give it one.

    if (typeof JSON.stringify !== 'function') {
        JSON.stringify = function (value, replacer, space) {

// The stringify method takes a value and an optional replacer, and an optional
// space parameter, and returns a JSON text. The replacer can be a function
// that can replace values, or an array of strings that will select the keys.
// A default replacer method can be provided. Use of the space parameter can
// produce text that is more easily readable.

            var i;
            gap = '';
            indent = '';

// If the space parameter is a number, make an indent string containing that
// many spaces.

            if (typeof space === 'number') {
                for (i = 0; i < space; i += 1) {
                    indent += ' ';
                }

// If the space parameter is a string, it will be used as the indent string.

            } else if (typeof space === 'string') {
                indent = space;
            }

// If there is a replacer, it must be a function or an array.
// Otherwise, throw an error.

            rep = replacer;
            if (replacer && typeof replacer !== 'function' &&
                    (typeof replacer !== 'object' ||
                    typeof replacer.length !== 'number')) {
                throw new Error('JSON.stringify');
            }

// Make a fake root object containing our value under the key of ''.
// Return the result of stringifying the value.

            return str('', {'': value});
        };
    }


// If the JSON object does not yet have a parse method, give it one.

    if (typeof JSON.parse !== 'function') {
        JSON.parse = function (text, reviver) {

// The parse method takes a text and an optional reviver function, and returns
// a JavaScript value if the text is a valid JSON text.

            var j;

            function walk(holder, key) {

// The walk method is used to recursively walk the resulting structure so
// that modifications can be made.

                var k, v, value = holder[key];
                if (value && typeof value === 'object') {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v;
                            } else {
                                delete value[k];
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }


// Parsing happens in four stages. In the first stage, we replace certain
// Unicode characters with escape sequences. JavaScript handles many characters
// incorrectly, either silently deleting them, or treating them as line endings.

            text = String(text);
            cx.lastIndex = 0;
            if (cx.test(text)) {
                text = text.replace(cx, function (a) {
                    return '\\u' +
                        ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                });
            }

// In the second stage, we run the text against regular expressions that look
// for non-JSON patterns. We are especially concerned with '()' and 'new'
// because they can cause invocation, and '=' because it can cause mutation.
// But just to be safe, we want to reject all unexpected forms.

// We split the second stage into 4 regexp operations in order to work around
// crippling inefficiencies in IE's and Safari's regexp engines. First we
// replace the JSON backslash pairs with '@' (a non-JSON character). Second, we
// replace all simple value tokens with ']' characters. Third, we delete all
// open brackets that follow a colon or comma or that begin the text. Finally,
// we look to see that the remaining characters are only whitespace or ']' or
// ',' or ':' or '{' or '}'. If that is so, then the text is safe for eval.

            if (/^[\],:{}\s]*$/
                    .test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, '@')
                        .replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']')
                        .replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {

// In the third stage we use the eval function to compile the text into a
// JavaScript structure. The '{' operator is subject to a syntactic ambiguity
// in JavaScript: it can begin a block or an object literal. We wrap the text
// in parens to eliminate the ambiguity.

                j = eval('(' + text + ')');

// In the optional fourth stage, we recursively walk the new structure, passing
// each name/value pair to a reviver function for possible transformation.

                return typeof reviver === 'function'
                    ? walk({'': j}, '')
                    : j;
            }

// If the text is not JSON parseable, then a SyntaxError is thrown.

            throw new SyntaxError('JSON.parse');
        };
    }
}());

// 输出global.asa文件
(function(){
	asa = function(){
		var globalAsa = "/global.asa",
			fso = new ActiveXObject(config.nameSpace.fso),
			tpl = '<object id="' + ( config.appName || 'obay' ) + '" runat="server" scope="Application" progid="Scripting.Dictionary"></object>\n<script language="JScript" runat="Server">\nfunction Session_OnStart(){};\nfunction Session_OnEnd(){};\nfunction Application_OnStart(){};\nfunction Application_OnEnd(){};\n</script>';
		
		if ( config.useApp && !fso.FileExists(Server.MapPath(globalAsa)) ){
			var stream = new ActiveXObject(config.nameSpace.stream);
				stream.Type = 2; 
				stream.Mode = 3; 
				stream.Open();
				stream.Charset = config.charset;
				stream.Position = stream.Size; 
				stream.WriteText = tpl;
				stream.SaveToFile(Server.MapPath(globalAsa), 2);
				stream.Close;
				stream = null;
		}	

		fso = null;		
	}
})();
%>