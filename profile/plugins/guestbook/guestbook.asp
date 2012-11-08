<%include(config.params.themeFolder + "/header");%>
<% var date = require("DATE"); %>
<%
	console.log(JSON.stringify(pagePluginCustomParams.webData));
%>
<script language="javascript">
	require("assets/js/config.js", function( route ){
		route.load("<%=config.params.themeFolder%>/js/guestbook");
	});
</script>
<%include(config.params.themeFolder + "/footer")%>