<%
define(function( require, exports, module ){
	var fso = require.async("FSO");
	if ( fso.exsit("profile/themes/imback/style/white", true) ){
		fso.destory("profile/themes/imback/style/white", true);
	}
});
%>