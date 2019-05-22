if(element.parent.parent.name != "Attribute"){
  def field = element.parent.parent
  if(getLayoutElements(field).isEmpty()){
	 def fieldName = field["name"] ? field["name"] : field["id"]
     addError(field, "The mandatory field '" + fieldName + "' is never shown in page")
  }
}
