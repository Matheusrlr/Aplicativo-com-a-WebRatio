$$
import org.apache.commons.lang.StringUtils

setJavaOutput()
def context = tag["context"]
if (StringUtils.isEmpty(context)) {
	def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
		    "wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
		    "wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate", "wr:NavigationBar"])
	def loopTags = ancestorTags.findAll{names.contains(it.name)}
	if (loopTags.empty) {
	    tagProblems.addFatalError("<wr:URL/> must be surrounded by one of the following tags: " + names)
	}
    def loopTagVar = loopTags[0].attributes.var 
    if (!StringUtils.isEmpty(loopTagVar)) {
        var = loopTagVar
    } else {
        var = "_wr_var" + (loopTags.size() - 1)
    }
}
$$#