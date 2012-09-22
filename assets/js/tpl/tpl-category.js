// JavaScript Document
define(function(require, exports){
	exports.editCategorySimple = function(){
		return '<form action="' + config.ajaxUrl.server.updateCate + '" method="post"><div class="custom fn-clear">'
			+		'<div class="cateName"><input type="text" value="" name="cateName" placeholder="分类名.." /></div>'
			+		'<div class="cateInfo"><input type="text" value="" name="cateInfo" placeholder="分类说明.." /><input type="hidden" name="cateRoot" value="" /><input type="hidden" name="id" value="0" /></div>'
			+		'<div class="cateMore"><input type="submit" value="提交保存" class="tpl-button-gray" /></div>'
			+ 		'</div>'
			+		'<div class="updateCategoryInfo">'
			+			'<div class="app">'
			+				'<h1 class="fn-clear"><a href="javascript:;" class="updateCategoryInfoClose iconfont fn-right" title="关闭">&#223;</a>其他属性设置</h1>'
			+				'<table>'
			+					'<tr><td class="name">排序</td><td class="value"><input type="text" value="" name="cateOrder" placeholder="排序数字.." /></td></tr>'
			+					'<tr><td class="name">日志数</td><td class="value"><input type="text" value="" name="cateCount" placeholder="日志数.." /></td></tr>'
			+					'<tr><td class="name">分类图标</td><td class="value"><select name="cateIcon"><option value="0">123</option></select></td></tr>'
			+					'<tr><td class="name">是否为隐藏分类</td><td class="value"><input type="radio" name="cateIsShow" value="1" /> 是 <input type="radio" name="tcateIsShow" value="0" /> 否</td></tr>'
			+					'<tr><td class="name">是否为外部链接</td><td class="value"><input type="radio" name="cateOutLink" value="1" /> 是 <input type="radio" name="tcateOutLink" value="0" /> 否</td></tr>'
			+				'</table>'
			+			'</div>'
			+	   '</div>'
			+	   '</form>';
	}
	
	exports.addCategory = function(){
		return 	'<div class="items">'
        +    		'<div class="scroll-wrap">'
        +            	'<div class="view fn-clear">'
        +                	'<div class="label"><div class="box"><i></i> <span>默认标题</span></div></div>'
        +                	'<div class="edit-info">默认说明</div>'
        +                	'<div class="action"><a href="javascript:;" class="action-add" data-id="0"><span class="iconfont">&#410;</span>添加</a> <a href="javascript:;" class="action-edit" data-id="0"><span class="iconfont">&#355;</span>编辑</a>  <a href="javascript:;" class="action-del" data-id="0"><span class="iconfont">&#356;</span>删除</a></div>'
        +            	'</div>'
        +            	'<div class="editzone fn-clear">'
		+					this.editCategorySimple()
		+				'</div>'
        +        	'</div>'
        +    	'</div>';
	}
});