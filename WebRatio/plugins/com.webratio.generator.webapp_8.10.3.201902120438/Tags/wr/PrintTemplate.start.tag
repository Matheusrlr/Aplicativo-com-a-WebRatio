#?delimiters [%, %], [%=, %]
$$
import org.apache.commons.lang.StringUtils
setJavaOutput()

def var = tag["var"]
if (!var) {
   tagProblems.addFatalError("Attribute 'var' is mandatory")
}
def type = tag["type"]
def template = tag["template"]
if (!template && !type) {
	tagProblems.addFatalError("Attribute 'type' is mandatory when 'template' is not specified")
}
$$
[%
$$ if (template) { $$
	printRaw(executeTemplate($$= template $$, $$= var $$))
$$ } else { $$
	$$ if (type == "grid") { $$
		printRaw(executeContextTemplate("MVC/Grid.template", ["grid": $$= var $$]))
	$$ } else if (type == "cell") { $$
		printRaw(executeContextTemplate("MVC/Cell.template", ["cell": $$= var $$]))
	$$ } else if (type == "component") { $$
		printRaw(executeContextTemplate("MVC/Component.template", ["component": $$= var $$]))
	$$ } else if (type == "field") { $$
		expandLayoutField($$= var $$)
		printRaw(executeContextTemplate("MVC/Field.template", ["field": $$= var $$, "mode": $$= var $$["mode"], "styleClass" : $$=var$$["styleClass"]]))
	$$ } else if (type == "event") { $$
		expandLayoutEvent($$= var $$)
		printRaw(executeContextTemplate("MVC/Event.template", ["event": $$= var $$, "position": "", "item": getLayoutAttributeItem($$= var $$), "type": "", "styleClass": $$= var $$["styleClass"]]))      
	$$ } else if (type == "attribute") { $$
		expandLayoutAttribute($$= var $$)
		printRaw(executeContextTemplate("MVC/Attribute.template", ["attr": $$= var $$, "mode": $$= var $$["mode"], position: "", "item": getLayoutAttributeItem($$= var $$), "styleClass": $$= var $$["styleClass"]]))
	$$ } $$
$$ } $$