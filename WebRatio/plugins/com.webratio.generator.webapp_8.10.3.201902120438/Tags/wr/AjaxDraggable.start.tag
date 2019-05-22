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
      tagProblems.addFatalError("<wr:AjaxDraggable/> must be surrounded by one of the following tags: " + names)
    }
    
    def loopTagVar = loopTags[0].attributes.var 
    if (!StringUtils.isEmpty(loopTagVar)) {
        context = loopTagVar
    } else {
        context = "_wr_var" + (loopTagsSize - 1)
    }
    isPageTag = (loopTags[0].name != "wr:Iterate")
}

def item = tag["item"]
if (item == null) {
	item = "''"
}

def position = tag["position"]
if (position == null) {
    position = "''"
}

$$<%printRaw(executeContextTemplate("MVC/Ajax/DraggableGenerator.template", ["element": $$=context$$?.selectSingleNode("$$=selector$$"), "item" : $$printRaw(item)$$, "position" : $$printRaw(position)$$]))%>