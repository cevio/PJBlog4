// JavaScript Document
define(function( require, exports, module ){
	
	var isMakingData = false;
	
	function checkVersion( versions ){
		var localVersionArr = config.version.split("."),
			platfVersionArr = versions.split("."),
			isUpdating = false;
			
		for ( var i = 0 ; i < platfVersionArr.length ; i++ ){
			var n = Number(platfVersionArr[i]),
				m = Number(localVersionArr[i]);
				
			if ( n > m ){
				isUpdating = true;
				break;
			}
		}
		
		return isUpdating;
	}
	
	function addLine(html){
		$(".update-list").append('<li>' + html + '</li>');
	}
	
	function getPackage(packname){
		if ( isMakingData === false ){
			isMakingData = true;
			addLine('正在获取更新文件包 ' + packname + ' ..');
			$.getJSON(config.ajaxUrl.server.package, {packname: packname}, function( params ){
				isMakingData = false;
				if ( params && params.success ){
					addLine('获取远程资源文件包成功(' + packname + ') ..');
					unpack(packname);
				}else{
					addLine('获取远程资源文件包失败，请前往论坛求助下载最新程序。');
				}
			});
		}
	}
	
	function unpack(packname){
		if ( isMakingData === false ){
			isMakingData = true;
			addLine('正在解压资源包到目录 ..');
			$.getJSON(config.ajaxUrl.server.unpack, {packname: packname}, function( params ){
				isMakingData = false;
				if ( params && params.success ){
					addLine('解压资源成功 ..');
					clearCache();
				}else{
					addLine(params.error);
				}
			});
		}
	}
	
	function openUpdateBox(params){
		var html = '<div class="update-header">新版本升级</div><span class="close"></span><ul class="update-list"><li>可升级至版本 v' + params.toVersion + ' ..</li></ul>';
		require.async("overlay", function(){
			$.updateBox({
				content: html,
				effect: "deformationZoom",
				callback: function(){
					getPackage(params.package);
				}
			});
		});
	}
	
	function clearCache(){
		if ( isMakingData === false ){
			isMakingData = true;
			addLine('正在清理服务器缓存 ..');
			$.getJSON(config.ajaxUrl.server.cache, {}, function( params ){
				isMakingData = false;
				if ( params && params.success ){
					addLine('恭喜，升级成功！3秒后自动关闭本提示框。');
					setTimeout(function(){
						$(".ui-updatebox").find(".close").trigger("click");
						setTimeout(function(){
							window.location.reload();
						}, 1000);
					}, 3000)
				}else{
					addLine('抱歉，升级失败了！');
				}
			});
		}
	}
	
	$(function(){
		var params = config.update;
		if ( (config.limits.admin === true) && (checkVersion(params.version) === true) ){
			if ( params.list && params.list[config.version] ){
				$("#updateversionnumber").text(" v " + params.list[config.version].toVersion);
				$("#hurryUpdate").on("click", function(){
					openUpdateBox(params.list[config.version]);
				});
				$("#updateclose").on("click", function(){
					$(".ui-updateArea").slideUp("slow");
				});
				$("#viewupdateinfo").attr("href", params.list[config.version].url);
				$(".ui-updateArea").slideDown("slow");
			}
		}
	});
});