<!--#include file="../config.asp" -->
<%
http.service(function( req, dbo, sap ){
	this.normal = function(){
		var title = req.form.title,
			description = req.form.description,
			nickname = req.form.nickname,
			website = req.form.website,
			webstatus = req.form.webstatus,
			articleprivewlength = req.form.articleprivewlength,
			articleperpagecount = req.form.articleperpagecount,
			webdescription = req.form.webdescription,
			webkeywords = req.form.webkeywords,
			authoremail = req.form.authoremail,
			seotitle = req.form.seotitle,
			commentaduit = req.form.commentaduit,
			commentperpagecount = req.form.commentperpagecount,
			gravatarS = req.form.gravatarS,
			gravatarR = req.form.gravatarR,
			gravatarD = req.form.gravatarD,
			uploadimagetype = req.form.uploadimagetype,
			uploadlinktype = req.form.uploadlinktype,
			uploadswftype = req.form.uploadswftype,
			uploadmediatype = req.form.uploadmediatype,
			binarywhitelist = req.form.binarywhitelist,
			canregister = req.form.canregister,
			commentvaildor = req.form.commentvaildor,
			commentdelaytimer = req.form.commentdelaytimer,
			commentmaxlength = req.form.commentmaxlength,
			error = "处理过程中发生错误。";
			
		if ( commentaduit === "1" ){
			commentaduit = true;
		}else{
			commentaduit = false;
		}
		
		if ( commentvaildor === "1" ){
			commentvaildor = true;
		}else{
			commentvaildor = false;
		}
		
		if ( isNaN(commentdelaytimer) ){
			return {
				success: false,
				error: "评论延迟时长必须为数字"
			}
		}
		
		commentdelaytimer = Number(commentdelaytimer);
		
		if ( commentdelaytimer <= 0 ){
			return {
				success: false,
				error: "评论延迟时长必须大于零"
			}
		}
		
		if ( isNaN(commentmaxlength) ){
			return {
				success: false,
				error: "评论字数限制必须为数字"
			}
		}
		
		commentmaxlength = Number(commentmaxlength);
		
		if ( commentmaxlength <= 0 ){
			return {
				success: false,
				error: "评论字数限制必须大于零"
			}
		}
			
		var insSQLData = {
			title: title,
			description: description,
			nickname: nickname,
			website: website,
			webstatus: webstatus,
			articleprivewlength: articleprivewlength,
			articleperpagecount: articleperpagecount,
			webdescription: webdescription,
			webkeywords: webkeywords,
			authoremail: authoremail,
			seotitle: seotitle,
			commentaduit: commentaduit,
			commentperpagecount: commentperpagecount,
			gravatarS: gravatarS,
			gravatarR: gravatarR,
			gravatarD: gravatarD,
			uploadimagetype: uploadimagetype,
			uploadlinktype: uploadlinktype,
			uploadswftype: uploadswftype,
			uploadmediatype: uploadmediatype,
			binarywhitelist: binarywhitelist,
			canregister: canregister,
			commentvaildor: commentvaildor,
			commentdelaytimer: commentdelaytimer,
			commentmaxlength: commentmaxlength
		}
			
		sap.proxy("system.global.save.begin", insSQLData);
		
		dbo.update({
			table: "blog_global", 
			conn: config.conn, 
			key: "id", 
			keyValue: "1",
			data: insSQLData
		});
		
		var cache = require.async("cache");
			cache.build("global");
				
		sap.proxy("system.global.save.end");
		
		return {
			success: true,
			error: error
		}
	}
	
	this.password = function(){
		var oldpass = req.form.oldpass,
			newpass = req.form.newpass,
			repass = req.form.repass,
			checked = false,
			fns = require("fn"),
			SHA1 = require("SHA1");
			
		dbo.trave({
			conn: config.conn,
			sql: "Select * From blog_global Where id=1",
			callback: function(rs){
				if ( SHA1(oldpass + rs("salt").value) === rs("hashkey").value ){
					checked = true;
				}
			}
		});
		
		if ( checked === false ){
			return {
				success: false,
				error: "旧密码验证不正确"
			}
		}
		
		if ( newpass !== repass ){
			return {
				success: false,
				error: "两次密码输入不相同"
			}
		}
		
		var salt = fns.randoms(6);
	
		dbo.update({ data: {
			hashkey: SHA1(newpass + salt),
			salt: salt
		}, table: "blog_global", conn: config.conn, key: "id", keyValue: "1" });
		
		return {
			success: true
		};
	}
});
%>