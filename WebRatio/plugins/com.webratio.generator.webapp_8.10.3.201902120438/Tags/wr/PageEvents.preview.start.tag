$$
setJavaOutput()

def names = new HashSet(["wr:LandmarkOperationMenu", "wr:LandmarkPageMenu", "wr:LandmarkAreaMenu", 
	    "wr:LandmarkMenu", "wr:LandmarkAreaLink", "wr:LandmarkPageLink", "wr:LandmarkOperationLink", 
	    "wr:LandmarkEvent", "wr:PageEvents", "wr:Iterate"])
def loopTags = ancestorTags.findAll{names.contains(it.name)}
def var = "_wr_var" + loopTags.size()
$$[% for ($$=var$$ in page.selectNodes("Events/*")) { %]