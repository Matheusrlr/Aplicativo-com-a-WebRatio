$$
import org.apache.commons.lang.StringUtils

setJavaOutput()
def context = tag["context"]

def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
	    "wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
	    "wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate", "wr:NavigationBar"])
def loopTags = ancestorTags.findAll{names.contains(it.name)}    
if (StringUtils.isEmpty(context)) {
    def loopTagsSize = loopTags.size()
    def loopTagVar = loopTags[0].attributes.var 
    if (loopTagsSize == 0) {
		tagProblems.addFatalError("<wr:Event/> must have a context or it must be surrounded by one of the following tags: " + names)
    }
}
def classAttr = StringUtils.defaultString(tag["class"], "")
$$ 

$$ if (standalone) { $$
<a class="[%="$$=classAttr$$"%]" href="#">[%=("$$=loopTags[0].name$$" - "wr:" - "Landmark") + " level " + "$$=StringUtils.defaultIfEmpty(loopTags[0].attributes.level, "1")$$"%]</a>
$$ } $$