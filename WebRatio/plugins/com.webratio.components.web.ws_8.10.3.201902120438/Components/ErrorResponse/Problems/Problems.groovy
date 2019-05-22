for (param in component.selectNodes("ErrorResponseParameter")) {
    def xsdProvider = param["xsdProvider"]
    if (xsdProvider != "" && getByIdOptional(xsdProvider) == null) {
       addError(param, "The XSD provider of the parameter '" + param["name"] + "' is not valid")
    }    
}