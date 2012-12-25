// JavaScript Document
define(['form', 'overlay'], function(require, exports, module){
	
	var isMakingData = false,
		iconList = [];
		
	function popUpTips( words, callback ){
		$.dialog({
			content: words,
			effect: "deformationZoom",
			callback: callback
		});
	}
	
	function addFirstCategory(){
		$("#addFirstCategory").on("click", function(){
			if ( isMakingData === false ){
					isMakingData = true;
					var li = document.createElement("li");
					var html = 		'<div class="data-value fn-clear">'
						+				'<div class="icon fn-left ui-wrapshadow"><img src="profile/icons/' + iconList[0] + '" /></div>'
						+				'<div class="info ui-wrapshadow fn-clear">'
						+					'<div class="submit fn-right"><button class="button submitbutton">保存</button><button class="button cancelbutton">取消</button></div>'
						+					'<div class="action fn-right">'
						+						'<a href="javascript:;" class="ac-add">添加</a>'
						+						'<a href="javascript:;" class="ac-edit">编辑</a>' 
						+						'<a href="javascript:;" class="ac-del">删除</a>'
						+					'</div>'
						+					'<span title=""><input type="text" value="" name="categoryName" class="text" placeholder="分类名称.."></span>'
						+					'<div class="editbox"></div>'
						+				'</div>'
						+			'</div><ul></ul>';
					
					$(this).parents("li:first").before(li);
					$(li).addClass("updating").attr("data-id", "0").attr("data-root", "0").html(html);
			}
		});
	}
	
	function addSecondCategory(){
		$("body").on("click", ".ac-add", function(){
			if ( isMakingData === false ){
				isMakingData = true;
				var li = document.createElement("li");
				var parent = $(this).parents("li:first");
				var ul = parent.find("ul");
				var root = parent.attr("data-id");
				var html = 		'<div class="data-value fn-clear">'
					+				'<div class="icon fn-left ui-wrapshadow"><img src="profile/icons/' + iconList[0] + '" /></div>'
					+				'<div class="info ui-wrapshadow fn-clear">'
					+					'<div class="submit fn-right"><button class="button submitbutton">保存</button><button class="button cancelbutton">取消</button></div>'
					+					'<div class="action fn-right">'
					+						'<a href="javascript:;" class="ac-edit">编辑</a>' 
					+						'<a href="javascript:;" class="ac-del">删除</a>'
					+					'</div>'
					+					'<span title=""><input type="text" value="" name="categoryName" class="text" placeholder="分类名称.."></span>'
					+					'<div class="editbox"></div>'
					+				'</div>'
					+			'</div>';
				
				ul.append(li);
				$(li).addClass("updating").attr("data-id", "0").attr("data-root", root).html(html);
			}
		});
	}
	
	function getIconList(){
		$.getJSON(config.ajaxUrl.server.iconList, {}, function( params ){
			iconList = params
		});
	}
	
	function addNewCategory(){
		$("body").on("click", ".submitbutton", function(){
			var name = $(this).parents(".info:first").find("input[name='categoryName']").val(),
				parent = $(this).parents("li:first"),
				dataValue = parent.find(".data-value:first"),
				root = parent.attr("data-root"),
				_this = this;

			$.getJSON(config.ajaxUrl.server.addNewCategory, {root: root, name: name, icon: iconList[0]}, function( params ){
					isMakingData = false;
				if ( params.success ){
					dataValue.find(".submit:first").remove();
					dataValue.find("span").text(name);
					parent.attr("data-id", params.data.id);
					parent.removeClass("updating");
				}else{
					popUpTips(params.error);
				}  
			});
		});
	}
	
	function destoryCategory(){
		$("body").on("click", ".ac-del", function(){
			if ( isMakingData === false ){
				if ( confirm("确定要删除这条分类吗？\n删除分类的同时将删除该分类下的所有文章，请慎重！") ){
					isMakingData = true;
					var id = $(this).parents("li:first").attr("data-id"),
						_this = this;
						
					$.getJSON(config.ajaxUrl.server.destoryCate, {id: id}, function( params ){
						isMakingData = false;
						if ( params.success ){
							$(_this).parents("li:first").remove();
						}else{
							popUpTips(params.error);
						}
					});
				}
			}
		});
	}
	
	function cancelNewCategory(){
		$("body").on("click", ".cancelbutton", function(){
			var parent = $(this).parents("li:first");
			parent.remove();
			isMakingData = false;
		});
	}
	
	function editCategory(){
		$("body").on("click", ".ac-edit", function(){
			var parent = $(this).parents("li:first"),
				dataValue = parent.find(".data-value:first"),
				id = parent.attr("data-id");
			
			if ( isMakingData === false ){
				isMakingData = true;
				console.log(id);
				$.getJSON(config.ajaxUrl.server.getCateInfo, {id: id}, function(params){
					console.log(params);
					if ( params.success ){
						dataValue.find(".info .action").hide();
						fileInData.call(dataValue, params.data);
					}else{
						popUpTips(params.error);
					}
				});	
			}	
		});
	}
	
	function fileInData(data){
		var _this = this;
		var editbox = this.find(".editbox");
		var html = 	'<div class="edit-area">'
			+			'<div class="edit-zone">'
			+				'<div class="title fn-clear"><span class="fn-left">编辑该分类</span></div>'
			+				'<div class="context">'
			+					'<form action="' + config.ajaxUrl.server.updateCate + '" method="post">'
			+						'<input type="hidden" value="' + data.id + '" name="id" />'
			+						'<input type="hidden" value="' + data.cateRoot + '" name="cateRoot" />'
			+						'<input type="hidden" value="' + data.cateIcon + '" name="cateIcon" />'
			+						'<table cellspacing="0" class="table">'
			+							'<tr>'
			+								'<td>分类名</td>'
			+								'<td><input type="text" value="" name="cateName" class="long"></td>'
			+							'</tr>'
			+							'<tr>'
			+								'<td>分类说明</td>'
			+								'<td><input type="text" value="" name="cateInfo" class="long"></td>'
			+							'</tr>'
			+							'<tr>'
			+								'<td>分类排序</td>'
			+								'<td><input type="text" value="" name="cateOrder" class="shorter"></td>'
			+							'</tr>'
			+							'<tr>'
			+								'<td>日志数</td>'
			+								'<td><input type="text" value="" name="cateCount" class="shorter"></td>'
			+							'</tr>'
			+							'<tr>'
			+								'<td>是否隐藏</td>'
			+								'<td>'
			+									'<input type="radio" value="1" name="cateIsShow"> 隐藏 '
			+									'<input type="radio" value="0" name="cateIsShow"> 显示 '
			+								'</td>'
			+							'</tr>'
			+							'<tr>'
			+								'<td>是否外链</td>'
			+								'<td>'
			+									'<input type="radio" value="1" name="cateOutLink"> 是 '
			+									'<input type="radio" value="0" name="cateOutLink"> 否 '
			+								'</td>'
			+							'</tr>'
			+							'<tr>'
			+								'<td>外链地址</td>'
			+								'<td><input type="text" value="" name="cateOutLinkText" class="longer"></td>'
			+							'</tr>'
			+							'<tr>'
			+								'<td>&nbsp;</td>'
			+								'<td><input type="submit" value="保存" class="button" /> <input type="button" value="取消" class="button close" /></td>'
			+							'</tr>'
			+						'</table>'
			+					'</form>'
			+				'</div>'
			+			'</div>'
			+		'</div>';
			
		editbox.html(html);
		
		editbox.find("input[name='cateName']").val(data.cateName);
		editbox.find("input[name='cateInfo']").val(data.cateInfo);
		editbox.find("input[name='cateOrder']").val(data.cateOrder);
		editbox.find("input[name='cateCount']").val(data.cateCount);
		if ( data.cateIsShow ){
			editbox.find("input[name='cateIsShow'][value='1']").attr("checked", true);
		}else{
			editbox.find("input[name='cateIsShow'][value='0']").attr("checked", true);
		}
		if ( data.cateOutLink ){
			editbox.find("input[name='cateOutLink'][value='1']").attr("checked", true);
		}else{
			editbox.find("input[name='cateOutLink'][value='0']").attr("checked", true);
		}
		editbox.find("input[name='cateOutLinkText']").val(data.cateOutLinkText);
		
		
		var form = editbox.find("form");
		
		form.find(".close").on("click", function(){
			editbox.empty();
			isMakingData = false;
			_this.find(".info .action").show();
		});
		
		form.ajaxForm({
			dataType: "json",
			beforeSubmit: function(){
				if ( form.find("input[name='cateName']").val().length === 0 ){
					popUpTips("请填写分类名");
					return false;
				}
				
				if ( form.find("input[name='cateInfo']").val().length === 0 ){
					popUpTips("请填写分类说明");
					return false;
				}
				
				if ( isNaN(form.find("input[name='cateOrder']").val()) ){
					popUpTips("请将分类排序填写正确");
					return false;
				}
			},
			success: function( params ){
				if ( params.success ){
					_this.find("span")
						.text(form.find("input[name='cateName']").val())
						.attr("title", form.find("input[name='cateInfo']").val());
						
					_this.find(".close").trigger("click");
				}else{
					popUpTips(params.error);
				}
			},
			error: function(){
				popUpTips("网络出错");
			}
		});
	}
	
	function editIcons(){
		$("body").on("click", ".categorylist li .icon", function(){
			if ( isMakingData === true ){
				return;
			}
			isMakingData = true;
			var ul = document.createElement("ul");
			var id = $(this).parents("li:first").attr("data-id");
			var htmls = "";
			for ( var i = 0 ; i< iconList.length ; i++ ){
				htmls += '<li class="ui-wrapshadow" data-value="' + iconList[i] + '"><img src="profile/icons/' + iconList[i] + '"></li>';
			}
			
			$(ul).appendTo("body");
			var $ul = $(ul);
			$ul.addClass("iconlistbox").attr("data-id", id).html(htmls);
			var offset = $(this).offset();
			$ul.css({
				top: offset.top + "px",
				left: (offset.left + 36) + "px"
			});
			var _this = this;
			$ul.find("li").on("click", function(){
				var dataValue = $(this).attr("data-value");
				$.getJSON(config.ajaxUrl.server.setCateIcon, {id: id, icon: dataValue}, function(params){
					isMakingData = false;
					if ( params.success ){
						$(_this).find("img").attr("src", "profile/icons/" + dataValue);
						$ul.remove();
					}else{
						popUpTips(params.error);
					}
				});
			});
		});
	}
	
	return {
		init: function(){
			$(function(){
				addFirstCategory();
				getIconList();
				addNewCategory();
				destoryCategory();
				addSecondCategory();
				cancelNewCategory();
				editCategory();
				editIcons();
			});
		}
	}
});