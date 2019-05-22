def ctxParamIds = component["contextParameters"]
def ctxParamIdSet = new HashSet(ctxParamIds.tokenize(" "))
def name = component["name"] ? component["name"] : component["id"]

searchModuleInstancesForWarnings = { instances, visitedModuleInstanceIds, theUnit ->
    def ancestorModule = theUnit.selectSingleNode("ancestor::HybridModuleDefinition|ancestor::ActionDefinition|ancestor::ContentModuleDefinition")
    if (ancestorModule == null) {
        return
    }
    if (wr.moduleInstancesByModulesForWarnings == null) {
        wr.moduleInstancesByModulesForWarnings = [:]
        for (moduleInstanceUnit in wr.project.selectNodes("//*[self::Action or self::Module]")) {
            def moduleId = moduleInstanceUnit["definition"]
            if (moduleId != "") {
                def moduleInstanceIds = wr.moduleInstancesByModulesForWarnings[moduleId]
                if (moduleInstanceIds == null) {
                    moduleInstanceIds = []
                    wr.moduleInstancesByModulesForWarnings[moduleId] = moduleInstanceIds
                }
                moduleInstanceIds.add(moduleInstanceUnit["id"])
            }
        }
    }
    def refModuleInstanceIds = wr.moduleInstancesByModulesForWarnings[ancestorModule["id"]]
    if (refModuleInstanceIds == null) {
        return
    }
    for (refModuleInstance in refModuleInstanceIds.collect{getById(it)}) {
        if (refModuleInstance != null) {
            if (refModuleInstance.selectSingleNode("ancestor::ModuleView") == null) {
                instances.add(refModuleInstance)
            } else if (!visitedModuleInstanceIds.contains(refModuleInstance["id"])) {
                visitedModuleInstanceIds.add(refModuleInstance["id"])
                searchModuleInstancesForWarnings(instances, visitedModuleInstanceIds, refModuleInstance)
            }
        }
    }
}

if (ctxParamIdSet.contains("RunningProfileCtxParam") && component.document.rootElement.selectSingleNode("RunningProfiles/RunningProfile") == null) {
   addError("The parameter 'RunningProfileCtxParam' referenced by the component '" + name + "' is not implicitly set in a web project without running profiles")
}
def flows = getExitingFlows(component)
for (flow in flows.findAll{it.name != "DataFlow"}) {
	def flowName = flow["name"] ? flow["name"] : flow["id"]
    addError("The flow '" + flowName + "' outgoing from the component '" + name + "' is not a data flow")
}