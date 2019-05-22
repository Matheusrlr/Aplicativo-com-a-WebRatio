-- REL FK: TipoToCategoria [rel2#role7]
alter table `tipo`   add index fk_categoria_2_tipo (`oid`, `oid_categoria`), add constraint fk_categoria_2_tipo foreign key (`oid`, `oid_categoria`) references `tipo` (`oid`, `oid_categoria`);


