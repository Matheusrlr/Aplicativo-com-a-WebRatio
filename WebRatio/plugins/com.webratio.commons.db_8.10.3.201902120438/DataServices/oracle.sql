create table "${SCHEMA}"."${TABLE_PREFIX}DELETE_HISTORY" (
   "OID"  number(10,0)  not null,
   "OBJECT_ID"  varchar2(255 char),
   "CLASS_ID"  varchar2(255 char),
   "DELETED_AT"  timestamp,
  primary key ("OID")
);

create index IDX_${TABLE_PREFIX}CLASS_ID on "${SCHEMA}"."${TABLE_PREFIX}DELETE_HISTORY"("CLASS_ID");
create index IDX_${TABLE_PREFIX}OBJECT_ID on "${SCHEMA}"."${TABLE_PREFIX}DELETE_HISTORY"("DELETED_AT");
