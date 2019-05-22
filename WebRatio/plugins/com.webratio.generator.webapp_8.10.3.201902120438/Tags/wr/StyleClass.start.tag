$$
import org.apache.commons.lang.StringUtils

setJavaOutput()
def context = tag["context"]
if (StringUtils.isEmpty(context)) {
    def names = new HashSet(["wr:Iterate"])
    def loopTag = ancestorTags.find{names.contains(it.name)}
    if (loopTag != null) {
        context = loopTag.attributes.var
    }
}
if (context != null) {$$<%=$$=context$$?.attributeValue("styleClass", "")%>$$} else{$$<%printRaw(executeContextTemplate("MVC/StyleClass.template"))%>$$}$$