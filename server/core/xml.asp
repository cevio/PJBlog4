<%
define(function(require, exports, module){
	var xml = function(selectExp, context, object){
		return new xml.init(selectExp, context, object);
	}
	
	var core_push = Array.prototype.push,
		core_slice = Array.prototype.slice;
	
	xml.init = function(selectExp, context, object){
			if ( selectExp === undefined ){
				selectExp = "";
			}
			
			this.length = 0;
			this.constructor = xml;
			this.object = object;
			xml.makeArray(context, this);

		return selectExp === "" ? this : this.find(selectExp);
	}
	
	xml.type = function(object){
		return Object.prototype.toString.call(object).split(" ")[1].toLowerCase().replace("]", "");
	}
	
	xml.saveToArray = function(object){
		var length = object.length;
		
		if ( xml.type(length) === "number" && length > 0 ){
			var x = [];
			for ( var i = 0 ; i < object.length ; i++ ){
				x.push(object[i]);
			}
			
			return x;
		}else{
			return [object];
		}
	}
	
	xml.makeArray = function( arr, results ){
		var type,
			ret = results || [];

		if ( arr != null ) {
			type = xml.type( arr );

			if ( arr.length == null || type === "string" || type === "function" || type === "regexp" || type === "object" ) {
				
				if ( type === "object" ){
					var isJson = false;
					try{
						for ( var i in arr ){
							isJson = true;
						}
						if ( isJson == true ){
							xml.merge( ret, arr );
						}else{
							core_push.call( ret, arr );
						}
					}catch(e){core_push.call( ret, arr );}
				}else{
					core_push.call( ret, arr );
				}
			} else {
				xml.merge( ret, arr );
			}
		}

		return ret;
	}
	
	xml.merge = function( first, second ){
		var l = second.length,
			i = first.length,
			j = 0;

		if ( typeof l === "number" ) {
			for ( ; j < l; j++ ) {
				first[ i++ ] = second[ j ];
			}

		} else {
			while ( second[j] !== undefined ) {
				first[ i++ ] = second[ j++ ];
			}
		}

		first.length = i;

		return first;
	}
	
	xml.map = function( elems, callback, arg ) {
		var value, key,
			ret = [],
			i = 0,
			length = elems.length,
			isArray = elems instanceof xml || length !== undefined && typeof length === "number" && ( ( length > 0 && elems[ 0 ] && elems[ length -1 ] ) || length === 0 || (xml.type(elems) === "array") ) ;

		if ( isArray ) {
			for ( ; i < length; i++ ) {
				value = callback( elems[ i ], i, arg );

				if ( value != null ) {
					ret[ ret.length ] = value;
				}
			}

		} else {
			for ( key in elems ) {
				value = callback( elems[ key ], key, arg );

				if ( value != null ) {
					ret[ ret.length ] = value;
				}
			}
		}

		return ret.concat.apply( [], ret );
	}
	
	xml.init.prototype = {
		each : function( callback, args ){
			var name,
				i = 0,
				obj = this,
				length = this.length,
				isObj = length === undefined || ( xml.type(obj) === "function" );
				
	
			if ( args ) {
				if ( isObj ) {
					for ( name in this ) {
						if ( callback.apply( this[ name ], args ) === false ) {
							break;
						}
					}
				} else {
					for ( ; i < length; ) {
						if ( callback.apply( this[ i++ ], args ) === false ) {
							break;
						}
					}
				}

			} else {
				if ( isObj ) {
					for ( name in this ) {
						if ( callback.call( this[ name ], name, this[ name ] ) === false ) {
							break;
						}
					}
				} else {
					for ( ; i < length; ) {
						if ( callback.call( this[ i ], i, this[ i++ ] ) === false ) {
							break;
						}
					}
				}
			}
	
			return this;
		},
		
		map : function( callback, arg ){
			return this.pushStack( xml.map(this, function( elem, i ) {
				return callback.call( elem, i, elem );
			}));
		},
		
		pushStack: function( elems, name, selector ) {
			var ret = xml.merge( this.constructor(), elems );
			ret.prevObject = this;
			ret.context = this.context;
			ret.object = this.object;
	
			if ( name === "find" ) {
				ret.selector = this.selector + ( this.selector ? " " : "" ) + selector;
			} else if ( name ) {
				ret.selector = this.selector + "." + name + "(" + selector + ")";
			}

			return ret;
		},
		
		find : function(selectExp){
			return this.map(function(){

				if ( selectExp.length > 0 ){
					var selectExpSplitArray = selectExp.split(" "),
						d = [this], ret = [];
						
					for ( var i = 0 ; i < selectExpSplitArray.length ; i++ ){
						var e = [];
						for ( var j = 0 ; j < d.length ; j++ )
						{
							e = e.concat(getExpElementsForArray(d[j], selectExpSplitArray[i]));
						}
						d = e;
					}

					return d;
				}else{
					return this;
				}
			});
		},
		
		merge: function( first, second ) {
			var l = second.length,
				i = first.length,
				j = 0;
	
			if ( typeof l === "number" ) {
				for ( ; j < l; j++ ) {
					first[ i++ ] = second[ j ];
				}
	
			} else {
				while ( second[j] !== undefined ) {
					first[ i++ ] = second[ j++ ];
				}
			}
	
			first.length = i;
	
			return first;
		},
		
		eq : function(i){
			i = +i;
			return i === -1 ?
				this.slice( i ) :
				this.slice( i, i + 1 );
		},
		
		first: function() {
			return this.eq( 0 );
		},
	
		last: function() {
			return this.eq( -1 );
		},
		
		slice: function() {
			return this.pushStack( core_slice.apply( this, arguments ),
				"slice", core_slice.call(arguments).join(",") );
		},
		
		end: function() {
			return this.prevObject || this.constructor(null);
		},
		
		toArray : function(){
			return core_slice.call( this );
		},
		
		get: function( num ) {
			return num == null ?
				this.toArray() :
				( num < 0 ? this[ this.length + num ] : this[ num ] );
		},
		size : function(){
			return this.length;
		},
		
		text : function(value){
			if ( value === undefined ){
				return this[0].text;			
			}else{
				var _this = this;
				this.empty().each(function(){
					this.appendChild(_this.object.createTextNode(value));
				});
				return this;
			}
		},
		
		html: function(value){
			if ( value === undefined ){
				return this[0].firstChild.text;
			}else{
				var _this = this;
				this.empty().each(function(){					
					this.appendChild( _this.object.createCDATASection(value) );
				});
				return this;
			}
		},
		
		attr: function(attrName, attrValue){
			if ( attrValue === undefined ){
				if ( xml.type(attrName) === "string" ){
					return this[0].getAttribute(attrName);
				} else {
					for ( var items in attrName ){
						this.attr(items, attrName[items]);
					}
				}
			}else{
				this.each(function(){
					this.setAttribute( attrName, attrValue + "" );
				});
			}
			
			return this;
		},
		
		empty: function(){
			for ( var i = 0, elem ; (elem = this[i]) != (null || undefined); i++ ) {
				// Remove any remaining nodes
				while ( elem.firstChild ) {
					elem.removeChild( elem.firstChild );
				}
			}
			return this;
		},
		
		create: function(tagname){
			var _this = this;
			return this.map(function(){
				var _element = _this.object.createElement( tagname );
				this.appendChild(_element);
				return _element;
			});
		},
		
		save: function(path){
			this.object.save(selector.lock(path));
		}
	}
	
	xml.createXml = function(){
		return new ActiveXObject(config.nameSpace.xml);
	}
	
	xml.load = function( loadXmlMessage, object ){
		var openStatus = false;
		if ( object === undefined ) object = xml.createXml();
		
		try{
			openStatus = object.loadXML( loadXmlMessage );
			if ( !openStatus ){
				try{
					openStatus = object.load(selector.lock( loadXmlMessage ));
				}catch(e){}
			}
		}catch(e){
			try{ openStatus = object.load(selector.lock( loadXmlMessage )); }catch(e){}
		}
		
		if ( openStatus !== false ){
			return {root: object.documentElement, object: object};
		}else{
			return null;
		}
	}
	
	function getExpElementsForArray(element, exps){
		var exec = /([^\[]+)(\[([^\=]+)\=\'([^\']+)\'\])?/.exec(exps);
		
		if ( exec ){
			try{
				var c = element.getElementsByTagName(exec[1]),
					e = [];

				if ( exec[2] ){	
					for ( var j = 0 ; j < c.length ; j++ ){
						if ( c[j].getAttribute(exec[3]) === exec[4] ){
							e.push(c[j]);
						}
					}
				}else{
					if ( c.length === 0 ){
						e = [];
					}else{
						e = xml.saveToArray(c);
					}
				}
				
				return e;
			}catch(e){ return []; }
		}else{
			return [element];
		}
	}
	
	return xml;
});
%>