-- Categoria_Topico [as1]
alter table `topico`  add column  `categoria_2_oid_2`  integer;
alter table `topico`   add index fk_topico_categoria_2_2 (`categoria_2_oid_2`), add constraint fk_topico_categoria_2_2 foreign key (`categoria_2_oid_2`) references `categoria_2` (`oid`);


