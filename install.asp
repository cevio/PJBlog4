<!--#include file="setup/asp/obay.asp" -->
<%
	config.base = "/";
	config.useApp = true;
	var fso = require("setup/asp/fso");
	if ( !fso.exsit("setup/config.asp") ){
		var stream = require("setup/asp/stream");
		var randoms = function(n){
			var chars = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'],
				res = "";
				
			for(var i = 0; i < n ; i ++) {
				var id = Math.ceil(Math.random() * (chars.length - 1));
				res += chars[id];
			}
				
			return res;
		};
		
		var percent = "%",
			rans = randoms(10),
			configText = '<' + percent + '\ndefine(function(){return "' + rans + '";});\n' + percent + '>';
			
		config.appName = rans;
		
		stream.save(configText, "setup/config.asp");
		asa();
		
		Response.Redirect("install.asp");
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>PJBlog4 安装程序</title>
<link rel="stylesheet" href="setup/css/setup.css" type="text/css" />
<link rel="stylesheet" href="setup/css/pp.css" type="text/css" />
<link rel="stylesheet" href="setup/buttons/buttons.css" type="text/css" />
<script language="javascript" src="setup/js/sizzle.js"></script>
<script language="javascript" src="setup/js/jQuery.js"></script>
<script language="javascript" src="setup/js/setup.js"></script>
</head>
<body>
<input type="hidden" name="website" value="" />
<div class="wrapper">
	<div class="animate">
    	<div class="box">
        	<div class="pops1"></div>
            <div class="pops2"></div>
        </div>
    </div>
	<div class="outer fn-clear">
    	<div class="inner">
        	<div class="content">
            	<div class="top-zone">
                	<div class="area">
                    	<div class="welcome">
                        	<h1>PJBlog4在线安装程序</h1>
                            <h2>让我们从这里开始吧...</h2>
                        </div>
                    </div>
                </div>
            	<div class="bom-zone">
                	<div class="area">
                		<a href="javascript:;" class="button small green step-next" data-step="1">开始安装</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="inner">
        	<div class="content">
            	<div class="top-zone">
                	<div class="area">
                    	<div class="setupfolder">
                        	<h1>请输入安装文件夹地址</h1>
                            <div class="input"><input type="text" name="folder" style="width:300px;" placeholder="填写网站的相对目录地址，不存在系统会自动创建。" /></div>
                            <div class="info">
                            	1. 这个文件夹地址是基于你的网站的根目录来填写的。<br />
                                2. 格式： blog , blog/example, blog/example/test<br />
                                3. 首尾都不能出现斜杆，如果是根目录，那么不需要填写。
                            </div>
                        </div>
                    </div>
                </div>
            	<div class="bom-zone">
                	<div class="area">
                        <a href="javascript:;" class="button small green step-next" data-step="2">下一步</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="inner">
        	<div class="content">
            	<div class="top-zone">
                	<div class="area">
                    	<div class="yanzheng">
                        	<h1>管理员账号</h1>
                            <div class="input"><input type="text" name="username" style="width:300px;" placeholder="管理员账号" /></div>
                            <h1>管理员密码</h1>
                            <div class="input"><input type="password" name="password" style="width:300px;" placeholder="管理员密码" /></div>
                            <div class="info">
                            	从哪里获得这些数据？<a href="http://bbs.pjhome.net" target="_blank">请点击这里前往</a>。
                            </div>
                        </div>
                    </div>
                </div>
            	<div class="bom-zone">
                	<div class="area">
                		<a href="javascript:;" class="button small orange step-prev" data-step="1">上一步</a>
                        <a href="javascript:;" class="button small green step-next" data-step="3">下一步</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="inner">
       		<div class="content">
            	<div class="top-zone">
                	<div class="area">
                    	<div class="setuping">
                        	<h1>正在安装程序，请稍后..</h1>
                        </div>
                    </div>
                </div>
            	<div class="bom-zone">
                	<div class="area">
                		<a href="javascript:;" class="button small gray step-next" data-step="4">下一步</a>
                    </div>
                </div>
            </div>
        </div>
        <div class="inner">
       		<div class="content">
            	<div class="top-zone">
                	<div class="area">
                    	<div class="setuping">
                        	<h1>恭喜，安装程序成功。</h1>
                            <div class="info">
                            	点击“安装完成”跳转首页。
                            </div>
                        </div>
                    </div>
                </div>
            	<div class="bom-zone">
                	<div class="area">
                		<a href="javascript:;" class="button small orange" id="goWeb">安装完成</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="guide fn-clear">
    	<div class="fn-left publue"><!--<span>18%</span> 正在进行安装... --></div>
        <div class="fn-right fn-clear">
        	<span class="active">欢迎&nbsp;&nbsp;»</span>
            <span>基址&nbsp;&nbsp;»</span>
            <span>设置&nbsp;&nbsp;»</span>
            <span id="setup">安装&nbsp;&nbsp;»</span>
            <span>完成</span>
        </div>
    </div>
</div>
</body>
</html>
