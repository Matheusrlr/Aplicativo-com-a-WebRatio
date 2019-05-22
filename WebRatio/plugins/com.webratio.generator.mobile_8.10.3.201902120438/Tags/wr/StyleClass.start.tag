#?delimiters [%, %], [%=, %]
$$
setJavaOutput()

def context = tag["context"]
if (!context) {
	def names = ["wr:Iterate"] as Set
	def loopTag = ancestorTags.find { names.contains(it.name) }
	if (loopTag) {
		context = loopTag.attributes.var
	}
}
if (context) { 
	$$[%= $$= context $$.attributeValue("styleClass", "") %]$$
} else {
	$$[% printRaw(executeContextTemplate("MVC/StyleClass.template")) %]$$
}
$$