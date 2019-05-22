-- Categoria_Topico [as1]
alter table `topico`  add column  `categoria_2_oid`  integer;
alter table `topico`   add index fk_topico_categoria_2 (`categoria_2_oid`), add constraint fk_topico_categoria_2 foreign key (`categoria_2_oid`) references `categoria_2` (`oid`);


