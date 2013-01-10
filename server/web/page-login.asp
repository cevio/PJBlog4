<%
	var GRA = require("gra"),
		cache = require("cache"),
		cache_global = cache.load("global");
%>
<div class="login-box">
	<form action="server/login.asp" method="post" style="margin:0; padding:0;">
    	<div class="username fn-clear">
        	<div class="gravatar fn-left"><img src="<%=GRA(cache_global.authoremail)%>"></div>
            <div class="name fn-left"><input type="text" value="" placeholder="UserName.." name="username"><div class="infoText"></div></div>
        </div>
    	<div class="password"><input type="password" value="" name="password" placeholder="PassWord.." class="passwordTextBox" /><input type="submit" value="" class="submitImageBtn" /></div>
    </form>
</div>