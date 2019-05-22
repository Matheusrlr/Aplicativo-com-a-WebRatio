-- EstabelecimentosTipo [rel3]
alter table `topico`   drop foreign key `fk_topico_tipo`;
alter table `topico`  drop column  `oid_tipo`;
