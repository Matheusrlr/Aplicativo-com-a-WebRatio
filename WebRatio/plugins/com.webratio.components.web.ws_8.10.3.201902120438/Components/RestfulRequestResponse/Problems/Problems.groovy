import org.apache.commons.lang.exception.ExceptionUtils

def name = component["name"] ? component["name"] : component["id"]

if (component["endpointURL"] == "" && component["webServiceOperation"] == "") {
    addWarning("Neither an endpoint URL nor a Web Service Operation has been specified for the component '" + name + "'")
}