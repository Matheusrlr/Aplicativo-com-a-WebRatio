#?delimiters [%, %], [%=, %]
$$
setJavaOutput()

def context = tag["context"]
if (!context) {
	def names = ["wr:Iterate"] as Set
	def loopTag = ancestorTags.find { names.contains(it.name) }
	if (!loopTag) {
		tagProblems.addFatalError("Attribute 'context' is mandatory unless inside wr:Iterate")
	}
	context = loopTag.attributes.var
}
def selector = tag["select"] ?: "."
$$[%
	printRaw(executeContextTemplate("MVC/LayoutElement.template", [\
		"_elem": $$= context $$?.selectSingleNode("$$= selector $$"), \
		"_layoutTagAttributes": [$$
			if (tag["item"]) {
				$$"item": $$= tag["item"] $$,$$
			}
			if (tag["position"]) {
				$$"position": $$= tag["position"] $$,$$
			}
			if (tag["type"]) {
				$$"type": "$$= tag["type"] $$",$$
			}
			if (tag["class"]) {
				$$"class": "$$= tag["class"] $$",$$
			}
		$$] \
	]))
%]