#?delimiters [%, %], [%=, %]
$$
setJavaOutput()

def context = tag["context"]
if (!context) {
    def names = ["wr:Iterate"] as Set
    def loopTag = ancestorTags.find { names.contains(it.name) }
    if (!loopTag) {
        tagProblems.addFatalError("The context attribute is mandatory outside of " + names)
    }
    context = loopTag.attributes.var
}
def selector = tag["select"] ?: "."
$$[%
	printRaw(executeContextTemplate("MVC/LayoutElement.template", [\
		"_elem": $$= context $$?.selectSingleNode("$$= selector $$"), \
		"_layoutTagAttributes": [$$
			$$"mode": "error",$$
			if (tag["item"]) {
				$$"item": $$= tag["item"] $$,$$
			}
		$$]\
	]))
%]