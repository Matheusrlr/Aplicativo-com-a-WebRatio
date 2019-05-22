-- EstabelecimentosTipo [rel3]
alter table `topico`  add column  `oid_tipo`  integer;
alter table `topico`   add index fk_topico_tipo (`oid_tipo`), add constraint fk_topico_tipo foreign key (`oid_tipo`) references `tipo` (`oid_categoria`);


-- REL FK: TipoToCategoria [rel2#role7]
alter table `tipo`   add index fk_categoria_2_tipo (`oid`, `oid_categoria`), add constraint fk_categoria_2_tipo foreign key (`oid`, `oid_categoria`) references `tipo` (`oid`, `oid_categoria`);


