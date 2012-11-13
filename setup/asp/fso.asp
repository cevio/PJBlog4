<%
define(function( require, exports, module ){

	exports.createFSO = function(){
		return new ActiveXObject(config.nameSpace.fso);
	}

	exports.auto = function(callback, object){
		if ( object === undefined ){
			object = this.createFSO();
		}

		return callback.call(object);
	}

	exports.exsit = function(path, type, object){
		return this.auto(function(){
			if ( type === undefined ){ type === false }
			if ( type === true ){
				return this.FolderExists(selector.lock(path));
			}
			else{
				return this.FileExists(selector.lock(path));
			}
		}, object);
	}

	exports.create = function(path, auto, object){
		return this.auto(function(){
			try{
				if ( auto === true ){

					path = selector.lock(path);
					console.push(path);

					var exec = /(\w)\:\\(.+)/.exec(path);
					console.push(exec);

					if ( exec ){
						var _path = exec[2];
						var r = exec[1];
						var arr = _path.split("\\");

						r = r + ":";

						for ( var i = 0 ; i < arr.length ; i++ ){
							if ( arr[i].length > 0 ){
								r = r + "\\" + arr[i];
								if ( !this.FolderExists(r) ){
									this.CreateFolder(r);
								}
							}else{
								break;
							}
						}

					}else{
						return false;
					}
				}else{
					this.CreateFolder(selector.lock(path));
				}
				return true;
			}catch(e){
				console.push(e.message);
				return false;
			}
		}, object);
	}

	exports.collect = function(path, type, callback, object){
		return this.auto(function(){
			var _object_ = this.GetFolder(selector.lock(path)),
				_object = null;

			if ( type === undefined ){ type = false; }
			if ( type === true ){
				_object = _object_.SubFolders;
			}else{
				_object = _object_.Files;
			}

			var _emtor = new Enumerator(_object),
				_arr = [];

			for (; !_emtor.atEnd() ; _emtor.moveNext() ) {
				var name = _emtor.item().Name;
				if ( typeof callback === "function" ){
					name = callback(name);
					if ( name !== null ){
						_arr.push(name);
					}
				}else{
					_arr.push(name);
				}
				
			}

			return _arr;
		}, object);
	}

	exports.destory = function(path, type, object){
		var _this = this;
		return this.auto(function(){
			if ( type === undefined ){ type = false; }
			if ( type === true ){
				this.DeleteFolder(selector.lock(path));
			}else{
				this.DeleteFile(selector.lock(path));
			}
			return !_this.exsit(path, type, this);
		}, object);
	}

	exports.destorys = function(path, type, object){
		path = path.replace(/\/$/, "");

		if ( type === undefined ){ type = "all"; }
		var _this = this, i, arr ;

		return this.auto(function(){
			if ( type === "file" ){
				arr = _this.collect(path, false, function(name){
					return path + "/" + name;
				}, this);

				for ( i = 0 ; i < arr.length ; i++ ){
					_this.destory(arr[i], false, this);
				}
			}
			else if ( type === "folder" ){
				arr = _this.collect(path, true, function(name){
					return path + "/" + name;
				}, this);

				for ( i = 0 ; i < arr.length ; i++ ){
					_this.destory(arr[i], true, this);
				}
			}
			else{
				_this.destorys(path, "file", this);
				_this.destorys(path, "folder", this);
			}
		}, object);
	}

	exports.move = function(source, target, type, newName, object){
		var fname = source.split("/").slice(-1).join("");

		if ( typeof newName === "function" ){
			fname = newName(fname);
		}else if ( typeof newName === "string" ){
			fname = newName;
		}

		return this.auto(function(){
			try{
				if ( type === undefined ){ type = false; }
				if ( type === true ){
					this.MoveFolder(selector.lock(source), selector.lock(target) + "\\" + fname);
				}else{
					this.MoveFile(selector.lock(source), selector.lock(target) + "\\" + fname);
				}
				return true;
			}catch(e){
				return false;
				console.push(e.message);
			}
		}, object);
	}

	exports.moves = function(source, target, type, object){
		var _this = this;
		return this.auto(function(){
			var arr, i;
			if ( type === "file" ){
				arr = _this.collect(source, false, function(name){
					return source + "/" + name;
				}, this);

				for ( i = 0 ; i < arr.length ; i++ ){
					_this.move(arr[i], target, false, null, this);
				}
			}
			else if ( type === "folder" ){
				arr = _this.collect(source, true, function(name){
					return source + "/" + name;
				}, this);

				for ( i = 0 ; i < arr.length ; i++ ){
					_this.move(arr[i], target, true, null, this);
				}
			}
			else{
				_this.moves(source, target, "file", type, this);
				_this.moves(source, target, "folder", type, this);
			}
		}, object);
	}

	exports.copy = function(source, target, type, newName, object){
		var fname = source.split("/").slice(-1).join("");

		if ( typeof newName === "function" ){
			fname = newName(fname);
		}else if ( typeof newName === "string" ){
			fname = newName;
		}

		return this.auto(function(){
			try{
				if ( type === undefined ){ type = false; }
				if ( type === true ){
					this.CopyFolder(selector.lock(source), selector.lock(target) + "\\" + fname);
				}else{
					this.CopyFile(selector.lock(source), selector.lock(target) + "\\" + fname);
				}
				return true;
			}catch(e){
				return false;
				console.push(e.message);
			}
		}, object);
	}

	exports.copys = function(source, target, type, object){
		var _this = this;
		return this.auto(function(){
			var arr, i;
			if ( type === "file" ){
				arr = _this.collect(source, false, function(name){
					return source + "/" + name;
				}, this);

				for ( i = 0 ; i < arr.length ; i++ ){
					_this.copy(arr[i], target, false, null, this);
				}
			}
			else if ( type === "folder" ){
				arr = _this.collect(source, true, function(name){
					return source + "/" + name;
				}, this);

				for ( i = 0 ; i < arr.length ; i++ ){
					_this.copy(arr[i], target, true, null, this);
				}
			}
			else{
				_this.copys(source, target, "file", type, this);
				_this.copys(source, target, "folder", type, this);
			}
		}, object);
	}

	exports.rename = function(path, name, type, object){
		return this.auto(function(){
			try{
				var obj = null;
				if ( type === undefined ){ type = false; }
				if ( type === true ){
					obj = this.GetFolder(selector.lock(path));
				}else{
					obj = this.GetFile(selector.lock(path));
				}

				obj.Name = name;
				return true;
			}catch(e){
				console.push(e.message);
				return false;
			}
		}, object);
	}

	exports.getAllFolders = function(path, object){
		var arr = this.collect(path, true, function(name){
			if ( /^\./.test(name) ){
				return null;
			}else{
				return path === "/" ? "/" + name : path + "/" + name;
			}
		}, object);

		for ( var i = 0 ; i < arr.length ; i++ ){
			arr = arr.concat(this.getAllFolders(arr[i], object));
		}

		return arr;
	}

	exports.collects = function(path, object){
		var _this = this;

		return this.auto(function(){
			return _this.getAllFolders(path);
		}, object);
	}
});
%>