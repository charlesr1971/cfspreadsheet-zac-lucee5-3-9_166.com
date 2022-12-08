<cfcomponent extends="testbox.system.compat.framework.TestCase">

	<cffunction name="testDefaultRows" access="public" returnType="void">
		<cfset var Local = {}>

		<!--- add a data object --->
        <cfset Local.coursesObj = {
			COLUMNS: [
				"CORNUMBER",
				"DEPT_ID",
				"COURSE_ID",
				"CORNAME"
			],
			DATA: [
				[
					"100",
					"BIOL",
					55,
					"Physiology"
				],
				[
					"500",
					"BIOL",
					57,
					"Plant Biology"
				],
				[
					"800",
					"BIOL",
					58,
					"Microbiology"
				],
				[
					"510",
					"BIOL",
					59,
					"Neurobiology"
				],
				[
					"820",
					"BIOL",
					60,
					"Neurobiology"
				],
				[
					"100",
					"CHEM",
					61,
					"General Chemistry"
				],
				[
					"500",
					"CHEM",
					62,
					"Analytical Chemistry"
				],
				[
					"100",
					"ECON",
					64,
					"Financial Accounting"
				],
				[
					"110",
					"ECON",
					65,
					"Business Law"
				],
				[
					"100",
					"MATH",
					71,
					"Calculus I"
				],
				[
					"500",
					"MATH",
					72,
					"Calculus II"
				],
				[
					"800",
					"MATH",
					79,
					"Linear Algebra"
				],
				[
					"420",
					"ECON",
					80,
					"Microeconomics"
				],
				[
					"800",
					"CHEM",
					81,
					"Organic Chemistry"
				]
			]
		} /> 
        
        <!--- convert object to JSON ---> 
        <cfset Local.coursesJSON = SerializeJson(Local.coursesObj) />
		<!--- convert JSON to query ---> 
        <cfset Local.courses = DeserializeJSON(Local.coursesJSON, false) />
        <cfset Local.sheet = SpreadsheetNew() />
        <!--- add query data to spreadsheet ---> 
        <cfset SpreadsheetAddRows(Local.sheet,Local.courses) />
		
		<!--- loop through query rows --->		
        <cfloop query="Local.courses">
		  <cfset Local.columns = Local.courses.columnList />
          <cfset Local.counter = 1 />
          <!--- loop through query columns --->
          <cfloop list="#Local.columns#" index="Local.column">
			<!--- access query cell data via object array notation --->
			<cfset Local.columnData = Local.courses[Local.column][Local.courses.currentRow] />
            <cfset checkRowValues(Local.sheet, Local.columnData, Local.courses.currentRow, Local.counter) />
			<cfset Local.counter = Local.counter + 1 />
          </cfloop>
        </cfloop>
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

