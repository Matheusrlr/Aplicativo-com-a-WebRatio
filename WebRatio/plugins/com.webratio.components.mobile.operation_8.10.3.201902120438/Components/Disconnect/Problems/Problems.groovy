def roleId = component["associationRole"]
def componentName = component["name"] ? component["name"] : component["id"]

if (roleId == "") {
	addError("Unspecified Association Role")
} else {
	def role = getByIdOptional(roleId)
	if (role != null) {
		def roleName = role["name"] ? role["name"] : role["id"]
		def errorCol = findUnmodifiableRoleNameColumn(role);
		if (errorCol != null) {
			addError("Unmodifiable Association Role: '" + errorCol + "' is a key column")
		}
	}
}