<%
define(function( require, exports, module ){
	var cache = require.async("cache");
	
	exports.commentList = function( logid ){
		var commentLogList = cache.load("artcomm", logid),
			firstTreeList = [],
			firstTreeJson = {},
			lastTreeData = [],
			_this = this;
			
		for ( var i = 0 ; i < commentLogList.length ; i++ ){
			var commentItemData = commentLogList[i],
				id = commentItemData[0],
				commid = commentItemData[1],
				content = commentItemData[3],
				user = _this.commentUsers(commentItemData[2]),
				date = commentItemData[4],
				ip = commentItemData[5],
				aduit = commentItemData[6];
			
			firstTreeList.push(id); // 保证顺序
			
			if ( commid === 0 ){
				if (firstTreeJson[id + ""] === undefined){
					firstTreeJson[id + ""] = {
						id: id,
						commid: commid,
						content: content,
						date: date,
						ip: ip,
						aduit: aduit,
						user: user,
						items: []
					}
				}else{
					firstTreeJson[id + ""].id = id;
					firstTreeJson[id + ""].commid = commid;
					firstTreeJson[id + ""].content = content;
					firstTreeJson[id + ""].date = date;
					firstTreeJson[id + ""].ip = ip;
					firstTreeJson[id + ""].aduit = aduit;
					firstTreeJson[id + ""].user = user;
				}
			}else{
				if ( firstTreeJson[commid + ""] === undefined ){
					firstTreeJson[commid + ""] = {
						items: []
					}
				}
				
				firstTreeJson[commid + ""].items.push({
					id: id,
					commid: commid,
					content: content,
					date: date,
					ip: ip,
					aduit: aduit,
					user: user
				});
			}
		}
		
		for ( var j = 0 ; j < firstTreeList.length ; j++ ){
			if ( firstTreeJson[firstTreeList[j] + ""] !== undefined ){
				lastTreeData.push(firstTreeJson[firstTreeList[j] + ""]);
			}
		}
		
		return lastTreeData;
		
	}
	
	exports.commentUsers = function( id ){
		var user = cache.load("user", id);
		return {
			name: user[0][2],
			photo: user[0][1],
			id: id
		}
	}
	
	exports.commentSubmitUrl = "server/proxy/comment.asp?j=post";
});
%>