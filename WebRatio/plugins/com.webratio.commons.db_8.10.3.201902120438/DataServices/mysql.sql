create table ${QTABLE_PREFIX}DELETE_HISTORY(
  `OID`  integer  not null,
  `OBJECT_ID` varchar(200) not null,
  `CLASS_ID` varchar(32) not null,
  `DELETED_AT` datetime not null,
  primary key (`OID`))
ENGINE=InnoDB;

create index IDX_${QTABLE_PREFIX}CLASS_ID on ${QTABLE_PREFIX}DELETE_HISTORY(`CLASS_ID`);
create index IDX_${QTABLE_PREFIX}OBJECT_ID on ${QTABLE_PREFIX}DELETE_HISTORY(`DELETED_AT`);
