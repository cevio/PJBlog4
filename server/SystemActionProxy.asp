<%
define(function(require, exports, module){
	var fso = require.async("FSO"),
		stream = require.async("STREAM");
		
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
	}
	
	exports.addProxy = function(actionType, options){
		if ( !actionType || actionType.length === 0 ){
			return false;
		}
		
		var d = "%",
			_this = this,
			fo = this.formatActionType(actionType);
		
		if ( typeof options === "string" ){
			options = { file: options };
		}
		
		if ( typeof options === "function" ){
			options = { func: options };
		}
		
		if ( options.func !== undefined ){
			var text = '<' + d + '\ndefine(function(require,exports,module){\nreturn ' + options.func.toString() + '\n});\n' + d + '>';
			stream.save(text, fo + "/" + this.mark + "." + options.filename + ".asp");
		}
		
		if ( options.file !== undefined ){
			fso.copy(_this.folder + "/" + options.file, fo, false, this.mark + "." + options.file);
		}
		
		return true;
	}
	
	exports.proxy = fucntion(actionType){
		var fo = this.formatActionType(actionType),
			files = fso.collect(fo, false, function(name){
				return fo + "/" + name;
			});
		
		if ( files.length > 0 && fso.exsit(fo, true) ){	
			require.async(files);
		}
	}
	
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
	}
});
%>