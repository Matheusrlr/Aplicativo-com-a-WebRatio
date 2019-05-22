import org.apache.commons.lang.math.NumberUtils

def name = element["name"] ? element["name"] : element["id"]

if (element["value"] != "" && NumberUtils.toInt(element["value"], -1) < 0) {
    addError("The Value '" + element["value"] + "' of the validation rule '" + name + "' is not a positive integer")
}