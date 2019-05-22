$$
import org.apache.commons.lang.StringUtils

setJavaOutput()
def position = tag["position"]
if (StringUtils.isEmpty(position)) {
	tagProblems.addFatalError("<wr:LandmarkEvent>: the position attribute is mandatory")
}
def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
		"wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
		"wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate"])
def loopTags = ancestorTags.findAll{names.contains(it.name)}
def var = "_wr_var" + loopTags.size()
def landmarkTypes
if (tag["type"]) {
	if (tag["type"] == "area") {
		landmarkTypes = ", LandmarkType.AREA"
	} else if (tag["type"] == "operation") {
		landmarkTypes = ", LandmarkType.ACTION, LandmarkType.FLOATING_EVENT"
	} else if (tag["type"] == "page") {
		landmarkTypes = ", LandmarkType.PAGE"
	} else {
		tagProblems.addFatalError("Invalid landmark type '" + tag["type"] + "'")
	}
} else {
	landmarkTypes = ""
}
$$
<% for ($$= var $$ in safeSubList(getAvailableLandmarks(page, 1$$= landmarkTypes $$), "$$= position $$-$$= position $$")) { %>