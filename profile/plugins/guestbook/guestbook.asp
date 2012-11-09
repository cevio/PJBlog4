<%include(pageCustomParams.global.themeFolder + "/header");%>
<link rel="stylesheet" href="<%=pageCustomParams.global.website + "/" + pageCustomParams.global.styleFolder%>/guestbook.css" type="text/css" />
<%
	console.log(JSON.stringify(pageCustomParams));
%>
<script language="javascript">
	require("assets/js/config.js", function( route ){
		route.load("<%=pageCustomParams.global.themeFolder%>/js/guestbook");
	});
</script>
<%include(pageCustomParams.global.themeFolder + "/footer")%>