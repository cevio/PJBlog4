// JavaScript Document
define(function(){
	
	var list = [
		{
			mark: "welcome",
			name: "欢迎",
			children: [
				{ mark: "index", name: "文档前序" }
			]
		},
		{
			mark: "obey",
			name: "obey",
			children: [
				{ mark: "selector", name: "selector" },
				{ mark: "define", name: "define" },
				{ mark: "require", name: "require" },
				{ mark: "http", name: "http" },
				{ mark: "dbo", name: "dbo" },
				{ mark: "fso", name: "fso" },
				{ mark: "stream", name: "stream" },
				{ mark: "xml", name: "xml" },
				{ mark: "ajax", name: "ajax" },
				{ mark: "cookie", name: "cookie" },
				{ mark: "date", name: "date" },
				{ mark: "md5-sha1", name: "md5&sha1" },
				{ mark: "upload", name: "upload" }
			]
		},
		{
			mark: "sizzle",
			name: "sizzle",
			children: [
				{ mark: "selector", name: "selector" },
				{ mark: "define", name: "define" },
				{ mark: "require", name: "require" },
				{ mark: "config", name: "config" }
			]
		},
		{
			mark: "theme",
			name: "主题制作",
			children: [
				{ mark: "intro", name: "主题简述" },
				{ mark: "header", name: "头部制作" },
				{ mark: "footer", name: "底部制作" },
				{ mark: "index", name: "首页制作" },
				{ mark: "article", name: "内页制作" },
				{ mark: "comment", name: "评论制作" },
				{ mark: "tag", name: "标签页制作" },
				{ mark: "search", name: "搜索结果" }
			]
		},
		{
			mark: "plugin",
			name: "插件制作",
			children: [
				{ mark: "intro", name: "插件简述" },
				{ mark: "installxml", name: "install.xml" },
				{ mark: "installasp", name: "install.asp" },
				{ mark: "uninstallasp", name: "uninstall.asp" },
				{ mark: "proxy", name: "数据接口" },
				{ mark: "configxml", name: "全局变量"},
				{ mark: "configure", name: "高级应用" },
				{ mark: "type", name: "插件类型" }
			]
		}
	],
	isMakingData = false;
	
	function appendInstall(){	
		var parent = $(".ui-context");
			parent.html('<ul class="topbar fn-clear"></ul><ul class="rightbar"></ul><div class="document-content">sdaf</div>');
			
		var topbar = parent.find(".topbar").addClass("ui-wrapshadow"),
			rightbar = parent.find(".rightbar").addClass("ui-wrapshadow"),
			zone = parent.find(".document-content").addClass("ui-wrapshadow");
			
		topbar.on("click", "a", function(){
			topbar.find("li").removeClass("active");
			$(this).parent().addClass("active");
			var data = $(this).data("zipoo"),
				mark1 = data.mark,
				children = data.children;
			
			rightbar.empty();
			for ( var j = 0 ; j < children.length ; j++ ){
				var d2 = children[j],
					mark2 = d2.mark,
					name2 = d2.name,
					_li = document.createElement("li");
					
				$(_li).appendTo(rightbar);
				var _$li = $(_li);
				_$li.html('<a href="javascript:;">' + name2 + '</a>');
				var a2 = _$li.find("a");
				a2.data("zipoo", { mark: mark1, page: mark2 });
			}
			
			rightbar.find("a:first").trigger("click");
		});
		
		rightbar.on("click", "a", function(){
			//if ( isMakingData === true ){
			//	return;
			//}
			//isMakingData = true;
			rightbar.find("li").removeClass("active");
			$(this).parent().addClass("active");
			var data = $(this).data("zipoo"),
				mark1 = data.mark,
				mark2 = data.page;
				
			$.get("server/documents/" + mark1 + "-" + mark2 + ".html", {}, function(text){
				//isMakingData = false;
				zone.html(text);
			});
		});

		for ( var i = 0 ; i < list.length ; i++ ){
			var d1 = list[i],
				mark1 = d1.mark,
				name1 = d1.name,
				children = d1.children;
			
			var li = document.createElement("li");
			$(li).appendTo(topbar);
			var $li = $(li);
			$li.addClass("fn-left").html('<a href="javascript:;">' + name1 + '</a>');
			var a = $li.find("a");
			a.data("zipoo", {mark: mark1, children: children});
		}
		
		topbar.find("li a:first").trigger("click");
	}
	
	return {
		init: function(){
			$(function(){
				appendInstall();
			});
		}
	}
});