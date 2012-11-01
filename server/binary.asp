<!--#include file="../config.asp" -->
<%
(function(){
	var cache = require("cache"),
		attachmentsCache = cache.load("attachments"),
		attachmentsJSON = {},
		id = http.get("id"),
		file, 
		fileBinaryData,
		ext,
		size,
		ContentType,
		whiteAllowIPArray = [];
		
	function CHECKURLREFERER(){
		var refererURL = String(Request.ServerVariables("SERVER_NAME")),
			rets = false,
			whiteDomain;

		if ( refererURL && refererURL.length > 0 ){
			whiteDomain = refererURL;
		}else{
			return false;
		}
			
		for ( var i = 0 ; i < whiteAllowIPArray.length ; i++ ){
			if ( whiteAllowIPArray[i].toLowerCase() === whiteDomain.toLowerCase() ){
				rets = true;
				break;
			}
		}
		
		return rets;
	}
	
	function fillWhiteList(){
		var list = cache.load("global"),
			listStr = list[0][25];
			
		whiteAllowIPArray = listStr.split(",");
	}
	
	if ( id.length > 0 ){
		
		fillWhiteList();
		if ( !CHECKURLREFERER() ){
			return;
		}
		
		for ( var i = 0 ; i < attachmentsCache.length ; i++ ){
			attachmentsJSON[attachmentsCache[i][0] + ""] = {
				path: attachmentsCache[i][2], 
				ext: attachmentsCache[i][1],
				size: attachmentsCache[i][3]
			};
		}
		
		if ( attachmentsJSON[id + ""] !== undefined ){
			file = attachmentsJSON[id + ""].path;
			ext = attachmentsJSON[id + ""].ext;
			size = attachmentsJSON[id + ""].size;
			
			var stream = new ActiveXObject(config.nameSpace.stream);
				stream.Type = 1;
				stream.Mode = 3;
				stream.Open();
				stream.Position = 0;
				stream.LoadFromFile(selector.lock("profile/uploads/" + file));
				fileBinaryData = stream.Read();
				stream.Close();
				stream = null;
				
			switch ( ext ){
				case "asf":
    				ContentType = "video/x-ms-asf";
					break;
    			case "avi":
    				ContentType = "video/avi";
					break;
    			case "doc":
    				ContentType = "application/msword";
					break;
    			case "zip":
    				ContentType = "application/zip";
					break;
    			case "xls":
    				ContentType = "application/vnd.ms-excel";
					break;
    			case "gif":
    				ContentType = "image/gif";
					break;
    			case "jpg":
    				ContentType = "image/jpeg";
					break;
				case "jpeg":
    				ContentType = "image/jpeg";
					break;
    			case "wav":
    				ContentType = "audio/wav";
					break;
    			case "mp3":
    				ContentType = "audio/mpeg3";
					break;
    			case "mpg":
    				ContentType = "video/mpeg";
					break;
				case "mpeg":
    				ContentType = "video/mpeg";
					break;
    			case "rtf":
    				ContentType = "application/rtf";
					break;
    			case "htm":
    				ContentType = "text/html";
					break;
				case "html":
    				ContentType = "text/html";
					break;
    			case "asp":
    				ContentType = "text/asp";
					break;
    			default:
    				ContentType = "application/octet-stream";
			}
			
			Response.AddHeader("Content-Length", size);
			Response.Charset = "UTF-8";
			Response.ContentType = ContentType;
			
			Response.BinaryWrite(fileBinaryData);
			Response.Flush();
			
		}
	}
})();
%>