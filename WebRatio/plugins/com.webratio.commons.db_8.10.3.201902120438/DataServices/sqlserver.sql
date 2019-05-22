create table [${SCHEMA}].[${TABLE_PREFIX}DELETE_HISTORY] (
   [OID]  int  not null,
   [OBJECT_ID]  varchar(255),
   [CLASS_ID]  varchar(255),
   [DELETED_AT]  datetime2,
  primary key ([OID])
);

create index IDX_${TABLE_PREFIX}CLASS_ID on [${SCHEMA}].[${TABLE_PREFIX}DELETE_HISTORY]([CLASS_ID]);
create index IDX_${TABLE_PREFIX}OBJECT_ID on [${SCHEMA}].[${TABLE_PREFIX}DELETE_HISTORY]([DELETED_AT]);
