<cfscript>

  component {

	this.name = 'cfspreadsheetZacLucee539166Test';
	this.sessionManagement = true;
	
	this.customtagpaths = [
		expandpath("..\..\tags")
	];
	this.functionpaths = [
		expandpath("..\..\functions")
	];
	  
	function onRequestStart(targetpath){
	  var local = StructNew();
	  request.coursesObj = {
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
	  };
	  return true;
	}

  }

</cfscript>