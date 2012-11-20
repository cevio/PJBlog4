<%
define(function(require, exports, module){
	
	var xml = require("XML"),
		fso = require("FSO"),
		dbo = require("DBO"),
		connecte = require("openDataBase"),
		xmlSelectorFunctions = {};
		
	xmlSelectorFunctions.HTMLtext = function(des, id, name){
		if ( connecte === true ){
			var value = "";
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_moden Where modemark=" + id + " And modekey='" + name + "'",
				callback: function(rs){
					value = rs("modevalue").value;
				}
			});
			return '<tr><td>' + des + '</td><td><input type="text" name="' + name + '" value="' + value + '" /></td></tr>';
		}else{
			return "";
		}
	}
	
	xmlSelectorFunctions.HTMLselect = function(des, id, name){
		if ( connecte === true ){
			var value = "",
				retHTML = "";
				
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_moden Where modemark=" + id + " And modekey='" + name + "'",
				callback: function(rs){
					value = rs("modevalue").value;
				}
			});
			
			var elements = this.getElementsByTagName("option");
			
			for ( var i = 0 ; i < elements.length ; i++ ){
				var _val = elements[i].getAttribute("value"),
					_text = elements[i].text;
				
				if ( _val === value ){
					retHTML += '<option value="' + _val + '" selected="selected">' + _text + '</option>';
				}else{
					retHTML += '<option value="' + _val + '">' + _text + '</option>';
				}
			}
			
			return '<tr><td>' + des + '</td><td><select name="' + name + '">' + retHTML + '</select></td></tr>';
			
		}else{
			return "";
		}
	}
	
	xmlSelectorFunctions.HTMLradio = function(des, id, name){
		if ( connecte === true ){
			var value = "",
				retHTML = "";
				
			dbo.trave({
				conn: config.conn,
				sql: "Select * From blog_moden Where modemark=" + id + " And modekey='" + name + "'",
				callback: function(rs){
					value = rs("modevalue").value;
				}
			});
			
			var elements = this.getElementsByTagName("option");
			
			for ( var i = 0 ; i < elements.length ; i++ ){
				var _val = elements[i].getAttribute("value"),
					_text = elements[i].text;
				
				if ( _val === value ){
					retHTML += ' <input type="radio" name="' + name + '" value="' + _val + '" checked="checked" /> ' + _text;
				}else{
					retHTML += ' <input type="radio" name="' + name + '" value="' + _val + '" /> ' + _text;
				}
			}
			
			return '<tr><td>' + des + '</td><td>' + retHTML + '</td></tr>';
			
		}else{
			return "";
		}
	}
	
	var xmlTable = function( xmlfile, id ){
		var retHTML = "";
		
		if ( fso.exsit(xmlfile) ){
			var xmlObject = xml.load(xmlfile);
			
			if ( xmlObject !== null ){
				var elements = xml("key", xmlObject.root, xmlObject.object);
					elements.each(function(){
						var name = this.getAttribute("name"),
							value = this.getAttribute("value"),
							type = this.getAttribute("type"),
							des = this.getAttribute("des");
							
						if ( xmlSelectorFunctions["HTML" + type] !== undefined ){
							retHTML += xmlSelectorFunctions["HTML" + type].call(this, des, id, name);
						}
					});
			}
		}
		
		if ( retHTML.length > 0 ) {
			retHTML = '<table class="table">' + retHTML + '</table>';
		}
		
		return retHTML;
	}
	
	return xmlTable;
});
%>