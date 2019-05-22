#?delimiters [%, %], [%=, %]
$$
setJavaOutput()

def type = tag["type"]
if (!type) {
	tagProblems.addFatalError("Attribute 'type' is mandatory")
}

/* Check output type validity */
if (!type.startsWith("wr:") && !com.webratio.generator.helpers.OutputType.getBuiltin(type)) {
	tagProblems.addError("Invalid type '" + type + "'")
}

/* Assign output type to a generation variable */
$$[%
	import com.webratio.generator.helpers.OutputType
	
	if (pageOutputType == null || pageOutputType == OutputType.UNKNOWN) {
		pageOutputType = OutputType.getBuiltin("$$= type $$") ?: OutputType.of("$$= type $$")
	} else {
		throwGenerationError("Page output type is specified more than once")
	}
%]$$

/* Print the correct prologue for some types */
def typeInfo = com.webratio.generator.helpers.OutputType.getBuiltin(type)
if (typeInfo?.name == "html") {
	if (typeInfo.version == "5") {
		$$<!DOCTYPE html>$$
	} else if (typeInfo.version == "4") {
		if (typeInfo.variant == "transitional") {
			$$<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">$$
		} else if (typeInfo.variant == null) {
			$$<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">$$
		}
	}
} else if (typeInfo?.name == "xhtml") {
	if (typeInfo.version == "5") {
		$$<!DOCTYPE html>$$
	} else if (typeInfo.version == "1") {
		if (typeInfo.variant == "transitional") {
			$$<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">$$
		} else if (typeInfo.variant == null) {
			$$<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">$$
		}
	}
}
