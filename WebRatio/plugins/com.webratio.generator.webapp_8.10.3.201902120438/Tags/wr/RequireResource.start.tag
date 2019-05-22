#?delimiters [%, %], [%=, %]
$$
import com.webratio.model.layout.resources.Type
import com.webratio.model.query.layout.resources.Reference
import com.webratio.commons.base.Version

setJavaOutput()

def refs = tag["ref"].split(",").collect { it.trim() }

/* Parse references */
def parsedRefs = refs.collect {
	try {
		return Reference.of(it)
	} catch (IllegalArgumentException e) {
		tagProblems.addError("Invalid reference '${it}' (${e.message})")
		return null
	}
}.findAll { it != null }

/* Check that the referenced resources are available in the style */
def requestedScopes = [] as Set
if (binding.variables.style) {
	parsedRefs.each {
		def resource = style.availableResources[it.name]
		if (resource) {
			def version = resource.version ? Version.of(resource.version) : null
			def scope = Type.forConfigurationName(resource.type).scope
			if (version && !it.matches(it.name, version, scope)) {
				tagProblems.addError("Resource '${it.name}' is available in the style as version ${version}, which is not compatible with the required version range") 
			}
			requestedScopes.add(scope)
		} else {
			tagProblems.addError("Resource '${it.name}' is not available in the style")
		}
	}
}

/* Check that only one scope is requested */
if (requestedScopes.size() > 1) {
	tagProblems.addError("Unable to request client and server resources at the same time")
}

$$[%
	_pageResources.registry.addAll( \
		"$$= tag["ref"] $$".split(",").collect { it.trim() }.collect{ com.webratio.model.query.layout.resources.Reference.of(it.trim()) }, \
		["condition": "$$= tag["condition"] ?: "" $$"], \
		getAvailableResources(getLayoutFileStyle(_wr_template.templateFile) ?: "BUILTIN") \
	)
%]