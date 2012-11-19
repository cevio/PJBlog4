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
		whiteAllowIPArray = [String(Request.ServerVariables("SERVER_NAME"))],
		needForbit = true;

	function CHECKURLREFERER(){
		var refererURL = String(Request.ServerVariables("HTTP_REFERER")),
			refererExec = /http(s)?\:\/\/([^\/]+)(\/.+)?/.exec(refererURL),
			rets = false,
			whiteDomain;

		if ( refererExec && refererExec[2] ){
			whiteDomain = refererExec[2];
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
			listStr = list.binarywhitelist;
		
		try{
			whiteAllowIPArray = listStr.split(",").concat(whiteAllowIPArray);
		}catch(e){}
	}
	
	if ( id.length > 0 ){
		
		fillWhiteList();

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
					needForbit = false;
					break;
    			case "jpg":
    				ContentType = "image/jpeg";
					needForbit = false
					break;
				case "jpeg":
    				ContentType = "image/jpeg";
					needForbit = false;
					break;
				case "png":
    				ContentType = "image/png";
					needForbit = false;
					break;
				case "bmp":
    				ContentType = "image/bmp";
					needForbit = false;
					break;
				case "gif":
    				ContentType = "image/gif";
					needForbit = false;
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
			
			if ( needForbit && !CHECKURLREFERER() ){
				console.log("Prohibit Hotlinking!");
				return;
			}
			
			var stream = new ActiveXObject(config.nameSpace.stream);
				stream.Type = 1;
				stream.Mode = 3;
				stream.Open();
				stream.Position = 0;
				stream.LoadFromFile(selector.lock("profile/uploads/" + file));
				fileBinaryData = stream.Read();
				stream.Close();
				stream = null;
			
			Response.AddHeader("Content-Length", size);
			Response.Charset = "UTF-8";
			Response.ContentType = ContentType;
			
			Response.BinaryWrite(fileBinaryData);
			Response.Flush();
			
		}
	}
})();
%>