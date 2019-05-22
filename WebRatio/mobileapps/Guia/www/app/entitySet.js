
/* Entity for MUser */

$data.Entity.extend("data.AppUser", {
	AppUserToAppRole: {
		type: Array, elementType: "data.AppRole", inverseProperty: "AppRoleToAppUser"
	},
	oid: {
		type: "integer", key: true, computed: true
	},
	username: {
		type: "string"
	},
	remoteOid: {
		type: "integer"
	}
});

/* Entity for MRole */

$data.Entity.extend("data.AppRole", {
	AppRoleToAppUser: {
		type: "data.AppUser", inverseProperty: "AppUserToAppRole"
	},
	AppRoleToAppUser__oid: {
		type: "integer", enumerable: false
	},
	oid: {
		type: "integer", key: true, computed: true
	},
	name: {
		type: "string"
	}
});

/* Entity for cls1 */

$data.Entity.extend("data.Categoria", {
	CategoriaToTPico: {
		type: Array, elementType: "data.Topico", inverseProperty: "TPicoToCategoria"
	},
	CategoriaToMenu: {
		type: "data.Menu", inverseProperty: "MenuToCategoria"
	},
	CategoriaToMenu__oid: {
		type: "integer", enumerable: false
	},
	oid: {
		type: "integer", key: true, computed: true
	},
	descricao: {
		type: "string"
	},
	nome: {
		type: "string"
	},
	imagem: {
		type: "blob"
	},
	imagem_contentType: {
		type: "string"
	},
	imagem_fileName: {
		type: "string"
	},
	imagem_remoteFileId: {
		type: "string"
	},
	imagem_status: {
		type: "integer"
	}
});

/* Entity for cls2 */

$data.Entity.extend("data.Topico", {
	TPicoToCategoria: {
		type: "data.Categoria", inverseProperty: "CategoriaToTPico"
	},
	TPicoToCategoria__oid: {
		type: "integer", enumerable: false
	},
	oid: {
		type: "integer", key: true, computed: true
	},
	valor: {
		type: "integer"
	},
	telefone: {
		type: "string"
	},
	link: {
		type: "string"
	},
	endereco: {
		type: "string"
	},
	descricao: {
		type: "string"
	},
	nome: {
		type: "string"
	},
	logo: {
		type: "blob"
	},
	logo_contentType: {
		type: "string"
	},
	logo_fileName: {
		type: "string"
	},
	logo_remoteFileId: {
		type: "string"
	},
	logo_status: {
		type: "integer"
	}
});

/* Entity for cls3 */

$data.Entity.extend("data.Menu", {
	MenuToCategoria: {
		type: Array, elementType: "data.Categoria", inverseProperty: "CategoriaToMenu"
	},
	MenuToFeedback: {
		type: "data.Feedback", inverseProperty: "FeedbackToMenu", required: true
	},
	MenuToFeedback__oid: {
		type: "integer", enumerable: false
	},
	oid: {
		type: "integer", key: true, computed: true
	},
	logo: {
		type: "blob"
	},
	logo_contentType: {
		type: "string"
	},
	logo_fileName: {
		type: "string"
	},
	logo_remoteFileId: {
		type: "string"
	},
	logo_status: {
		type: "integer"
	}
});

/* Entity for cls4 */

$data.Entity.extend("data.Feedback", {
	FeedbackToMenu: {
		type: "data.Menu", inverseProperty: "MenuToFeedback"
	},
	oid: {
		type: "integer", key: true, computed: true
	},
	sugestao: {
		type: "string"
	},
	sexo: {
		type: "boolean"
	},
	dataNasc: {
		type: "date"
	},
	email: {
		type: "string"
	},
	matrCula: {
		type: "string"
	},
	sobrenome: {
		type: "string"
	},
	nome: {
		type: "string"
	}
});

/* Entity Context */

$data.EntityContext.extend("ManagementContext", {
	data_AppUserSet: {
		type: $data.EntitySet, elementType: data.AppUser
	},
	data_AppRoleSet: {
		type: $data.EntitySet, elementType: data.AppRole
	},
	data_CategoriaSet: {
		type: $data.EntitySet, elementType: data.Categoria
	},
	data_TopicoSet: {
		type: $data.EntitySet, elementType: data.Topico
	},
	data_MenuSet: {
		type: $data.EntitySet, elementType: data.Menu
	},
	data_FeedbackSet: {
		type: $data.EntitySet, elementType: data.Feedback
	}
});
