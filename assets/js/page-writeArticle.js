// JavaScript Document
define(['editor', 'form', 'overlay', 'upload'], function(require, exports, module){
	
	var sending = false;
	
	$.loading = function(options){
		options.content = '<div class="dialog fn-clear"><div class="close"></div><div id="postingbox" style="width:250px; text-align: center; color: #777;">' + options.word + '</div></div>';
		$.overlay(options);
	}
	
	function init_choose_cates(){
		
		if ( $(".choose-current").size() > 0 ){
			$(".ui-position-tools").text($(".choose-current td:eq(" + $(".choose-current").attr("data-eq") + ")").text());
		}
		
		$("body").on("click", ".choose-cate", function(){
			var trParent = $(this).parents("tr:first");
			$(".side-category tr").removeClass("choose-current");
			trParent.addClass("choose-current");
			$("input[name='log_category']").val($(this).attr("data-id"));
			$(".ui-position-tools").text(trParent.find("td").eq(Number(trParent.attr("data-eq"))).text());
		});
	}
	
	function tipPopUp( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	function init_postArticle(){
		function closeStatusBox(word){
			$("#postingbox").html(word);
			var _this = this;
			setTimeout(function(){
				$(_this).find(".close").trigger("click");
			}, 2000);
		}
		
		$("#submit").on("click", function(){
			$.loading({
				effect: "deformationZoom", 
				word: '正在收集数据...',
				callback: function(){
					var content = $("textarea[name='log_content']").val();
						content = init_articleCut(content, articleCut || 300);
						$("#postingbox").html("正在生成预览文本...");
						content = init_autoCompleteHTMLCode(content),
						_this = this;
						
					$("#postingbox").html("正在插入预览文本资源...");
					$("textarea[name='log_shortcontent']").val(content.replace(/\<textarea([\s\S]+?)\<\/textarea\>/ig, "&lt;textarea$1&lt;/textarea&gt;"));
					
					$("form").ajaxSubmit({
						dataType: "json",
						beforeSubmit: function(){
							$("#postingbox").html("正在发送数据到服务器...");
							
							if ( $("input[name='log_title']").val().length === 0 ){
								closeStatusBox.call(_this, "亲，您还没有填写标题呢！");
								return false;
							}
							
							if ( $("input[name='log_category']").val().length === 0 ){
								closeStatusBox.call(_this, "亲，您还没有选择分类呢！");
								return false;
							}
							
							if ( $("textarea[name='log_content']").val().length === 0 ){
								closeStatusBox.call(_this, "亲，您不打算写日志了吗？");
								return false;
							}
						},
						success: function(jsons){
							if ( jsons && jsons.success ){
								closeStatusBox.call(_this, "保存日志成功了。");
								if ( $("form input[name='id']").val().length === 0 ) { 
									$("form").resetForm();
									$(".ui-position-tools").text("");
									$(".choose-current").removeClass("choose-current");
									$("input[name='log_category'], input[name='log_oldCategory']").val('');
									$("#cover-img").attr("src", "_blank");
									$("input[name='log_cover']").val("");
								}
							}else{
								closeStatusBox.call(_this, jsons.error);
							}
						},
						error: function(){
							closeStatusBox.call(_this, "保存日志遇到错误，可能由于你发表的文章内容过长。");
						}
					});
				}
			});
		});
	}
	
	function init_articleCut(text, n){
		var r = 0, 
			v = "",
			b = true,
			t = 0;
			
		for ( var i = 0 ; i < text.length ; i++ ){
			if ( r + 1 < n ){
				var value = text.charAt(i);
					v += value;
					
				switch ( value ){
					case "<":
						b = false;
						t = 1;
						break;
					case ">":
						b = true;
						t = 0;
						break;
					case "&":
						b = false;
						t = 2;
						break;
					case ";":
						if ( t === 2 ){
							b = true;
							r++;
							t = 0;
						}
						break;
					default:
						if ( b === true ){
							r++;
						}
				}
				
			}else{
				break;
			}
		}
		
		return v;
	}
	
	function init_autoCompleteHTMLCode(text, callback){
		var iframe = document.createElement("iframe");
			$(iframe).appendTo("body");
			iframe.contentWindow.document.open(); 
			iframe.contentWindow.document.writeln(text); 
			iframe.contentWindow.document.close();
			text = iframe.contentWindow.document.body.innerHTML;
			$(iframe).remove();
			if ( $.isFunction(callback) ){
				return callback(text);
			}else{
				return text;
			}
	}
	
	function init_editor(){
		$("textarea[name='log_content']").xheditor({
			skin: "nostyle",
			upLinkUrl: 	config.ajaxUrl.server.editorUpload,
			upLinkExt: 	uploadlinktype,
			upImgUrl:  	config.ajaxUrl.server.editorUpload,
			upImgExt:  	uploadimagetype,
			upFlashUrl: config.ajaxUrl.server.editorUpload,
			upFlashExt: uploadswftype,
			upMediaUrl: config.ajaxUrl.server.editorUpload,
			upMediaExt: uploadmediatype
		});
	}
	
	function bindCoverEvent(){
		var ext = uploadimagetype.split(","),
			cons = [];
			
		for ( var i = 0 ; i < ext.length ; i++ ){
			cons.push("*." + ext[i] + ";");
		}
		
		$("#upload").upload({
			auto: true,
			buttonText: "请选择封面图片",
			uploader: config.ajaxUrl.server.editorUpload,
			multi: false,
			fileTypeExts: cons.join(""),
			onUploadSuccess: function(file, data, response){
				var imgURL = $.parseJSON(data).msg.replace(/^\!/, "");
				$("#cover-img").attr("src", imgURL);
				$("input[name='log_cover']").val(imgURL);
			}
		});
	}
	
	return {
		init: function(){
			init_choose_cates();
			init_editor();
			init_postArticle();
			bindCoverEvent();
		}
	}
});