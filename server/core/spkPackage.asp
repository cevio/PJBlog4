<%
define(function(require, exports, module){
	
	var fso = require("FSO");
	
	var package = function(path, savePath){
		this.object = new ActiveXObject(config.nameSpace.stream);
		this.path = selector.lock(path);
		this.savePath = savePath || ".";
		
		this.object.Type = 1; 
		this.object.Mode = 3; 
		this.object.Open();
		this.object.Position = 0;
		this.object.LoadFromFile(this.path);
		this.binary = this.object.Read();
	}
	
	package.prototype.utf8File = function(){
		var obj = new ActiveXObject(config.nameSpace.stream),
			text;
			
			obj.Type = 2
			obj.Open();
			obj.WriteText(this.binary);
			obj.Position = 0;
			obj.Charset = "utf-8";
			obj.Position = 2;
			text = obj.ReadText;
			obj.Close();
				
		return text;
	}
	
	package.prototype.getHeaderLength = function(utf8Str){
		return Number(utf8Str.substr(4, 8));
	}
	
	package.prototype.SaveFile = function(start, length, path){
		var obj = new ActiveXObject(config.nameSpace.stream), 
			text,
			paths = selector.lock(path);
		
			obj.Type = 1;
			obj.Mode = 3;
			obj.Open();
			this.object.Position = start;
			this.object.CopyTo(obj, length);
			obj.SaveToFile(paths, 2);
			obj.Close();
			obj = null;
	}
	
	package.prototype.install = function(){
		var binaryDatas = this.utf8File(),
			headerLength = this.getHeaderLength(binaryDatas),
			headerText = binaryDatas.substring(16, binaryDatas.indexOf("| "));
			
		var arr = headerText.split("|"), chunkDataLenth = 16 + headerLength + 1;
		
		for ( var i = 1 ; i < arr.length ; i++ ){
			var file = arr[i].split(">"),
				filename = file[0].replace(/\\/g, "/"),
				filesize = Number(file[1]),
				files = this.savePath + "/" + filename.replace(/^\//, "");

			fso.create(files.split("/").slice(0, -1).join("/"), true);	
			this.SaveFile(chunkDataLenth, filesize, files);
				
			chunkDataLenth += filesize;
		}
	}
	
	return package;
	
});
%>