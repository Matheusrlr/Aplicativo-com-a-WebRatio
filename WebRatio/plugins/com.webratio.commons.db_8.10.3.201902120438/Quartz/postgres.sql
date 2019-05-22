create table ${QTABLE_PREFIX}JOB_DETAILS(
    SCHED_NAME varchar(120) not null,
    JOB_NAME  varchar(200) not null,
    JOB_GROUP varchar(200) not null,
    DESCRIPTION varchar(250) null,
    JOB_CLASS_NAME   varchar(250) not null, 
    IS_DURABLE bool not null,
    IS_NONCONCURRENT bool not null,
    IS_UPDATE_DATA bool not null,
    REQUESTS_RECOVERY bool not null,
    JOB_DATA bytea null,
    primary key (SCHED_NAME,JOB_NAME,JOB_GROUP)
);

create table ${QTABLE_PREFIX}TRIGGERS(
    SCHED_NAME varchar(120) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    JOB_NAME  varchar(200) not null, 
    JOB_GROUP varchar(200) not null,
    DESCRIPTION varchar(250) null,
    NEXT_FIRE_TIME bigint null,
    PREV_FIRE_TIME bigint null,
    PRIORITY integer null,
    TRIGGER_STATE varchar(16) not null,
    TRIGGER_TYPE varchar(8) not null,
    START_TIME bigint not null,
    END_TIME bigint null,
    CALENDAR_NAME varchar(200) null,
    MISFIRE_INSTR smallint null,
    JOB_DATA bytea null,
    primary key (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    foreign key (SCHED_NAME,JOB_NAME,JOB_GROUP) references ${QTABLE_PREFIX}JOB_DETAILS(SCHED_NAME,JOB_NAME,JOB_GROUP) 
);

create table ${QTABLE_PREFIX}SIMPLE_TRIGGERS(
    SCHED_NAME varchar(120) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    REPEAT_COUNT bigint not null,
    REPEAT_INTERVAL bigint not null,
    TIMES_TRIGGERED bigint not null,
    primary key (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    foreign key (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) references ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

create table ${QTABLE_PREFIX}CRON_TRIGGERS(
    SCHED_NAME varchar(120) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    CRON_EXPRESSION varchar(120) not null,
    TIME_ZONE_ID varchar(80),
    primary key (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    foreign key (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) references ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

create table ${QTABLE_PREFIX}SIMPROP_TRIGGERS(          
    SCHED_NAME varchar(120) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    STR_PROP_1 varchar(512) null,
    STR_PROP_2 varchar(512) null,
    STR_PROP_3 varchar(512) null,
    INT_PROP_1 int null,
    INT_PROP_2 int null,
    LONG_PROP_1 bigint null,
    LONG_PROP_2 bigint null,
    DEC_PROP_1 numeric(13,4) null,
    DEC_PROP_2 numeric(13,4) null,
    BOOL_PROP_1 bool null,
    BOOL_PROP_2 bool null,
    primary key (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    foreign key (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) references ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

create table ${QTABLE_PREFIX}BLOB_TRIGGERS(
    SCHED_NAME varchar(120) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    BLOB_DATA bytea null,
    primary key (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    foreign key (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP) references ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

create table ${QTABLE_PREFIX}CALENDARS(
    SCHED_NAME varchar(120) not null,
    CALENDAR_NAME  varchar(200) not null, 
    CALENDAR bytea not null,
    primary key (SCHED_NAME,CALENDAR_NAME)
);


create table ${QTABLE_PREFIX}PAUSED_TRIGGER_GRPS(
    SCHED_NAME varchar(120) not null,
    TRIGGER_GROUP  varchar(200) not null, 
    primary key (SCHED_NAME,TRIGGER_GROUP)
);

create table ${QTABLE_PREFIX}FIRED_TRIGGERS(
    SCHED_NAME varchar(120) not null,
    ENTRY_ID varchar(95) not null,
    TRIGGER_NAME varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    INSTANCE_NAME varchar(200) not null,
    FIRED_TIME bigint not null,
    PRIORITY integer not null,
    STATE varchar(16) not null,
    JOB_NAME varchar(200) null,
    JOB_GROUP varchar(200) null,
    IS_NONCONCURRENT bool null,
    REQUESTS_RECOVERY bool null,
    primary key (SCHED_NAME,ENTRY_ID)
);

create table ${QTABLE_PREFIX}SCHEDULER_STATE(
    SCHED_NAME varchar(120) not null,
    INSTANCE_NAME varchar(200) not null,
    LAST_CHECKIN_TIME bigint not null,
    CHECKIN_INTERVAL bigint not null,
    primary key (SCHED_NAME,INSTANCE_NAME)
);

create table ${QTABLE_PREFIX}LOCKS(
    SCHED_NAME varchar(120) not null,
    LOCK_NAME  varchar(40) not null, 
    primary key (SCHED_NAME,LOCK_NAME)
);

create index IDX_${TABLE_PREFIX}J_REQ_RECOVERY on ${QTABLE_PREFIX}JOB_DETAILS(SCHED_NAME,REQUESTS_RECOVERY);
create index IDX_${TABLE_PREFIX}J_GRP on ${QTABLE_PREFIX}JOB_DETAILS(SCHED_NAME,JOB_GROUP);
create index IDX_${TABLE_PREFIX}T_J on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,JOB_NAME,JOB_GROUP);
create index IDX_${TABLE_PREFIX}T_JG on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,JOB_GROUP);
create index IDX_${TABLE_PREFIX}T_C on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,CALENDAR_NAME);
create index IDX_${TABLE_PREFIX}T_G on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,TRIGGER_GROUP);
create index IDX_${TABLE_PREFIX}T_STATE on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,TRIGGER_STATE);
create index IDX_${TABLE_PREFIX}T_N_STATE on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP,TRIGGER_STATE);
create index IDX_${TABLE_PREFIX}T_N_G_STATE on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,TRIGGER_GROUP,TRIGGER_STATE);
create index IDX_${TABLE_PREFIX}T_NEXT_FIRE_TIME on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,NEXT_FIRE_TIME);
create index IDX_${TABLE_PREFIX}T_NFT_ST on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,TRIGGER_STATE,NEXT_FIRE_TIME);
create index IDX_${TABLE_PREFIX}T_NFT_MISFIRE on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME);
create index IDX_${TABLE_PREFIX}T_NFT_ST_MISFIRE on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_STATE);
create index IDX_${TABLE_PREFIX}T_NFT_ST_MISFIRE_GRP on ${QTABLE_PREFIX}TRIGGERS(SCHED_NAME,MISFIRE_INSTR,NEXT_FIRE_TIME,TRIGGER_GROUP,TRIGGER_STATE);
create index IDX_${TABLE_PREFIX}FT_TRIG_INST_NAME on ${QTABLE_PREFIX}FIRED_TRIGGERS(SCHED_NAME,INSTANCE_NAME);
create index IDX_${TABLE_PREFIX}FT_INST_JOB_REQ_RCVRY on ${QTABLE_PREFIX}FIRED_TRIGGERS(SCHED_NAME,INSTANCE_NAME,REQUESTS_RECOVERY);
create index IDX_${TABLE_PREFIX}FT_J_G on ${QTABLE_PREFIX}FIRED_TRIGGERS(SCHED_NAME,JOB_NAME,JOB_GROUP);
create index IDX_${TABLE_PREFIX}FT_JG on ${QTABLE_PREFIX}FIRED_TRIGGERS(SCHED_NAME,JOB_GROUP);
create index IDX_${TABLE_PREFIX}FT_T_G on ${QTABLE_PREFIX}FIRED_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP);
create index IDX_${TABLE_PREFIX}FT_TG on ${QTABLE_PREFIX}FIRED_TRIGGERS(SCHED_NAME,TRIGGER_GROUP);

