-- Categoria [cls3]
create table `categoria` (
   `oid`  integer  not null,
   `descricao`  varchar(255),
   `nome`  varchar(255),
   `imagem`  varchar(255),
   `createdat`  datetime,
   `updatedat`  datetime,
  primary key (`oid`)
);


