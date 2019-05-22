-- Categoria_Topico [as2]
create table `categoria_topico` (
   `categoria_2_oid`  integer not null,
   `topico_oid`  integer not null,
  primary key (`categoria_2_oid`, `topico_oid`)
);
alter table `categoria_topico`   add index fk_categoria_topico_categoria (`categoria_2_oid`), add constraint fk_categoria_topico_categoria foreign key (`categoria_2_oid`) references `categoria_2` (`oid`);
alter table `categoria_topico`   add index fk_categoria_topico_topico (`topico_oid`), add constraint fk_categoria_topico_topico foreign key (`topico_oid`) references `topico` (`oid`);


