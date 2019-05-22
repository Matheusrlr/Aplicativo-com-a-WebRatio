import org.apache.commons.lang.StringUtils
import org.apache.commons.lang.math.NumberUtils

def name = component["name"] ? component["name"] : component["id"]

def componentName = component["name"]
def mode = component["mode"]

if (mode != "write") {
	if (component["sourceType"] == "") {
	    addError("Missing value for the attribute 'Source Type'")
	} else if (component["sourceType"] == "static") {
	    def excelFileValue = component["url"]
		if (excelFileValue != "") {
			def excelFile = getContentFileOptional(excelFileValue)
			if (excelFile == null) {
			    addError("The Excel file '" + excelFileValue + "' for the component '" + name + "' does not exist.")
			}
	    }else{
	        addError("The path to the Excel file has not been specified")
	    }
	}
}

for (cellInfo in component.selectNodes("CellInfo")) {
	def label = cellInfo["name"]
   
   	//validate the index	
   	if (NumberUtils.isDigits(cellInfo["sheet"])) {
    	def sheet = NumberUtils.toInt(cellInfo["sheet"])
     		
    	if (sheet == 0) {
    		def fix = createChangeAttributeFix("Change the sheet index to 1", "sheet", "1")
    		addError(cellInfo, "The sheet index '" + cellInfo["sheet"] + "' is not valid, use a one-based index or the name directly", fix)
    	}
   	}
   
	//validate the column
	if (component["useHeader"] != "true") {
    	def column = cellInfo["column"]
    	if (StringUtils.isBlank(column)) {
        	addError(cellInfo, "The column code has not been defined")
       	} else if (NumberUtils.isDigits(cellInfo["column"])) {
          	addError(cellInfo, "The column code has been defined as an integer index but the expected type is an Excel code like: A, B or AC")
       	}
   	}
   
	//validate row(s)
	if(!StringUtils.isBlank(cellInfo["rows"])){
    	def range = StringUtils.splitByWholeSeparator(cellInfo["rows"], ":")
     	if (range.length == 2) {
      		if (range[0] == "0") {
      			def fix = createChangeAttributeFix("Change the row range to '1:"+range[1], "rows", "1:"+range[1])
      			addError(cellInfo, "The row range '" + cellInfo["rows"] + "' is not valid, use a one-based index as start index", fix)
      		} else if (!StringUtils.isBlank(range[1]) && (NumberUtils.toInt(range[0]) > NumberUtils.toInt(range[1]))) {
        		addError(cellInfo, "The row range is invalid")
      		}        
     	} else if (range.length == 1) {
      		if (range[0] == "0") {
      			def fix = createChangeAttributeFix("Change the row index to '1'", "rows", "1")
      			addError(cellInfo, "The row index '" + cellInfo["rows"] + "' is not valid, use a one-based index", fix)
      		} else if (!NumberUtils.isDigits(range[0])) {
        		addWarning(cellInfo, "The row is invalid, use a one-based index")
      		} 
     	} else {
       		addWarning(cellInfo, "The row range is invalid")
     	}
	}
}