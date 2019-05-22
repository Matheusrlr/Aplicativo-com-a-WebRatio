import org.apache.commons.lang.math.NumberUtils

if ((element.parent.parent.name == "Attribute") && (element["attribute"] == "") && (element.elements("Value").empty)) {
    addError("Missing values or attribute")
}  

