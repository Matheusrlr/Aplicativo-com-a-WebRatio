$$
import org.apache.commons.lang.StringUtils

setJavaOutput() 
def otherwise = tag["otherwise"]
def context = tag["context"]
if (StringUtils.isEmpty(context)) {
    def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
	        "wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
	        "wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate"])
    def loopTags = ancestorTags.findAll{names.contains(it.name)}
    if (loopTags.empty) {
        tagProblems.addFatalError("<wr:NonVisible/> must be surrounded by one of the following tags: " + names)
    }
    if (StringUtils.isEmpty(loopTags[0].attributes.var)) {
        context = "_wr_var" + (loopTags.size() - 1)
    } else {
        context = loopTags[0].attributes.var
    }
}
def selector = StringUtils.defaultIfEmpty(tag["select"], ".")

/* Target accessibility and visibility condition check */
$$
</c:if>
$$

/* Always skip body if element can never be hidden */
$$ <% } %> $$

/* Always skip body when applied to AJAX events with no presentation */
$$ <% } %> $$
