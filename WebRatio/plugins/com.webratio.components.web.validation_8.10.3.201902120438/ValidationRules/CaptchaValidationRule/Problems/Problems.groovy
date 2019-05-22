import org.apache.commons.lang.math.NumberUtils
import java.lang.*

valRuleName = element["name"] ? element["name"] : element["id"]

if (element.parent.parent["type"] != "string") {
    addError("The validation rule '" + valRuleName + "' must be applied on a field of type string")
} 


if (element["cfg_colorRanges"] != "") {
    def tokens = element["cfg_colorRanges"].tokenize(",")
    if (tokens.size() != 6) {
       addError("The Color Ranges '" + element["cfg_colorRanges"] + "' property of the validation rule '" + valRuleName + "' is not composed by 6 integers")
    } else {
         if (tokens.any{NumberUtils.toInt(it, -1) < 0} || tokens.any{NumberUtils.toInt(it, 256) > 255}) {
      		addError("The Color Ranges '" + element["cfg_colorRanges"] + "' property of the validation rule '" + valRuleName + "' is not composed by integers between 0 and 255")
         }
    }
}
if (element["cfg_background"] != "") {
    def tokens = element["cfg_background"].tokenize(",")
    if (tokens.size() != 3) {
       addError("The Background '" + element["cfg_background"] + "' property of the validation rule '" + valRuleName + "' is not composed by 3 integers")
    } else {
         if (tokens.any{NumberUtils.toInt(it, -1) < 0} || tokens.any{NumberUtils.toInt(it, 256) > 255}) {
      		addError("The Background '" + element["cfg_background"] + "' property of the validation rule '" + valRuleName + "' is not composed by integers between 0 and 255")
         }
    }
}