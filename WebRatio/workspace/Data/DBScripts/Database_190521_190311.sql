-- Categoria_Tipo [as4]
alter table `tipo`  add column  `categoria_2_oid`  integer;
alter table `tipo`   add index fk_tipo_categoria_2_2 (`categoria_2_oid`), add constraint fk_tipo_categoria_2_2 foreign key (`categoria_2_oid`) references `categoria_2` (`oid`);


-- Tipo_Topico [as5]
alter table `topico`  add column  `tipo_oid`  integer;
alter table `topico`   add index fk_topico_tipo_2 (`tipo_oid`), add constraint fk_topico_tipo_2 foreign key (`tipo_oid`) references `tipo` (`oid`);


