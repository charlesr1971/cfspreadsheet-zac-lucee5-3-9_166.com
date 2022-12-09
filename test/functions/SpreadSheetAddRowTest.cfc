<cfcomponent extends="testbox.system.compat.framework.TestCase">

	<cffunction name="testDefaultRow" access="public" returnType="void">
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
		
		<!--- loop through query rows --->
        <cfset Local.data = "" />		
        <cfloop query="Local.courses" startrow="1" endrow="1">
		  <cfset Local.columns = Local.courses.columnList />
          <cfset Local.counter = 1 />
          <!--- loop through query columns --->
          <cfloop list="#Local.columns#" index="Local.column">
			<!--- access query cell data via object array notation --->
			<cfset Local.columnData = Local.courses[Local.column][Local.courses.currentRow] />
            <cfset Local.data = ListAppend(Local.data, Local.columnData) />
			<cfset Local.counter = Local.counter + 1 />
          </cfloop>
        </cfloop>
        <!--- add data to spreadsheet ---> 
        <cfset SpreadsheetAddRow(Local.sheet, Local.data) />
        <cfset Local.counter = 1 />
        <cfloop list="#Local.data#" index="Local.columnData">
		  <cfset checkRowValues(Local.sheet, Local.columnData, 1, Local.counter) />
          <cfset Local.counter = Local.counter + 1 />
        </cfloop>
	</cffunction>		

	<cffunction name="checkRowValues" access="private" returnType="void">
		<cfargument name="sheet" 	type="any" />
		<cfargument name="data" 	type="string" hint="List of expected data values"/>
		<cfargument name="startRow" type="numeric" default="1" />
		<cfargument name="startCol" type="numeric" default="1" />
		<cfargument name="delim" 	type="string" default="," hint="data delimiter" />
       
		<cfset Local.rowOffset = arguments.startRow - 1 />
		<cfset Local.endRow = arguments.startRow + listLen(arguments.data, arguments.delim) - 1 />
        
		<cfloop from="#arguments.startRow#" to="#Local.endRow#" index="Local.row">
			<cfset Local.expected = listGetAt( arguments.data, (Local.row-Local.rowOffset), arguments.delim ) />
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

