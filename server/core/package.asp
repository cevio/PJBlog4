<%
define(function(require, exports, module){
	var xml = require("XML"),
		fso = require("FSO"),
		stream = require("STREAM");
		
	exports.merge = function(folder, savePath, filterCallback){
		var fso_object = fso.createFSO(),
			xml_object = (function(){
				var obj;
				try{ 
					obj = new ActiveXObject("Microsoft.XMLDOM"); 
				}catch(e){ 
					obj = new ActiveXObject("Msxml2.DOMDocument.5.0"); 
				}
				return obj;
			})(),
			fso_folders = fso.collects(folder, fso_object),
			fso_files = (function(){
				var files = [];
				
				for ( var i = 0 ; i < fso_folders.length ; i++ ){
					files = files.concat(fso.collect(fso_folders[i], false, function(name){
						if ( /^\./.test(name) ){
							return null;
						}else{
							return path === "/" ? "/" + name : fso_folders[i] + "/" + name;
						}
					}, fso_object));
				}
				
				files = files.concat(fso.collect(folder, false, function(name){
					if ( /^\./.test(name) ){
						return null;
					}else{
						return path === "/" ? "/" + name : folder + "/" + name;
					}
				}, fso_object));
				
				return files;
			})(),
			packageXml = '<?xml version="1.0"?><package xmlns:dt="urn:schemas-microsoft-com:datatypes"><list><folders></folders><files></files></list></package>',
			xmlRet = xml.load(packageXml);
			
			if ( xmlRet !== null ){
				var list = xml("list", xmlRet.root, xmlRet.object).attr({
						folders: fso_folders.length,
						files: fso_files.length
					}),
					folders = list.find("folders"),
					files = list.find("files"),
					i = 0, 
					path, 
					_path;
		
				function binary2base64(path){
					var temp = xml_object.createElement("file"),
						binary = stream.load(path, true);
						temp.dataType = "bin.base64";
						temp.nodeTypedValue = binary;
					return temp.text;
				}
					
				for ( i = 0 ; i < fso_folders.length ; i++ ){
					path = fso_folders[i];
					
					if ( typeof filterCallback === "function" ){
						path = filterCallback(path);
					}
					
					folders.create("item").html(path);
				}
				
				for ( i = 0 ; i < fso_files.length ; i++ ){
					path = fso_files[i];
					_path = path;
					
					if ( typeof filterCallback === "function" ){
						path = filterCallback(path);
					}
					
					files.create("item").attr("path", path).html(binary2base64(_path));
				}
				
				list.save(savePath);
			}else{
				console.push(packageXml + " 打开失败");
			}
	}
	
	exports.separate = function(file, folder, callback){
		var xmlRet = xml.load(file),
			xml_object = (function(){
				var obj;
				try{ 
					obj = new ActiveXObject("Microsoft.XMLDOM"); 
				}catch(e){ 
					obj = new ActiveXObject("Msxml2.DOMDocument.5.0"); 
				}
				return obj;
			})();
		
		if ( xmlRet !== null ){
			var list = xml("list", xmlRet.root, xmlRet.object),
				folders = list.find("folders item"),
				files = list.find("files item");
				
			function base642binary(base64){
				var temp = xml_object.createElement("file");
					temp.dataType = "bin.base64";
					temp.text = base64;	
				return temp.nodeTypedValue;
			}
			
			folders.each(function(){
				var xmlQuery = xml("", this, list.object),
					path = (folder === "/" ? "/" : folder + "/") + xmlQuery.html();
					
				if ( typeof callback === "function" ){
					callback(path);
				}
				
				fso.create(path);
			});
			
			files.each(function(){
				var xmlQuery = xml("", this, list.object),
					base64 = xmlQuery.html(),
					path = (folder === "/" ? "/" : folder + "/") + xmlQuery.attr("path"),
					binary = base642binary(base64);
					
				if ( typeof callback === "function" ){
					callback(path);
				}
					
				stream.save(binary, path, true);
			});
			
		}else{
			console.push(packageXml + " 打开失败");
		}
	}
});
%>