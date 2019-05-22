#?delimiters [%, %], [%=, %]
$$
import com.webratio.model.layout.resources.Type
import com.webratio.model.layout.resources.Scope

setJavaOutput()

/* Get type names - use all client types as default */
def categoryNames = [] as Set
if (tag["types"]) {
	categoryNames.addAll(tag["types"].split(",").collect { it.trim() })
} else {
	categoryNames.addAll(Type.values().findAll { it.scope == Scope.CLIENT }.collect { it.generationCategoryName })
}

/* Check types and collect client categories */
def requestedScopes = [] as Set
def types = [] as Set
def clientCategoryNames = []
categoryNames.each {
	try {
		def categoryTypes = Type.forGenerationCategoryName(it)
		requestedScopes.addAll(categoryTypes.collect { it.scope })
		types.addAll(categoryTypes)
		if (categoryTypes.find { it.scope == Scope.CLIENT }) {
			clientCategoryNames.add(it)
		}
	} catch (IllegalArgumentException e) {
		tagProblems.addError("Invalid type '${it}')")
	}
}

/* Check that only one scope is requested */
if (requestedScopes.size() > 1) {
	tagProblems.addError("Unable to include client and server resources at the same time")
}

/* Choose the template to use for printing inclusion code */
def templateFileName = (requestedScopes.iterator().next() == Scope.CLIENT ? "ResourcesClient.template" : "ResourcesServer.template")

$$[%
	/* Catch multiple hooks for the same categories */
	_pageResources.hooks = _pageResources.hooks ?: [] as Set
	$$ if (!clientCategoryNames.isEmpty()) { $$
		"$$= clientCategoryNames.join(",") $$".split(",").each {
			if (!_pageResources.hooks.add(it)) {
				throwGenerationException("Multiple inclusions of resources of type '${it}'")
			}
		}
	$$ } $$
	
	/* Print resource inclusion code */
	executeLater {
		def _includedTypes = "$$= types.collect { it.configurationName }.join(",") $$".split(",").collect {
			com.webratio.model.layout.resources.Type.forConfigurationName(it)
		}
		printRaw(executeContextTemplate("MVC/" + "$$= templateFileName $$", [\
			"entries": _pageResources.registry.getSortedEntries().findAll { _includedTypes.contains(it.resource.type) } \
		]))
	}
%]