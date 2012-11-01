<%
/*
 * Notice : 
 *		accept-charset="ascii" onsubmit="document.charset='ascii';"
 */
define(function(require, exports, module){
	var custom = {
		readBinary : function(speed){
			var totalSize = Request.TotalBytes,
				haveReadSize = 0,
				binaryChunkData;
				
			if ( totalSize < speed ){
				speed = totalSize;
			}
			
			var obj = new ActiveXObject(config.nameSpace.stream);
				obj.Type = 1;
				obj.Mode = 3;
				obj.Open();
			
			while ( haveReadSize < totalSize ){
				if (totalSize - haveReadSize < speed){
					speed = totalSize - haveReadSize;
				}
				obj.Write(Request.BinaryRead(speed));
				haveReadSize += speed;
			}
				obj.Position = 0;
				binaryChunkData = obj.Read();
				obj.Close();
				obj = null;
			
			return binaryChunkData;
		},
		extend : function(source, target){
			if ( target === undefined ){
				target = {};
			};
			
			for ( var i in target ){
				source[i] = target[i];
			}
			
			return source;
		},
		asc : function(binary){
			var obj = new ActiveXObject(config.nameSpace.stream),
				text;
				
				obj.Type = 2
				obj.Open();
				obj.WriteText(binary);
				obj.Position = 0;
				obj.Charset = "ascii";
				obj.Position = 2;
				text = obj.ReadText;
				
			return {obj : obj, text : text};
		},
		spliteLine : function(text){
			return text.substring(0, text.indexOf("\r\n"));
		},
		saveFile : function(copyBack, start, end, path){
			var obj = new ActiveXObject(config.nameSpace.stream);
				obj.Type = 1;
				obj.Mode = 3;
				obj.Open();
				copyBack.Position = start + 2;
				copyBack.CopyTo(obj, end - start);
				obj.SaveToFile(path, 2);
				obj.Close();
				obj = null;
		},
		randoms : function(l){
			var Str = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", 
				tmp = "";
				
			for( var i = 0 ; i < l ; i++ ) { 
				tmp += Str.charAt( Math.ceil(Math.random() * 100000000) % Str.length ); 
			}
			
			return tmp;
		},
		selectPath : function(filename, folder, exts){

			function checkExt(_ext){
				if ( exts === "*" ){
					return true;
				}else{
					var x = false;
					if ( typeof exts === "string" ){
						exts = [exts];	
					}
					
					for ( var i = 0 ; i < exts.length ; i++ ){
						if ( exts.toLowerCase() === _ext.toLowerCase() ){
							x = true;
							break;
						}
					}
					
					return x;
				}
			}
			
			function checkName(folder){
				if ( folder === "" ){
					return folder;
				}else{
					return folder.replace(/\/$/, "") + "/";
				}
			}

			var ext = filename.split(".").slice(-1).join("."),
				ret = { allow : false, ext : ext };

			if ( checkExt(ext) ){
				ret.name = checkName(folder) + this.randoms(16) + "." + ext;
				ret.path = selector.lock(ret.name);
				ret.allow = true;
			}else{
				ret.error = "不符合上传类型";
			}
			
			return ret;
		},
		binaryToText : function(object, start, end){
			var obj = new ActiveXObject(config.nameSpace.stream), ret;
				obj.Type = 2;
				obj.Open();
				object.Position = start + 2;
				object.CopyTo(obj, end - start);
				obj.Position = 2;
				ret = obj.ReadText();
				obj.Close();
				obj = null;
			
			return ret;
		}
	}
	
	
	custom.upload = function(h5Container, options){
		function checkExt(_ext, exts){
			if ( exts === "*" ){
				return true;
			}else{
				var x = false;
				if ( typeof exts === "string" ){
					exts = [exts];	
				}
				
				for ( var i = 0 ; i < exts.length ; i++ ){
					if ( exts[i].toLowerCase() === _ext.toLowerCase() ){
						x = true;
						break;
					}
				}
				
				return x;
			}
		}
		
		var name = /name=\"([^\"]+)\"/.exec(h5Container);
		if ( name && name[1] ){
			name = name[1];
		}else{
			name = "";
		}
		
		var filename = /filename=\"([^\"]+)\"/.exec(h5Container);
		if ( filename && filename[1] ){
			filename = filename[1];
		}else{
			filename = "";
		}
		
		var newFileExt = filename.split(".").slice(-1).join(""),
			newFile = this.randoms(16);

		if ( checkExt(newFileExt, options.allowExt) ){
		
			var newFilename = options.saveTo + "/" + newFile + "." + newFileExt,
				newFleSize = Request.TotalBytes;

			try{
				var obj = new ActiveXObject(config.nameSpace.stream);
					obj.Type = 1;
					obj.Mode = 3;
					obj.Open();
					obj.Write(this.readBinary(options.speed));
					obj.Position = 0;
					obj.SaveToFile(selector.lock(newFilename), 2);
					obj.Close();
					obj = null;	
					
				return {
					success: true,
					data: {
						src: newFilename,
						file: newFile + "." + newFileExt,
						ext: newFileExt,
						size: newFleSize
					}
				}
				
			}catch(e){
				return {
					success: false,
					error: e.message
				}
			}
		}else{
			return {
					success: false,
					error: "文件类型被禁止上传"
				}
		}
	}
	
	var upload = function(options){
		options = custom.extend({
			speed : 1000,
			saveTo : "profile/uploads",
			allowExt : "*",
			error : null
		}, options);
		
		var h5Container = String(Request.ServerVariables("HTTP_CONTENT_DISPOSITION"));
			canH5Upload = h5Container.length !== 0;
		
		if ( canH5Upload ){
			return custom.upload(h5Container, options);
		}

		var binary = custom.readBinary(options.speed),
			ascObject = new ActiveXObject(config.nameSpace.stream);
			ascObject.Type = 2;
			ascObject.Open();
			ascObject.WriteText(binary);
			ascObject.Position = 0;
			ascObject.Charset = "ascii";
			ascObject.Position = 2;
			
		var ascText = ascObject.ReadText,
			line = custom.spliteLine(ascText),
			lineLength = line.length + 2;
		
		var resetChunkData = ascText.substring(lineLength),
			currentChunkData, 
			index,
			ContentDispositionChunkData,
			binaryChunkData,
			start = lineLength,
			reture = {};

		while ( (index = resetChunkData.indexOf(line)) > -1 ){
			var tmp = 0,
				name;
			
			currentChunkData = resetChunkData.substring(0, index);
			
			tmp = currentChunkData.indexOf("\r\n\r\n");
			ContentDispositionChunkData = currentChunkData.substring(0, tmp);
			
			name = (/\sname=\"([^\"]+?)\"/.exec(ContentDispositionChunkData))[1];
			
			if ( reture[name] === undefined ){
				reture[name] = {
					binaryStart : start + tmp + 4,
					binaryEnd : start + index - 2
				}
			}
			
			if ( /\sfilename=\"([^\"]+?)\"/.test(ContentDispositionChunkData) ){
				reture[name]["isFile"] = true;
				reture[name]["fileName"] = (/\sfilename=\"([^\"]+?)\"/.exec(ContentDispositionChunkData))[1];
			}else{
				reture[name]["isFile"] = false;
			}

			resetChunkData = resetChunkData.substring(index + lineLength);
			start = start + index + lineLength;
		}
		
		for ( var items in reture ){
			if ( reture[items]["isFile"] === true ){
				var thisFilename = reture[items]["fileName"];
				if ( thisFilename.length > 0 ){
					var	thisFilepath = custom.selectPath(thisFilename, options.saveTo, options.allowExt);
						
					if ( thisFilepath.allow === true ){
						custom.saveFile(ascObject, reture[items]["binaryStart"], reture[items]["binaryEnd"], thisFilepath.path);
						reture[items]["fileSize"] = reture[items]["binaryEnd"] - reture[items]["binaryStart"];
						reture[items]["fileExt"] = thisFilepath.ext;
						reture[items]["savePath"] = thisFilepath.path;
						reture[name]["saveName"] = thisFilepath.name;
						reture[items]["success"] = true;
					}else{
						reture[items]["success"] = false;
						(typeof options.error === "function") && options.error.call(reture[items], thisFilepath.error);
					}
				}
			}else{
				reture[items]["value"] = ascText.substring(reture[items]["binaryStart"], reture[items]["binaryEnd"]);
			}
		}
		
		ascObject.Close();
		ascObject = null;
		
		
		return reture;
		
	}
	
	return upload;
});
%>