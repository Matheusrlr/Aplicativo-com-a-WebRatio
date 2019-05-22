-- Categoria_Tipo [as4]
create table `categoria_tipo` (
   `categoria_2_oid`  integer not null,
   `tipo_oid`  integer not null,
  primary key (`categoria_2_oid`, `tipo_oid`)
);
alter table `categoria_tipo`   add index fk_categoria_tipo_categoria_2 (`categoria_2_oid`), add constraint fk_categoria_tipo_categoria_2 foreign key (`categoria_2_oid`) references `categoria_2` (`oid`);
alter table `categoria_tipo`   add index fk_categoria_tipo_tipo (`tipo_oid`), add constraint fk_categoria_tipo_tipo foreign key (`tipo_oid`) references `tipo` (`oid`);


-- Tipo_Topico [as5]
create table `tipo_topico` (
   `tipo_oid`  integer not null,
   `topico_oid`  integer not null,
  primary key (`tipo_oid`, `topico_oid`)
);
alter table `tipo_topico`   add index fk_tipo_topico_tipo (`tipo_oid`), add constraint fk_tipo_topico_tipo foreign key (`tipo_oid`) references `tipo` (`oid`);
alter table `tipo_topico`   add index fk_tipo_topico_topico (`topico_oid`), add constraint fk_tipo_topico_topico foreign key (`topico_oid`) references `topico` (`oid`);


