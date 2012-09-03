<%
define(function(require, exports, module){
	
	var factory = function(object){
		return new factory.init(object);
	}
	
	function check(data){
		if ( typeof data !== "string" ){
			return data;
		}else{
			return "'" + data + "'";
		}
	}
	
	factory.init = function(object){
		this.object = object;
		this.table = null;
	}
	
	factory.init.prototype = {
		createTable : function(tableName){
			this.resetError(function(){
				this.object.Execute("CREATE TABLE " + tableName);
				this.table = tableName;
			});
			
			return this;
		},
		getTable : function(tableName){
			this.table = tableName;
			return this;
		},
		extend : function(source, target){
			if ( target === undefined ){
				target = {};
			};
			
			for ( var i in target ){
				source[i] = target[i];
			}
			
			return source;
		},
		createParam : function(name, type, value, options){
			options = this.extend({
				autoAdd : false,
				primary : false,
				defaults : ""
			}, options || {});
			
			this.resetError(function(){
				if ( typeof type === "object" ){
					options = type;
					type = "";
					value = "";
				}
				
				var tpl = 'ALTER TABLE ' + this.table + " ADD COLUMN " + name;
				
				if ( type.length > 0 ){
					tpl += " " + type;
					if ( value.length > 0 ){
						tpl += "(" + value + ")";
					}
				}
				
				if ( options.defaults.length > 0 ){
					tpl += " default " + options.defaults;
				}
				
				if ( options.autoAdd === true ){
					tpl += " COUNTER(1, 1)";
				}
				
				if ( options.primary === true ){
					tpl += " PRIMARY KEY";
				}
				
				this.object.Execute(tpl);
			});
			
			return this;
		},
		createParams : function(options){
			for ( var items in options ){ this.createParam(items, options[items].type || "", options[items].value || "", options[items]); }
			
			return this;
		},
		add : function(datas){
			this.resetError(function(){
				var tpl = "INSERT INTO " + this.table + " ($key) VALUES ($keyValue)",
					key = [],
					keyValue = [];
					
				for ( var items in datas ){
					key.push(items);
					keyValue.push(check(datas[items]));	
				}
				
				tpl = tpl.replace("$key", key.join(", ")).replace("$keyValue", keyValue.join(", "));
				
				this.object.Execute(tpl);
			});
			
			return this;
		},
		update : function(datas, options){
			this.resetError(function(){
				var setValue = [],
					tpl1 = "UPDATE " + this.table + " SET $setValue",
					tpl2 = "UPDATE " + this.table + " SET $setValue WHERE $condition",
					tpl, condition = [];
					
				for ( var items in datas ){
					setValue.push( items + " = " + check(datas[items]) );	
				}
				
				if ( options !== undefined ){
					for ( var i in options ){
						condition.push( i + " = " + check(options[i]) );
					}
					
					if ( condition.length > 0 ){
						tpl = tpl2;
					}else{
						tpl = tpl1;
					}
				}else{
					tpl = tpl1;
				}
				
				tpl = tpl.replace("$setValue", setValue.join(", ")).replace("$condition", condition.join(" AND "));
				this.object.Execute(tpl);
			});
		},
		destory : function(options){
			this.resetError(function(){
				var condition = [],
					tpl1 = "DELETE FROM " + this.table,
					tpl2 = "DELETE FROM " + this.table + " WHERE $condition",
					tpl;
					
				if ( options !== undefined ){
					for ( var i in options ){
						condition.push( i + " = " + check(options[i]) );
					}
					
					if ( condition.length > 0 ){
						tpl = tpl2;
					}else{
						tpl = tpl1;
					}
				}else{
					tpl = tpl1;
				}
				
				tpl = tpl.replace("$condition", condition.join(" AND "));
				this.object.Execute(tpl);
			});
		},
		resetError : function(callback){
			try{
				callback.call(this);
			}catch(e){
				console.push(e.message);
			}
		}
	}
	
	return factory;
});
%>