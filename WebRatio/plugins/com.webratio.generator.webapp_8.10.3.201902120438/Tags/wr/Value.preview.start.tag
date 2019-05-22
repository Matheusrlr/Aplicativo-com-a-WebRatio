$$
import org.apache.commons.lang.StringUtils

setJavaOutput()
def context = tag["context"]
if (StringUtils.isEmpty(context)) {
    def names = new HashSet(["wr:Iterate"])
    def loopTag = ancestorTags.find{names.contains(it.name)}
    if (loopTag == null) {
        tagProblems.addFatalError("<wr:Value/>: the context attribute is mandatory")
    }
}
$$
<span class="$$=tag.class$$">value</span>