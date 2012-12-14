<%
;define(function(require, exports, module){
	var fso = require.async("FSO"),
		stream = require.async("STREAM"),
		fns = require.async("fn");

	exports.formatActionType = function(actionType){
		var actionArray = actionType.split("."),
			fo = "profile/handler";
		
		for ( var i = 0 ; i < actionArray.length ; i++ ){
			fo += "/" + actionArray[i];
			if ( !fso.exsit(fo, true) ){
				fso.create(fo);
			}
		}
		
		return fo;
	};
	
	exports.addProxy = function(actionType, options){
		if ( !actionType || actionType.length === 0 ){
			return false;
		};
		
		var d = "%",
			_this = this,
			fo = this.formatActionType(actionType),
			text,
			filename = fns.randoms(20);
		
		if ( typeof options === "string" ){
			options = { file: options };
		}
		
		if ( typeof options === "function" ){
			options = { func: options };
		}
		
		if ( options.func !== undefined ){
			text = '<' + d + '\ndefine(function(require,exports,module){\nreturn ' + options.func.toString() + '\n});\n' + d + '>';
			stream.save(text, fo + "/" + this.mark + "." + filename + ".asp");
		}else if ( options.str !== undefined ) {
			text = '<' + d + '\ndefine(function(require,exports,module){\nreturn ' + options.str + '\n});\n' + d + '>';
			stream.save(text, fo + "/" + this.mark + "." + filename + ".asp");
		}else{
			fso.copy(_this.folder + "/" + options.file, fo, false, this.mark + "." + filename + ".asp");
		}
		
		return true;
	};


	exports.proxy = function(actionType, arrArguments){
		var ports = this.getPorts(actionType),
			_this = this;
		
		arrArguments = arrArguments === undefined ? [] : arrArguments;
		arrArguments = Object.prototype.toString.apply(arrArguments) !== "[object Array]" ? [arrArguments] : arrArguments;
		
		if ( ports.length > 0 ){
			this.exec(ports, {
				callback: function(moden){
					if ( typeof moden === "function" ){
						moden.apply(_this, arrArguments);
					}else{
						console.log(moden);
					}
				}
			});
		}
	};
	
	exports.exec = function(arr, options, i){
		if ( i === undefined ) { i = 0; }
		if ( arr[i] === undefined ){
			if ( typeof options.success === "function" ){
				options.success();
			}
		}else{
			var tmpparams = require.async(arr[i]);
			if ( typeof options.callback === "function" ){
				options.callback(tmpparams, i);
			}
			this.exec(arr, options, i + 1);
		}
	};
	
	exports.getPorts = function(actionType){
		var fo = this.formatActionType(actionType),
			files = fso.collect(fo, false, function(name){
				return fo + "/" + name;
			}),
			arr = [];
		
		if ( files.length > 0 && fso.exsit(fo, true) ){	
			arr.push(files);
		}
		
		return arr;
	};
	
	exports.destory = function(actionType, fileArrays){
		var fo = this.formatActionType(actionType),
			_this = this;
			
		if ( fileArrays === undefined ){
			fileArrays = [];
		}
		
		if ( typeof fileArrays === "string" ){
			fileArrays = [fileArrays];
		}
		
		if ( fileArrays.length === 0 ){
			fileArrays = fso.collect(fo, false, function(name){
				if ( name.split(".")[0] === _this.mark ){
					return name;
				}else{
					return null;
				}
			});
		}
		
		for ( var i = 0 ; i < fileArrays.length ; i++ ){
			if ( fso.exsit(fo + "/" + fileArrays[i]) ){
				fso.destory( fo + "/" + fileArrays[i] );
			}
		}
	};
});
%>