<%
define(function( require, exports, module ){

	exports.createStream= function(){
		return new ActiveXObject(config.nameSpace.stream);
	}

	exports.auto = function(callback, object){
		if ( object === undefined ){
			object = this.createStream();
		}

		return callback.call(object);
	}

	exports.load = function(path, isBinary, object){
		isBinary = isBinary === undefined ? false : isBinary;
		return this.auto(function(){
			var type = isBinary === true ? 1 : 2,
				ret;

			this.Type = type; 
			this.Mode = 3; 
			this.Open();

			if ( !isBinary ) { this.Charset = config.charset; }
			this.Position = isBinary ? 0 : this.Size;
			this.LoadFromFile(selector.lock(path));
			ret = isBinary ? this.Read() : this.ReadText;

			this.Close();

			return ret;
		}, object);
	}

	exports.save = function(Text, Path, isBinary, object){
		return this.auto(function(){
			var type = isBinary === true ? 1 : 2,
				ret;

			this.Type = type; 
			this.Mode = 3; 
			this.Open();

			if ( !isBinary ){
				this.Charset = config.charset;
				this.Position = this.Size; 
				this.WriteText = Text;  
			}else{
				this.Position = 0;
				this.Write(Text);
			}
			
			this.SaveToFile(selector.lock(Path), 2);

			this.Close();
		}, object);
	}
});
%>