import org.apache.commons.lang.StringUtils

def dClassId = component["dataBinding"]
def name = component["name"] ? component["name"] : component["id"]

if (dClassId == "") {
	addError("The class for the component '" + name + "' is unspecified")
}

def dClass = getByIdOptional(dClassId)

if (dClass != null) {

	def prefix = component["id"] + "."
	def incomingRoles = getOutgoingRoles(dClass).findAll{it["maxCard"] == "1"}.collect{getOppositeRole(it)}
	
	def roleMap = new HashMap()
	incomingRoles.each{role -> role.selectNodes("db:JoinColumn").each{roleMap.put(it["name"], role)}}
	def parameterBindings = []
	getEnteringFlows(component).each{parameterBindings.addAll(it.selectNodes("ParameterBinding"))}


	if((dClass["duration"] == "persistent" || dClass["duration"] == "")){
		for (parameterBinding in parameterBindings) {
	      def inputId = StringUtils.removeStart(parameterBinding["target"], prefix) 
			if(inputId.indexOf(".") > 0){
				def roleId = StringUtils.substringBefore(inputId, ".")
				def role = getById(roleId)
				def roleName = role["name"] ? role["name"] : role["id"]
				if (role == null || (role.parent["sourceClass"] == role.parent["targetClass"])) {
					continue
				}
				if(role.parent.valueOf("@db:table") != dClass.valueOf("@db:table")){
				    continue
				}
				def inverseRole = getOppositeRole(role)
				def attrId = StringUtils.substringAfterLast(inputId, ".")
				def targetColumn = inverseRole.valueOf("db:JoinColumn[@attribute = '" + attrId + "']/@name") 
				def columns = role.selectNodes("db:JoinColumn").collect{it["name"]}
				def keyColumns = [:]
				if(getSuperDomainClass(dClass) != null){
				   dClass.selectNodes("Generalization/db:JoinColumn").each{keyColumns.put(it["name"], it["attribute"])}  	
				} else {
				   getKeyAttributes(dClass).each{keyColumns.put(it.valueOf("@db:column"),it["id"])}
				}
				if (keyColumns.containsKey(targetColumn)) {
					def keyAttr = getById(keyColumns.get(targetColumn))
					def newTargetName = prefix + keyAttr?.valueOf("@id")
					def newTargetLabel = keyAttr["name"] ? keyAttr["name"] : keyAttr["id"]
					def coupled = parameterBindings.any{it["target"] == newTargetName}
					def fix = createChangeAttributeFix("Use the input parameter " + newTargetLabel + " instead.", "target", newTargetName)
					if (coupled) {
						addWarning("The association role " + roleName + " is not modifiable because the column " + targetColumn + " is used as key column.", fix)
					} else {
						// TODO old key: UNMODIFIABLE_ATTR_ERROR
						addError("The association role " + roleName + " is not modifiable because the column " + targetColumn + " is used as key column.", fix)
					}   		      		
				 }
				 continue
			}
			def attr = getByIdOptional(inputId)
			if(attr == null || attr["key"] == "true"){
				continue
			}
			def column = attr?.valueOf("@db:column")
			if(column == ""){
				continue
			}
			def role = roleMap.get(column)
			if(role != null){
				def targetAttr = role.selectSingleNode("db:JoinColumn[@name = '" + column + "']")?.valueOf("@attribute")    
				def inverseRole = getOppositeRole(role)
				def keyAtts = getKeyAttributes(dClass).findAll{it.valueOf("@db:column") == column}
				def newTargetName = (keyAtts.size() > 0) ? prefix + keyAtts[0]?.valueOf("@id") : prefix + inverseRole["id"] + "." + targetAttr
				def keyAttr0Name = keyAtts[0]["name"] ? keyAtts[0]["name"] : keyAtts[0]["id"]
				def newTargetLabel = (keyAtts.size() > 0) ? keyAttr0Name : (getLabel(getTargetDomainClass(inverseRole)) + "." + getLabel(getById(targetAttr)) + "(" + getLabel(inverseRole) + ")")
				def attrName = attr["name"] ? attr["name"] : attr["id"]
				def inverseRoleName = inverseRole["name"] ? inverseRole["name"] : inverseRole["id"]
				def fix = createChangeAttributeFix("Use the input parameter " + newTargetLabel + " instead.", "target", newTargetName);
				addError("The attribute " + attrName + " is not modifiable because the column " + column + " maps also the association role " + inverseRoleName, fix);
			}
		}
	}
}