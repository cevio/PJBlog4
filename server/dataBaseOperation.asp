<%
define(function(){
	if ( config.conn === null ){
		var conn = new ActiveXObject(config.nameSpace.conn),
			access = selector.lock(config.access);
			
		try{
			conn.open("provider=Microsoft.jet.oledb.4.0;data source=" + access);
			config.conn = conn;
		}catch(e){
			try{
				conn.open("driver={microsoft access driver (*.mdb)};dbq=" + access);
				config.conn = conn;
			}catch(e){}
		}
	}
	
	return ((config.conn !== null) ? true : false);
});
%>