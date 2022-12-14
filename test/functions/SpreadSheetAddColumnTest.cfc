<cfcomponent extends="testbox.system.compat.framework.TestCase">

	<cffunction name="testDefaultRowColumn" access="public" returnType="void">
		<cfset var Local = {}>

		<!--- add a few values starting at default A1 --->
		<cfset Local.data = "newcol1,newcol2,newcol3" />
		<cfset Local.sheet = SpreadsheetNew() />
		<cfset SpreadsheetAddColumn(Local.sheet, Local.data) />

		<!--- verify initial row values are what they should be... --->		
		<cfset checkRowValues(Local.sheet, Local.data, 1, 1) />

		<!--- append more values to next column B1 --->
		<cfset Local.data = "foo,bar,baz,qux" />
		<cfset SpreadsheetAddColumn(Local.sheet, Local.data) />
		
		<!--- verify initial row values are what they should be... --->		
		<cfset checkRowValues(Local.sheet, Local.data, 1, 2) />
	</cffunction>		

	<cffunction name="testCustomDelimiter" access="public" returnType="void">
		<cfset var Local = {}>

		<!--- add values starting on a non default row/column --->
		<cfset Local.startRow = 5 />
		<cfset Local.startCol = 3 />
		<cfset Local.delim = "|" />
		<cfset Local.data = "The|quick|brown|fox|jumps|over|the|lazy|dog" />
		<cfset Local.sheet = SpreadsheetNew() />
		<cfset SpreadsheetAddColumn(Local.sheet, Local.data, Local.startRow, Local.startCol, true, Local.delim) />

		<!--- verify the row values are what they should be... --->		
		<cfset checkRowValues(Local.sheet, Local.data, Local.startRow, Local.startCol, Local.delim) />

	</cffunction>		
	
	<cffunction name="testNonDefaultRowColumn" access="public" returnType="void">
		<cfset var Local = {}>

		<!--- add values starting on a non default row/column --->
		<cfset Local.startRow = 5 />
		<cfset Local.startCol = 3 />
		<cfset Local.data = "newcol1,newcol2,newcol3" />
		<cfset Local.sheet = SpreadsheetNew() />
		<cfset SpreadsheetAddColumn(Local.sheet, Local.data, Local.startRow, Local.startCol) />

		<!--- verify the row values are what they should be... --->		
		<cfset checkRowValues(Local.sheet, Local.data, Local.startRow, Local.startCol) />

	</cffunction>		

	<cffunction name="testAddDataOverwrite" access="public" returnType="void">
		<cfset var Local = {}>

		<!--- add a few values --->
		<cfset Local.origData = "a,b,c,d,e,1,2,3,4,5" />
		<cfset Local.sheet = SpreadsheetNew() />
		<cfset SpreadsheetAddColumn(Local.sheet, Local.origData) />

		<!--- verify the row values are what they should be... --->		
		<cfset checkRowValues(Local.sheet, Local.origData, 1, 1) />
		
		<!--- overwrite a few of the values --->
		<cfset Local.startRow = 3 />
		<cfset Local.startCol = 1 />
		<cfset Local.dataToInsert = "foo,bar,qux " />
		<cfset SpreadsheetAddColumn(Local.sheet, Local.dataToInsert, Local.startRow, Local.startCol, false) />

		<!--- what the row values SHOULD be after the overwrite --->
		<cfset Local.newData = Local.origData />
		<cfloop from="1" to="#listLen(Local.dataToInsert)#" index="Local.offset">
			<cfset Local.value = listGetAt(Local.dataToInsert, Local.offset) />
			<cfset Local.newData = listSetAt(Local.newData, Local.startRow+Local.offset-1, Local.value) />
		</cfloop>
		
		<!--- verify the row values are what they should be... --->
		<cfset checkRowValues(Local.sheet, Local.dataToInsert, Local.startRow, Local.startCol) />
	</cffunction>		

	<cffunction name="testAddDataInsert" access="public" returnType="void">
		<cfset var Local = {}>

		<!--- add a few values --->
		<cfset Local.startRow = 1 />
		<cfset Local.startCol = 1 />
		<cfset Local.origData = "a,b,c,d,e,1,2,3,4,5" />
		<cfset Local.sheet = SpreadsheetNew() />
		<cfset SpreadsheetAddColumn(Local.sheet, Local.origData, Local.startRow, Local.startCol) />

		<!--- verify initial row values are what they should be... --->		
		<cfset checkRowValues(Local.sheet, Local.origData, Local.startRow, Local.startCol) />

		<!--- INSERT a few cells --->
		<cfset Local.appendAtRow = 6 />
		<cfset Local.dataToInsert = "foo,bar,qux " />
		<cfset SpreadsheetAddColumn(Local.sheet, Local.dataToInsert, Local.appendAtRow, Local.startCol, true) />

		<!--- what the values SHOULD be after the insert --->
		<cfset Local.expectedData = Local.origData />
		<cfset Local.shiftedData = "" />
		<cfloop from="1" to="#listLen(Local.dataToInsert)#" index="Local.offset">
			<cfset Local.shiftedData = listAppend(Local.shiftedData,  listGetAt(Local.origData, Local.appendAtRow+Local.offset-1)) />
			
			<cfset Local.newValue = listGetAt(Local.dataToInsert, Local.offset) />
			<cfset Local.expectedData = ListSetAt(Local.expectedData, Local.appendAtRow+Local.offset-1, Local.newValue) />
		</cfloop>
		
		<!--- verify new values replaced the old ones ... --->
		<cfset checkRowValues(Local.sheet, Local.expectedData, Local.startRow, Local.startCol) />
		<!--- .. and the old values were shifted to the right ... --->
		<cfset checkRowValues(Local.sheet, Local.shiftedData, Local.appendAtRow, Local.startCol+1) />
	
	</cffunction>		
    
    <cffunction name="testCustomFormat" access="public" returnType="void">
		<cfset var Local = {}>

		<!--- add values, using a custom format object --->
        <cfset Local.startRow = 1 />
		<cfset Local.startCol = 1 />
		<cfset Local.data = "Basic,Intermediate,Advanced,Basic,Intermediate,Advanced,true,01/01/2022,123456789.5000,Basic" />
        <cfset Local.delim = "," />
        <cfset Local.format = {
			7: 'boolean',
			8: 'mmm d-yy',
			9: '0.0000'
		  }
		/>
		<cfset Local.sheet = SpreadsheetNew() />
        
        <cfset SpreadsheetAddColumn(spreadsheet=Local.sheet, data=Local.data, startRow=Local.startRow, startColumn=Local.startCol, insert=true, delimiter=Local.delim, format=Local.format) />

		<!--- verify the row values are what they should be... --->		
        
		<cfset checkRowValues(Local.sheet, Local.data, Local.startRow, Local.startCol, Local.delim, Local.format) />

	</cffunction>

	<cffunction name="checkRowValues" access="private" returnType="void">
		<cfargument name="sheet" 	type="any" />
		<cfargument name="data" 	type="string" hint="List of expected data values"/>
		<cfargument name="startRow" type="numeric" default="1" />
		<cfargument name="startCol" type="numeric" default="1" />
		<cfargument name="delim" 	type="string" default="," hint="data delimiter" />
        <cfargument name="format" type="any" required="false" default="false" hint="Boolean: If true, new cells will be formatted to the corresponding data type; for booleans, only the values true, false, TRUE, FALSE will be accepted. Array: an array of data types, whose new cells require formatting: ['boolean', 'numeric', 'date']; or an array of new column indices: [1, 5, 2], starting from one not zero. Struct: a struct of custom masks, using the new column indice as the key and the mask string as the value, like {1: '0.00', 2: 'boolean', 2: 'date'}; to add the default mask/value, just use boolean, date or numeric as the value" />

		<cfset Local.rowOffset = arguments.startRow - 1 />
		<cfset Local.endRow = arguments.startRow + listLen(arguments.data, arguments.delim) - 1 />
        
		<cfloop from="#arguments.startRow#" to="#Local.endRow#" index="Local.row">
			<cfset Local.expected = listGetAt( arguments.data, (Local.row-Local.rowOffset), arguments.delim ) />
            <cfif StructKeyExists(arguments, "format") AND IsStruct(arguments.format) AND StructKeyExists(arguments.format,Local.row)>
			  <cfset Local.cellFormat = arguments.format[Local.row] />
              <cfif IsNumeric(Local.expected)>
				<cfset Local.expected = numberFormat( Local.expected, Local.cellFormat ) />
			  <cfelseif IsDate(Local.expected)>
				<cfset Local.expected = dateFormat( Local.expected, Local.cellFormat ) />
              </cfif>
            </cfif>
			<cfset Local.actual = SpreadSheetGetCellValue(arguments.sheet, Local.row, arguments.startCol) />
			<cfset assertEquals( Local.expected, Local.actual, "#arguments.data#:: row=#Local.row# / col=#arguments.startCol#") />			
		</cfloop>
	</cffunction>
	
	<!--- setup and teardown --->
	<cffunction name="setUp" returntype="void" access="public">
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public">
	</cffunction>

</cfcomponent>

