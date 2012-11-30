<%
if ( Session("admin") === true ){
	Response.Redirect("control.asp");
}
require("status");
%>
    <div class="login-box ui-wrapshadow">
    	<div class="login-user fn-clear">
            <form action="server/login.asp" method="post">
                <div class="imgs fn-left"><img src="<%=config.user.photo%>/50"></div>
                <div class="action fn-left">
                    <div class="name"><%=config.user.name%></div>
                    <div class="put">
                        <input type="password" value="" placeholder="请输入密码.." name="password" class="pass" />
                        <input type="submit" value="" class="submit" />
                    </div>
                </div>
            </form>
        </div>
        <div class="login-info">正在验证密码..请稍后!</div>
    </div>