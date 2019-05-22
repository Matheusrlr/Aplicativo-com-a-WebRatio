#?delimiters [%, %], [%=, %]
$$
setJavaOutput()

def context = tag["context"]
def key = tag["key"]
if (context && key) {
	tagProblems.addFatalError("Cannot use 'context' and 'key' attributes together")
} 

if (key) {
	$${{ '[% printRaw(jsExpressionFilter($$ printRaw(key) $$)) %]' | wrLocalize }}$$
} else {
	if (!context) {
		def names = ["wr:Iterate"] as Set
		def loopTag = ancestorTags.find { names.contains(it.name) }
		if (!loopTag) {
			tagProblems.addFatalError("Attribute 'context' is mandatory unless inside wr:Iterate")
		}
		context = loopTag.attributes.var
	}
	def selector = tag["select"] ?: "."
	
	$$[% if (getEffectiveLocalizedElement($$= context $$?.selectSingleNode("$$= selector $$"))) {
		%]{{ '[% printRaw(jsExpressionFilter(getTitle($$= context $$?.selectSingleNode("$$= selector $$")))) %]' | wrLocalize }}[%
	} else {
		%][%= getTitle($$= context $$?.selectSingleNode("$$= selector $$")) %][%
	} %]$$
}