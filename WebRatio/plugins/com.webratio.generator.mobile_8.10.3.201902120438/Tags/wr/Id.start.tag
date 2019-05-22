#?delimiters [%, %], [%=, %]
$$
setJavaOutput()

def context = tag["context"]
def selector = tag["select"] ?: "."

$$[%= $$=context$$.selectSingleNode("$$= selector $$").attributeValue("id", "") %]