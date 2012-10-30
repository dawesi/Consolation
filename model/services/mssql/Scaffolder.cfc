<cfcomponent extends="consolation.model.services.BaseScaffolder" >
	<cfproperty name="consoleConfig" inject="coldbox:setting:consolation" >


<cffunction name="create">	
	<cfargument name="table"  type="string" required="true" >
	<cfargument name="columns" type="array" required="true" >
	<cfargument name="dbo" default="dbo" required="false" >
	
	<cfset var sql = "">
	<cfsavecontent variable="sql" >	
		create table #consoleConfig.dbo#.#scaffoldService.deCamelCase(consoleRequest.table)#
		(
		  id numeric identity(1000,1),
		  
	
	
	<cfloop array="#columns#" index="c">
	
	</cfloop>
	#writeBoilerPlate()#
	)
	</cfsavecontent>
	<cfreturn sql>
	
	</cffunction>
	

<cffunction name="getColumnParams" access="public" output="false" returnType="struct">
	<cfargument name="type" type="string" required="true" hint="">
	<cfargument name="length" type="any" required="true" hint="">
	<cfargument name="precision" type="any" required="true" hint="">

	<cfset var params = structNew()>
	
	<cfswitch expression="#arguments.type#">
	
	<cfcase value="date">
		<cfset params.type = 'date'>
		<cfset params.length = arguments.length>
		<cfset params.element = "date">
	</cfcase>
	
	<cfcase value="number">
		<cfif arguments.precision eq 1>
			<cfset params.type = 'boolean'>
			<cfset params.length = 1>
			<cfset params.element = "boolean">
		<cfelse>
			<cfset params.type = 'number'>
			<cfset params.length = arguments.precision>
			<cfset params.element = "number">
		</cfif>
	</cfcase>

	<cfdefaultcase>
		<cfset params.type = 'varchar2'>
		<cfset params.length = arguments.length>
		<cfif params.length gt 50>
			<cfset params.element = "textarea">
			<cfelse>
			<cfset params.element = "text">			
		</cfif>
	</cfdefaultcase>

	</cfswitch>
	
	<cfreturn params>
</cffunction>



	


	
	<cffunction name="writeID">	
		<cfreturn "id numeric identity(1000,1),">
	</cffunction>
	
	<cffunction name="writeBoilerPlateForSelect">	
		<cfset var sql = "">
		<cfsavecontent variable="sql" >	
			sort_order as sortOrder,
			is_deleted as isDeleted,
			updated_by as updatedBy,
			udpated_on as updatedOn,
			added_by as addedBy,
			added_on as addedOn,
			id as id
		</cfsavecontent>
	
		<cfreturn sql>
	</cffunction>
	
	<cffunction name="writeBoilerPlate">	
		<cfset var sql = "">
		<cfsavecontent variable="sql" >	
			sort_order numeric(2) default 50,
			is_deleted numeric(1) default 0,
			updated_by numeric(6) default 0,
			updated_on datetime default getDate(),
			added_by numeric(6) default 0,
			added_on datetime default getDate(),
			primary key(id)
		</cfsavecontent>
	
		<cfreturn sql>
	</cffunction>




<cfscript>


struct function getFieldElements(params){
	
	var elements = {};
	
	elements.column = params.name;
	elements.name = camelCase(params.name);
	elements.type = params.type;
	elements.label = humanize(elements.name);
	
	elements.element = "text";
	elements.field = "text";
	if(structkeyexists(params, "action") and params.action eq "update"){
		elements.default = "##form.#elements.name###";
	}
	else{
		elements.default = "##form.#elements.name###";
	}
	
	
	//rough settings
	if( isNumeric(params.length) ){
		elements.size = params.length;
		elements.max = params.length;
		
		}
	
	else if (isNumeric(params.precision)){
		elements.size = params.precision;
		elements.max = params.precision;
	}
	
	else{
		elements.size = 35;
		elements.max = 50;
		
	}
	
	
	//data type specific
	if( params.type eq "varchar"){
		elements.max = params.length;
		elements.size = 35;
		elements.element = "text";
		elements.field = "text";
		if ( params.length gt 50){
			elements.element = 'textarea';
			elements.field = 'textarea';
			}
	
		}
	
	
	else if(params.type eq "numeric" and right(params.name, 2) eq "id"){
		elements.field = "select";
	}
	
	
	else if (params.type eq "numeric"){
		elements.max = params.precision;
		elements.size = 5;
		elements.field = "number";
		elements.element = "number";
	}
	

	if(params.type eq 'datetime'){
		elements.size="15";
		elements.max="15";
		elements.element = "date";
		elements.field = "date";
		}
	
	else if ( params.type eq "bit"){
		elements.size="1";
		elements.max="1";
		elements.element = "boolean";
		elements.field = "boolean";
	}
	
	
	
	
	
	return elements;	
	
};


string function getDefault(type){
switch(type){
		case "datetime":
			return "default getDate()";	
		case "bit":
			return "default 0";	
		default:
			return "";
			}			
	
}

string function translateType(type){
	
	switch(type){
		case "":
			return "string";
		case "string":
			return "varchar(50)";
		case "text":
			return "varchar(500)";
		case "date":
			return "datetime";	
		case "int":
			return "numeric";
		case "number":
			return "numeric";
		case "boolean":
			return "bit";	
		
					
			
			
		default: 
			return type;	
	}
	
}

public string function getStatement(param){
		var col = {name = listFirst(param, ":"), type = translateType(listLast(param, ":"))};
			col.default = getDefault(col.type);
			
			if(listLen(param, ":") eq 1){
				var sql = "#decamelcase(col.name)# varchar(50)";
			}
			
			else{
				var sql = "#decamelcase(col.name)# #col.type# #col.default#";	
			}
			
			
			
			return trim(sql);
	}		


any function init(){
	return this;
	}	
	
	
	
</cfscript>
	
</cfcomponent>