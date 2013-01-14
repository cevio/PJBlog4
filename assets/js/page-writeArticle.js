// JavaScript Document
define(['editor', 'form', 'overlay', 'upload'], function(require, exports, module){
	
	var sending = false;
	
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
	
	function bindChoose(pagenumber){
		$("#choose").on("click", function(){
			bindChooseList(1);
		});
	}
	
	function bindChooseList(pagenumber){
		pagenumber = pagenumber === undefined ? 1 : pagenumber;
		var hasbox = $(".choosebox").size() > 0;
		$.getJSON(config.ajaxUrl.server.getServerPictures, {page: pagenumber}, function(params){
			var s = '<div class="choosebox"><ul class="fn-clear">抱歉，没有找到任何数据！</ul><div class="page fn-clear"></div></div>', p = "", html = "";
			if ( params && params.lists.length > 0 ){
				for ( var i = 0 ; i < params.lists.length ; i++ ){
					html += '<li class="fn-left" data-img="server/binary.asp?id=' + params.lists[i].id + '"><img src="server/binary.asp?id=' + params.lists[i].id + '" onerror="$(this).parent().remove();" /></li>';
				}
				s = '<div class="choosebox"><ul class="fn-clear">' + html + '</ul><div class="page fn-clear"></div></div>';
				if ( params && params.pages ){
					if ( params.pages.to - params.pages.from > 0 ){
						for ( var j = params.pages.from ; j <= params.pages.to ; j++ ){
							if ( j === params.pages.current ){
								p += '<span>' + j + '</span>';
							}else{
								p += '<a href="javascript:;" class="choosepage" data-page="' + j + '">' + j + '</a>';
							}
						}
					}
				}
			}
			
			if ( hasbox ){
				$(".choosebox ul").html(html);
				$(".choosebox .page").html(p);
			}else{
				$.openbox({
					effect: "deformationZoom", 
					word: s,
					callback: function(){
						var _this = this;
						$(_this).find(".page").show().html(p);
					}
				});
			}
		});
	}
	
	function bindChoosePage(){
		$("body").on("click", ".choosebox .page a.choosepage", function(){
			var i = $(this).attr("data-page");
				i = Number(i);
				bindChooseList(i);
		});
	}
	
	function bindPICCLICK(_this, callback){
		$("body").on("click", ".choosebox ul li", function(){
			var img = $(this).attr("data-img");
			$("input[name='log_cover']").val(img);
			$("#cover-img").attr("src", img);
			$(".fixed").find(".close:first").trigger("click");
		});
	}
	
	function bindClean(){
		$("#clean").on("click", function(){
			$("input[name='log_cover']").val('');
			$("#cover-img").attr("src", "_blank");
		});
	}
	
	return {
		init: function(){
			init_choose_cates();
			init_editor();
			init_postArticle();
			bindCoverEvent();
			bindChoose();
			bindClean();
			bindChoosePage();
			bindPICCLICK();
		}
	}
});