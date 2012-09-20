<%
if ( Session("admin") === true ){
	Response.Redirect("control.asp");
}
%>
<div class="tpl-space fn-clear">
	<div class="login-area">
    	<ul class="tabs">
        	<li class="login-form">
            	<div class="plaim-zone">
                	<div class="password-area">
                    	<form action="server/login.asp" method="post">
                            <div class="word-tip"><span class="iconfont">&#226;</span> 请输入密码后登入【第一次登入密码为"admin888"，请登入后修改！】</div> 
                            <input type="password" class="text" value="" placeholder="请输入密码..." name="password" />
                            <div class="login-submit"><input type="submit" value="登录" class="submit tpl-button-blue" /></div>
                        </form>
                    </div>
                </div>
            </li>
            <!--<li class="login-sending">sending</li>
            <li class="login-success">success</li>
            <li class="login-error">error</li>-->
        </ul>
    </div>
</div>