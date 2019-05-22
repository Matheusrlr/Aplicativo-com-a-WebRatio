def roleId = component["association"]
def componentName = component["name"] ? component["name"] : component["id"]

if (roleId == "") {
	addError("The association role for the operation '" + componentName + "' is unspecified")
} else {
	def role = getByIdOptional(roleId)
	if (role != null) {
		def roleName = role["name"] ? role["name"] : role["id"]
		def errorCol = findUnmodifiableRoleNameColumn(role);
		if (errorCol != null) {
			addError("The association role '" + roleName + "' of the operation '" + componentName + "' is not modifiable because the column '" + errorCol + "' is used as key column")
		}	
	}	
}
