
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
	},
	email: {
		type: "string"
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

/* Entity for cls2 */

$data.Entity.extend("data.Categoria", {
	oid: {
		type: "integer", key: true, computed: true
	},
	decricao: {
		type: "string"
	},
	nome: {
		type: "string"
	},
	remoteOid: {
		type: "integer"
	},
	createdAt: {
		type: "date"
	},
	updatedAt: {
		type: "date"
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

/* Auxiliary entity for cls2 */

$data.Entity.extend("data.Categoria__Aux", {
	oid: {
		type: "integer", key: true, computed: true
	},
	dirty: {
		type: "boolean"
	},
	deletedAt: {
		type: "date"
	},
	d_decricao: {
		type: "boolean"
	},
	d_nome: {
		type: "boolean"
	},
	d_imagem: {
		type: "boolean"
	},
	t_oid: {
		type: "integer"
	},
	t_remoteOid: {
		type: "integer"
	}
});

/* Entity for cls3 */

$data.Entity.extend("data.Estabelecimento", {
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
	remoteOid: {
		type: "integer"
	},
	createdAt: {
		type: "date"
	},
	updatedAt: {
		type: "date"
	},
	oidTip: {
		type: "string"
	}
});

/* Auxiliary entity for cls3 */

$data.Entity.extend("data.Estabelecimento__Aux", {
	oid: {
		type: "integer", key: true, computed: true
	},
	dirty: {
		type: "boolean"
	},
	deletedAt: {
		type: "date"
	},
	d_logo: {
		type: "boolean"
	},
	d_valor: {
		type: "boolean"
	},
	d_telefone: {
		type: "boolean"
	},
	d_link: {
		type: "boolean"
	},
	d_endereco: {
		type: "boolean"
	},
	d_descricao: {
		type: "boolean"
	},
	d_nome: {
		type: "boolean"
	},
	d_oidTip: {
		type: "boolean"
	},
	t_oid: {
		type: "integer"
	},
	t_remoteOid: {
		type: "integer"
	}
});

/* Entity for cls1 */

$data.Entity.extend("data.Tipo", {
	oid: {
		type: "integer", key: true, computed: true
	},
	nome: {
		type: "string"
	},
	remoteOid: {
		type: "integer"
	},
	createdAt: {
		type: "date"
	},
	updatedAt: {
		type: "date"
	},
	oidCat: {
		type: "string"
	}
});

/* Auxiliary entity for cls1 */

$data.Entity.extend("data.Tipo__Aux", {
	oid: {
		type: "integer", key: true, computed: true
	},
	dirty: {
		type: "boolean"
	},
	deletedAt: {
		type: "date"
	},
	d_nome: {
		type: "boolean"
	},
	d_oidCat: {
		type: "boolean"
	},
	t_oid: {
		type: "integer"
	},
	t_remoteOid: {
		type: "integer"
	}
});

/* Entity for cls4 */

$data.Entity.extend("data.Feedback", {
	oid: {
		type: "integer", key: true, computed: true
	},
	remoteOid: {
		type: "integer"
	},
	createdAt: {
		type: "date"
	},
	updatedAt: {
		type: "date"
	},
	email: {
		type: "string"
	},
	matrCula: {
		type: "integer"
	},
	sobrenome: {
		type: "string"
	},
	nome: {
		type: "string"
	},
	sugestao: {
		type: "string"
	}
});

/* Auxiliary entity for cls4 */

$data.Entity.extend("data.Feedback__Aux", {
	oid: {
		type: "integer", key: true, computed: true
	},
	dirty: {
		type: "boolean"
	},
	deletedAt: {
		type: "date"
	},
	d_email: {
		type: "boolean"
	},
	d_matrCula: {
		type: "boolean"
	},
	d_sobrenome: {
		type: "boolean"
	},
	d_nome: {
		type: "boolean"
	},
	d_sugestao: {
		type: "boolean"
	},
	t_oid: {
		type: "integer"
	},
	t_remoteOid: {
		type: "integer"
	}
});

/* Entity for cls5 */

$data.Entity.extend("data.Menu", {
	oid: {
		type: "integer", key: true, computed: true
	},
	remoteOid: {
		type: "integer"
	},
	createdAt: {
		type: "date"
	},
	updatedAt: {
		type: "date"
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

/* Auxiliary entity for cls5 */

$data.Entity.extend("data.Menu__Aux", {
	oid: {
		type: "integer", key: true, computed: true
	},
	dirty: {
		type: "boolean"
	},
	deletedAt: {
		type: "date"
	},
	d_logo: {
		type: "boolean"
	},
	t_oid: {
		type: "integer"
	},
	t_remoteOid: {
		type: "integer"
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
	data_CategoriaSet__Aux: {
		type: $data.EntitySet, elementType: data.Categoria__Aux
	},
	data_EstabelecimentoSet: {
		type: $data.EntitySet, elementType: data.Estabelecimento
	},
	data_EstabelecimentoSet__Aux: {
		type: $data.EntitySet, elementType: data.Estabelecimento__Aux
	},
	data_TipoSet: {
		type: $data.EntitySet, elementType: data.Tipo
	},
	data_TipoSet__Aux: {
		type: $data.EntitySet, elementType: data.Tipo__Aux
	},
	data_FeedbackSet: {
		type: $data.EntitySet, elementType: data.Feedback
	},
	data_FeedbackSet__Aux: {
		type: $data.EntitySet, elementType: data.Feedback__Aux
	},
	data_MenuSet: {
		type: $data.EntitySet, elementType: data.Menu
	},
	data_MenuSet__Aux: {
		type: $data.EntitySet, elementType: data.Menu__Aux
	}
});
