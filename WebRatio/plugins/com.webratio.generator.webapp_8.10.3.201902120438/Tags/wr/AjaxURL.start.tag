$$
import org.apache.commons.lang.StringUtils

setJavaOutput()

def context = tag["context"]
def selector = StringUtils.defaultIfEmpty(tag["select"], ".")
def isPageTag = false
if (StringUtils.isEmpty(context)) {
    def names = new HashSet(["wr:Iterate"])
    def loopTags = ancestorTags.findAll{names.contains(it.name)}
    def loopTagsSize = loopTags.size()
    if (loopTagsSize == 0) {
      tagProblems.addFatalError("<wr:AjaxURL/> must be surrounded by one of the following tags: " + names)
    }
    
    def loopTagVar = loopTags[0].attributes.var 
    if (!StringUtils.isEmpty(loopTagVar)) {
        context = loopTagVar
    } else {
        context = "_wr_var" + (loopTagsSize - 1)
    }
}

def position = tag["position"]
if (position == null) {
    position = "'index'"
}

def escapeXml = tag["escapeXml"]
if (escapeXml == null) {
    escapeXml = "true"
}
def classAttr = StringUtils.defaultString(tag["class"])
def type = StringUtils.defaultString(tag["type"]) + "-ajax"
$$<%printRaw(executeContextTemplate("MVC/Ajax/AjaxURL.template", ["event": $$=context$$?.selectSingleNode("$$=selector$$"), "position": $$=position$$, "escapeXml": $$=escapeXml$$, "type": "$$=type$$", "contextVarName": "$$=context$$/$$=selector$$"]))%>