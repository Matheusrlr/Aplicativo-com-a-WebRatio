-- Device [Device]
create table `device` (
   `oid`  integer  not null,
   `device_id`  varchar(255),
   `notification_device_id`  varchar(255),
   `model`  varchar(255),
   `platform`  varchar(255),
   `platform_version`  varchar(255),
   `browser`  varchar(255),
  primary key (`oid`)
);


-- Role [Role]
create table `role` (
   `oid`  integer  not null,
   `rolename`  varchar(255),
  primary key (`oid`)
);


-- User [User]
create table `user` (
   `oid`  integer  not null,
   `username`  varchar(255),
   `password`  varchar(255),
   `email`  varchar(255),
   `token`  varchar(255),
   `token_expiration_date`  datetime,
   `secretkey`  varchar(255),
  primary key (`oid`)
);


-- Menu [cls1]
create table `menu` (
   `oid`  integer  not null,
   `createdat`  datetime,
   `updatedat`  datetime,
  primary key (`oid`)
);


-- Feedback [cls2]
create table `feedback` (
   `oid`  integer  not null,
   `sugestao`  varchar(255),
   `sexo`  bit,
   `data_nasc`  date,
   `email`  varchar(255),
   `matricula`  varchar(255),
   `sobrenome`  varchar(255),
   `nome`  varchar(255),
   `createdat`  datetime,
   `updatedat`  datetime,
  primary key (`oid`)
);


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


-- Topico [cls4]
create table `topico` (
   `oid`  integer  not null,
   `valor`  integer,
   `telefone`  varchar(255),
   `link`  varchar(255),
   `endereco`  varchar(255),
   `descricao`  varchar(255),
   `nome`  varchar(255),
   `logo`  varchar(255),
   `createdat`  datetime,
   `updatedat`  datetime,
  primary key (`oid`)
);


-- User_Device [User2Device_Device2User]
alter table `device`  add column  `user_oid`  integer;
alter table `device`   add index fk_device_user (`user_oid`), add constraint fk_device_user foreign key (`user_oid`) references `user` (`oid`);


-- User_Role [User2Role_Role2User]
create table `user_role` (
   `user_oid`  integer not null,
   `role_oid`  integer not null,
  primary key (`user_oid`, `role_oid`)
);
alter table `user_role`   add index fk_user_role_user (`user_oid`), add constraint fk_user_role_user foreign key (`user_oid`) references `user` (`oid`);
alter table `user_role`   add index fk_user_role_role (`role_oid`), add constraint fk_user_role_role foreign key (`role_oid`) references `role` (`oid`);


-- Menu_Categoria [as5]
alter table `categoria`  add column  `menu_oid`  integer;
alter table `categoria`   add index fk_categoria_menu (`menu_oid`), add constraint fk_categoria_menu foreign key (`menu_oid`) references `menu` (`oid`);


-- Menu_Feedback [as6]
alter table `feedback`  add column  `menu_oid`  integer;
alter table `feedback`   add index fk_feedback_menu (`menu_oid`), add constraint fk_feedback_menu foreign key (`menu_oid`) references `menu` (`oid`);


-- Categoria_Tópico [as7]
alter table `topico`  add column  `categoria_oid`  integer;
alter table `topico`   add index fk_topico_categoria (`categoria_oid`), add constraint fk_topico_categoria foreign key (`categoria_oid`) references `categoria` (`oid`);


-- Data Services Mapping
create table WR_DELETE_HISTORY(
  `OID`  integer  not null,
  `OBJECT_ID` varchar(200) not null,
  `CLASS_ID` varchar(32) not null,
  `DELETED_AT` datetime not null,
  primary key (`OID`))
ENGINE=InnoDB;

create index IDX_WR_CLASS_ID on WR_DELETE_HISTORY(`CLASS_ID`);
create index IDX_WR_OBJECT_ID on WR_DELETE_HISTORY(`DELETED_AT`);


