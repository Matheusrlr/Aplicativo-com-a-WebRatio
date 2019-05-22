$$
import org.apache.commons.lang.StringUtils

setJavaOutput()
def position = tag["position"]
if (StringUtils.isEmpty(position)) {
    tagProblems.addFatalError("<wr:LandmarkOperationLink>: the position attribute is mandatory")
}
def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
		"wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
		"wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate"])
def loopTags = ancestorTags.findAll{names.contains(it.name)}
def var = "_wr_var" + loopTags.size()
$$
<% for ($$= var $$ in safeSubList(getAvailableLandmarks(page, 1, LandmarkType.ACTION, LandmarkType.FLOATING_EVENT), "$$= position $$-$$= position $$")) { %>