$$
import org.apache.commons.lang.StringUtils

setJavaOutput()
def context = tag["context"]
if (context == null || StringUtils.isEmpty(context)) {
	tagProblems.addFatalError("<wr:Id/>: the context attribute is mandatory")
}
$$[%=page["id"]%]