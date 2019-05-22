import org.apache.commons.lang.math.NumberUtils

def name = element["name"] ? element["name"] : element["id"]

if (!(element["value"]  =~ /^[0-9]*[K|M|G]?[b|B]?$/)) {
    addError("The Value '" + element["value"] + "' of the validation rule '" + name + "' is not a positive integer")
}