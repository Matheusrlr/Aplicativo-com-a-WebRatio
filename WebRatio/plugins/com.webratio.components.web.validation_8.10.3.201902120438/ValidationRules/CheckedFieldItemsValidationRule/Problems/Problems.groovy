import org.apache.commons.lang.math.NumberUtils
import java.lang.*

def name = element["name"] ? element["name"] : element["id"]
def itemCount = element["itemCount"]

if (itemCount == "") {
    addError("The Item Count of the validation rule '" + name + "' is undefined")
}