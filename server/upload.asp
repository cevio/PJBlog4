<!--#include file="../config.asp" -->
<%

require(["UPLOAD", "DATE", "FSO"], function(upload, _date, fso){
	if ( Session("admin") === true ){
		var dbo = require("DBO"),
			connecte = require("openDataBase");
			
		if ( connecte === true ){
			var extArray = [];
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_global Where id=1",
				callback: function(rs){
					extArray.push(
						rs("uploadimagetype").value, 
						rs("uploadswftype").value, 
						rs("uploadmediatype").value, 
						rs("uploadlinktype").value
					);
				}
			});
			
			extArray = extArray.join(",");
		
			var folder = "profile/uploads/" + _date.format(new Date(), "ymd");
			
			if ( !fso.exsit(folder) ){
				fso.create(folder);
			}
			
			var route = upload({
				saveTo : folder,
				allowExt : extArray.split(",")
			});
			
			if ( String(Request.QueryString("immediate")) === "1" ){
				route.msg = "!" + route.msg;
			}
			
			console.log(JSON.stringify(route));
		}else{
			console.log(JSON.stringify({
				success: false,
				error: "打开数据库失败"
			}));
		}
	}else{
		console.log(JSON.stringify({
			success: false,
			error: "没有上传权限"
		}));
	}
});
CloseConnect();
%>