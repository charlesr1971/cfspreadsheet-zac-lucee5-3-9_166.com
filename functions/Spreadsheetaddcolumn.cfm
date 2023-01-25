<!--- Compatibility note: ACF does not yet support a "delimiter" argument --->
<!--- Compatibility note: ACF does not yet support a "delimiter" argument --->
<cffunction name="SpreadsheetAddColumn" returntype="void" output="false">
	<cfargument name="spreadsheet" type="org.cfpoi.spreadsheet.Spreadsheet" required="true" />
	<cfargument name="data" type="string" required="true" hint="Delimited list of values" />
	<cfargument name="startRow" type="numeric" required="false" />
	<cfargument name="startColumn" type="numeric" required="false" />
	<cfargument name="insert" type="boolean" required="false" />
	<cfargument name="delimiter" type="string" required="false" default="," />
    <cfargument name="format" type="any" required="false" default="false" hint="Boolean: If true, new cells will be formatted to the corresponding data type; for booleans, only the values true, false, TRUE, FALSE will be accepted. Array: an array of data types, whose new cells require formatting: ['boolean', 'numeric', 'date']; or an array of new column indices: [1, 5, 2], starting from one not zero. Struct: a struct of custom masks, using the new column indice as the key and the mask string as the value, like {1: '0.00', 2: 'boolean', 2: 'date'}; to add the default mask/value, just use boolean, date or numeric as the value" />
	
	<cfif StructKeyExists(arguments, "startRow") and not StructKeyExists(arguments, "startColumn")>
		<cfthrow type="org.cfpoi.spreadsheet.Spreadsheet" 
				message="Invalid Argument Combination" 
				detail="If a StartRow is specified, StartColumn is required." />
	</cfif>
			
	<cfset Local.args.data = arguments.data />
	<cfset Local.args.delimiter = arguments.delimiter />
    <cfset Local.args.format = arguments.format />
	
	<cfif StructKeyExists(arguments, "startRow")>
		<cfset Local.args.startRow = arguments.startRow />
	</cfif>
	
	<cfif StructKeyExists(arguments, "startColumn")>
		<cfset Local.args.column = arguments.startColumn />
	</cfif>
	
	<cfif StructKeyExists(arguments, "insert")>
		<cfset Local.args.insert = arguments.insert />
	</cfif>

	<cfset arguments.spreadsheet.addColumn( argumentCollection=Local.args ) />
</cffunction>
