<!---<cfscript>
  dump(var=getApplicationSettings(), expand=false, label="getApplicationSettings");
  flush;
  test = SpreadsheetNew("test");
  dump( var=isSpreadsheetObject(test),label="IsSpreadsheetObject");

  dump(var=spreadsheetInfo(test), label="spreadsheetInfo");

  courses = spreadsheetRead(expandPath(".\courses.xls"));
  dump(var=spreadsheetInfo(courses), label="spreadsheetInfo courses.xls");
</cfscript>--->

<cfoutput>

<!---<cfinclude template='cfspreadsheet-lucee-5-master/extension/functions/SpreadsheetNew.cfm' />--->

<!---<cfset functionLocation = getDirectoryFromPath( getCurrentTemplatePath() ) & "extension\functions" />
<cfset qGetFiles = DirectoryList(functionLocation,false,'query','*.cfm','asc','file') />
<cfloop query="#qGetFiles#">
  <cfinclude template="./cfspreadsheet-lucee-5-master/extension/functions/#qGetFiles.Name#" />
</cfloop>--->

#Now()#

<!--- Read data from two datasource tables. ---> 
<cfquery name="courses" datasource="cfdocexamples" cachedwithin="#CreateTimeSpan(0, 6, 0, 0)#"> 
  SELECT CORNUMBER,DEPT_ID,COURSE_ID,CORNAME 
  FROM COURSELIST 
</cfquery> 
  
<cfquery name="centers" datasource="cfdocexamples" cachedwithin="#CreateTimeSpan(0, 6, 0, 0)#"> 
  SELECT * 
  FROM CENTERS 
</cfquery> 
      
<cfscript> 
  //Use an absolute path for the files. ---> 
  theDir=GetDirectoryFromPath(GetCurrentTemplatePath()); 
  theFile=theDir & "courses.xls"; 
  //Create two empty ColdFusion spreadsheet objects. ---> 
  theSheet = SpreadsheetNew("CourseData"); 
  theSecondSheet = SpreadsheetNew("CentersData"); 
  //Populate each object with a query. ---> 
  SpreadsheetAddRows(theSheet,courses); 
  SpreadsheetAddRows(theSecondSheet,centers); 
</cfscript> 
  
<!--- Write the two sheets to a single file ---> 
<cf_spreadsheet action="write" filename="#theFile#" name="theSheet" 
    sheetname="courses" overwrite=true> 
<cf_spreadsheet action="write" filename="#theFile#" name="theSecondSheet"
    sheetname="centers" overwrite=true> 
  
<!--- Read all or part of the file into a spreadsheet object, CSV string, 
      HTML string, and query. ---> 
<cf_spreadsheet action="read" src="#theFile#" sheetname="courses" name="spreadsheetData"> 
<cf_spreadsheet action="read" src="#theFile#" sheet=1 rows="3,4" format="csv" name="csvData"> 
<cf_spreadsheet action="read" src="#theFile#" format="html" rows="5-10" name="htmlData"> 
<cf_spreadsheet action="read" src="#theFile#" sheetname="centers" query="queryData"> 
  
<h3>First sheet row 3 read as a CSV variable</h3> 
<cfdump var="#csvData#"> 
  
<h3>Second sheet rows 5-10 read as an HTML variable</h3> 
<cfdump var="#htmlData#"> 
  
<h3>Second sheet read as a query variable</h3> 
<cfdump var="#queryData#"> 
  
<!--- Modify the courses sheet. ---> 
<cfscript> 
  SpreadsheetAddRow(spreadsheetData,"03,ENGL,230,Poetry 1",8,1); 
  // SpreadsheetAddColumn(spreadsheet=spreadsheetData,data="Basic,Intermediate,Advanced,Basic,Intermediate,Advanced,true,1999,01/01/2022",startRow=3,startColumn=2,insert=true,delimiter=",",format=[7,8,9]); 
  // SpreadsheetAddColumn(spreadsheet=spreadsheetData,data="Basic,Intermediate,Advanced,Basic,Intermediate,Advanced,true,1999,01/01/2022",insert=true,delimiter=",",format=[7,8,9]);
  SpreadsheetAddColumn(spreadsheet=spreadsheetData,data="Basic,Intermediate,Advanced,Basic,Intermediate,Advanced,true,01/01/2022,1234567890123456789012345678901234567890,Basic",insert=true,delimiter=",",format={7: 'boolean', 8: 'mmm d-yy', 9: '0.0000'});
</cfscript> 
  
<!--- Write the updated Courses sheet to a new XLS file ---> 
<cf_spreadsheet action="write" filename="#theDir#updatedFile.xls" name="spreadsheetData" 
    sheetname="courses" overwrite=true> 
<!--- Write an XLS file containing the data in the CSV variable. --->     
<cf_spreadsheet action="write" filename="#theDir#dataFromCSV.xls" name="CSVData" 
    format="csv" sheetname="courses" overwrite=true>





</cfoutput>