import org.apache.commons.lang.StringUtils

def dClassId = component["dataBinding"]
def componentName = component["name"] ? component["name"] : component["id"]

if (dClassId == "") {
	addError("The class for the operation '" + componentName + "' is unspecified")
}

def selector = component.element("ConditionalExpression")

if ((selector == null) || (selector.selectSingleNode("KeyCondition | AttributesCondition | AssociationRoleCondition") == null)) {
    addError("The Update Component '" + componentName + "' requires at least one Conditional Expression")
}

def dClass = getById(dClassId)

if (dClass != null) {
	def prefix = component["id"] + "."
	def incomingRoles = getOutgoingRoles(dClass).findAll{it["maxCard"] == "1"}.collect{getOppositeRole(it)}
	def roleMap = new HashMap()
	incomingRoles.each{role -> role.selectNodes("db:JoinColumn").each{roleMap.put(it["name"], role)}}
	def parameterBindings = []
	getEnteringFlows(component).each{parameterBindings.addAll(it.selectNodes("ParameterBinding"))}
	
	if(dClass["duration"] == "persistent" || dClass["duration"] == ""){
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
		      		def newTargetName = null
		      		if(component.selectSingleNode("ConditionalExpression/KeyCondition") != null){
		      		    newTargetName = component.selectSingleNode("ConditionalExpression/KeyCondition")["id"] + "." + keyAttr?.valueOf("@id")
		      		}
		      		def newTargetLabel = keyAttr["name"] ? keyAttr["name"] : keyAttr["id"]
		      		def coupled = parameterBindings.any{it["target"] == newTargetName}
		      		if(!coupled && newTargetName != null) {
						def fix = createChangeAttributeFix("Use the input parameter " + newTargetLabel + " instead.", "target", newTargetName);
		      			// TODO old key: UNMODIFIABLE_ATTR_ERROR
		      			addError("The association role " + roleName + " is not modifiable because the column " + targetColumn + " is used as key column.", fix)
		      		} else {
		      			addWarning("The association role " + roleName + " is not modifiable because the column " + targetColumn + " is used as key column.")
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
		     def newTargetName = (keyAtts.size() > 0) ? component["id"] + "key." + keyAtts[0]?.valueOf("@id") : prefix + inverseRole["id"] + "." + targetAttr
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