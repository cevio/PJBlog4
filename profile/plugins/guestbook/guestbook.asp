<%include(config.params.themeFolder + "/header");%>
<link rel="stylesheet" href="<%=config.params.website + "/" + config.params.styleFolder%>/guestbook.css" type="text/css" />
<%
	console.log(JSON.stringify(pagePluginCustomParams));
%>
<script language="javascript">
	require("assets/js/config.js", function( route ){
		route.load("<%=config.params.themeFolder%>/js/guestbook");
	});
</script>
<%include(config.params.themeFolder + "/footer")%>