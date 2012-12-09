// guestbook for pj4
function getCookie(b){var a=document.cookie.match(new RegExp("(^| )"+b+"=([^;]*)(;|$)"));if(a!=null){return unescape(a[2])}return null};
var getObj = function (id) {
	return "string" == typeof id ? document.getElementById(id) : id;
};
var checksub_email=function(str){
	if (!str||str==""){return false;}
	if (!str.match(/^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/)){
	return false;
	}
	else{
	return true;
	}
}
function showrepBox(o,obj,bookroot)
{
	if(o==1||o==2)
	{	
		$("#bookroot_id").val(bookroot);
		$("#ccontent").val("");
		$(".pname").eq(0).html()
		if(o==1){
			$(".person").html("虽然发表评论不用注册，但是为了保护您的发言权，建议您注册账号。");
		}
		else{
			$(".person").html("盖楼");
		}
		getObj("bg").style.display = "block";
		var h = document.documentElement.offsetHeight > document.documentElement.scrollHeight ? document.documentElement.offsetHeight : document.documentElement.scrollHeight;
		getObj("bg").style.height = h+"px";
		getObj(obj).style.display = "block";
		getObj(obj).style.left = (getObj("bg").offsetWidth - getObj(obj).offsetWidth)/2 + "px";
		var mttp;
		if(document.body.scrollTop)
		{
			mttp = document.body.scrollTop;
		}
		else
		{
			mttp = document.documentElement.scrollTop;
		}
		getObj(obj).style.top = mttp + (document.documentElement.clientHeight-getObj(obj).offsetHeight)/2 + "px";
	}
	else
	{
		getObj("bg").style.display = "none";
		getObj(obj).style.display = "none";
	}
};

define(['form'], function(require, exports, module){ 
	exports.isSendData = false;
	exports.PostComment = function(options){
		var $form = $(options.formElement);
		$form.ajaxForm({
			dataType: "text",
			beforeSubmit: function(a,b,c){
				var c=$.trim($("#ccontent").val()),e=$.trim($("#cemail").val()),n=$.trim($("#cname").val()),w=$.trim($("#cwebsite").val());
				if(c==null || c==""){alert("请输入回复内容");$("#cemail").focus();return false;}
				if(c.length>300){alert("回复内容不能超过300字");$("#cemail").focus();return false;}
				if (checksub_email(e)==false){alert("请输入正确的EMAIL");$("#cemail").focus();return false;}
				if ($("#cname").length>0&&n==""){alert("访客请输入昵称");$("#cname").focus();return false;}
			},
			success: function(text){
				var json=eval("("+text+")")
				if (json.error){alert(json.error);}
				if (json.success==true){$("#ccontent").text("");showrepBox(0,'repbox');}
				location.reload();
			},
			complete: function(){},
			error: function(e){if(config("debug")==true){alert(JSON.stringify(e));}}
		});
	};
	exports.PostComment({"formElement":"#gb_list"});
});
