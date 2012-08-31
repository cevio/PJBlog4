<%
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
		selectorPath : function(){
			
		}
	}
	
	var upload = function(options){
		options = custom.extend({
			speed : 1000,
			saveTo : "profile/uploads"
		}, options);
		
		var binary = custom.readBinary(options.speed),
			ascObject = new ActiveXObject(config.nameSpace.stream);
			ascObject.Type = 2
			ascObject.Open();
			ascObject.WriteText(binary);
			ascObject.Position = 0;
			ascObject.Charset = "ascii";
			ascObject.Position = 2;
			
		var ascText = ascObject.ReadText,
			line = custom.spliteLine(ascText),
			lineLength = line.length + 2;
			
		console.log(ascText)
			
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

				var tmpText = ascText,
					filenameStart = start + ContentDispositionChunkData.indexOf("filename=\"") + 10,
					filenameEnd = filenameStart + tmpText.substring(filenameStart).indexOf("\"");
				
				reture[name]["fileNameStart"] = filenameStart;
				reture[name]["fileNameEnd"] = filenameEnd;
			}else{
				reture[name]["isFile"] = false;
			}

			resetChunkData = resetChunkData.substring(index + lineLength);
			start = start + index + lineLength;
		}
		
		console.log(JSON.stringify(reture));
		
		for ( var items in reture ){
			if ( reture[items]["isFile"] === true ){
				var path = custom.selectorPath(options.saveTo);
				custom.saveFile(ascObject, reture[items]["binaryStart"], reture[items]["binaryEnd"], path);
			}
		}
		
		ascObject.Close();
		ascObject = null;
	}
	
	return upload;
});
/*------WebKitFormBoundary5TEhDhkkvNohxkoc\r\n
Content-Disposition: form-data; name="file"; filename="f0e;:ff,ff!#.txt"\r\n
Content-Type: text/plain\r\n\r\n
chat.53kf.com/webCompany.php?arg=\r\ndf\r\na\r\nfsd\r\nf\r\nsf\r\nsadfdsfsdf\r\nsd\r\nfsad\r\nf\r\nsad\r\nf\r\nsad\r\n
------WebKitFormBoundary5TEhDhkkvNohxkoc--\r\n*/
%>