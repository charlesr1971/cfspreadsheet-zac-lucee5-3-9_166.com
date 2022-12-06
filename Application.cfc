<cfscript>
  component {
    this.name = 'cfspreadsheetZacLucee539166';
    this.sessionManagement = true;
	
	this.dbLocation = expandpath(".\db\cfdocexamples");
	
	this.datasources['cfdocexamples'] = {
	  class: 'org.apache.derby.jdbc.EmbeddedDriver',
	  connectionString: 'jdbc:derby:#this.dbLocation#;create=true;'
    };
    	
	this.customtagpaths = [
		expandpath(".\tags")
	];
	this.functionpaths = [
		expandpath(".\functions")
	];
	this.javasettings.bundle = [
		expandpath(".\jars")
	];
 }
</cfscript>