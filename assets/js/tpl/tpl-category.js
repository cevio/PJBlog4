// JavaScript Document
define(function(require, exports){
	exports.editCategorySimple = function(){
		return '<form action="' + config.ajaxUrl.server.updateCate + '" method="post"><div class="custom fn-clear">'
			+		'<div class="cateName"><input type="text" value="" name="cateName" placeholder="分类名.." /></div>'
			+		'<div class="cateInfo"><input type="text" value="" name="cateInfo" placeholder="分类说明.." /></div>'
			+		'<input type="hidden" name="cateOrder" value="" />'
			+		'<input type="hidden" name="cateRoot" value="" />'
			+		'<input type="hidden" name="cateCount" value="" />'
			+		'<input type="hidden" name="cateIcon" value="" />'
			+		'<input type="hidden" name="cateIsShow" value="" />'
			+		'<input type="hidden" name="cateOutLink" value="" />'
			+		'<div class="cateMore"><input type="submit" value="提交保存" class="tpl-button-gray" /></div>'
		+ 		'</div></form>';
	}
	
	exports.editCategorySimpleInfo = function(){
		return '<div id="updateCategoryInfo">'
		+			'<div class="app">'
		+				'<h1 class="fn-clear"><a href="javascript:;" class="updateCategoryInfoClose iconfont fn-right" title="关闭">&#223;</a>其他属性设置</h1>'
		+				'<table>'
		+					'<tr><td class="name">排序</td><td class="value"><input type="text" value="" name="tcateOrder" placeholder="排序数字.." /></td></tr>'
		+					'<tr><td class="name">所属分类</td><td class="value"><select name="tcateRoot"><option value="0">根目录</option></select></td></tr>'
		+					'<tr><td class="name">日志数</td><td class="value"><input type="text" value="" name="tcateCount" placeholder="日志数.." /></td></tr>'
		+					'<tr><td class="name">分类图标</td><td class="value"><select name="tcateIcon"><option value="0">123</option></select></td></tr>'
		+					'<tr><td class="name">是否为隐藏分类</td><td class="value"><input type="radio" name="tcateIsShow" value="1" /> 是 <input type="radio" name="tcateIsShow" value="0" /> 否</td></tr>'
		+					'<tr><td class="name">是否为外部链接</td><td class="value"><input type="radio" name="tcateOutLink" value="1" /> 是 <input type="radio" name="tcateOutLink" value="0" /> 否</td></tr>'
		+				'</table>'
		+			'</div>'
		+	   '</div>';
	}
});