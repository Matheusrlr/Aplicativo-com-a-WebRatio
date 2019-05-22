def xsdProvider = element["xsdProvider"]
def name = element["name"] ? element["name"] : element["id"]

if (xsdProvider == "") {
    addError("The XSD provider of the validation rule '"+ name +"' is undefined")
} 