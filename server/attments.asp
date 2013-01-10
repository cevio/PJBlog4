<!--#include file="../config.asp" -->
<%
	http.service(function( req, dbo, sap ){
		this.getserverpictures = function(){
			var page = req.query.page, arr = [], pageInfo, pagebar;
			if ( !page || page.length === 0 ){
				page = 1;
			}else{
				if ( isNaN(page) ){
					page = 1;
				}else{
					page = Number(page);
				}
			};
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_attachments Order By attachuploadtime DESC",
				callback: function(){
					pageInfo = this.serverPage(page, 10, function(){
						var exts = this("attachext").value.toLowerCase(),
							_exts = ["jpg", "bmp", "png", "gif", "jpeg"];
							
						if ( _exts.indexOf(exts) > -1 ){
							arr.push({
								id: this("id").value,
								ext: this("attachext").value,
								size: this("attachsize").value,
								path: this("attachpath").value,
								count: this("attachviewcount").value,
								time: this("attachuploadtime").value,
								name: this("attachfilename").value
							});
						}
					});
				}
			});
			
			if ( pageInfo.length > 0 ){
				if ( pageInfo[3] > 1 ){
					var fns = require.async("fn"),
						pages = fns.pageAnalyze(pageInfo[2], pageInfo[3], 9);
						pagebar = pages;
				}
			}
			
			return {
				lists: arr,
				pages: pagebar
			}
		}
	});
%>