CREATE TABLE [${SCHEMA}].[${TABLE_PREFIX}CALENDARS] (
  [SCHED_NAME] [VARCHAR] (120)  NOT NULL ,
  [CALENDAR_NAME] [VARCHAR] (200)  NOT NULL ,
  [CALENDAR] [IMAGE] NOT NULL
) ON [PRIMARY]
;

CREATE TABLE [${SCHEMA}].[${TABLE_PREFIX}CRON_TRIGGERS] (
  [SCHED_NAME] [VARCHAR] (120)  NOT NULL ,
  [TRIGGER_NAME] [VARCHAR] (200)  NOT NULL ,
  [TRIGGER_GROUP] [VARCHAR] (200)  NOT NULL ,
  [CRON_EXPRESSION] [VARCHAR] (120)  NOT NULL ,
  [TIME_ZONE_ID] [VARCHAR] (80) 
) ON [PRIMARY]
;

CREATE TABLE [${SCHEMA}].[${TABLE_PREFIX}FIRED_TRIGGERS] (
  [SCHED_NAME] [VARCHAR] (120)  NOT NULL ,
  [ENTRY_ID] [VARCHAR] (95)  NOT NULL ,
  [TRIGGER_NAME] [VARCHAR] (200)  NOT NULL ,
  [TRIGGER_GROUP] [VARCHAR] (200)  NOT NULL ,
  [INSTANCE_NAME] [VARCHAR] (200)  NOT NULL ,
  [FIRED_TIME] [BIGINT] NOT NULL ,
  [PRIORITY] [INTEGER] NOT NULL ,
  [STATE] [VARCHAR] (16)  NOT NULL,
  [JOB_NAME] [VARCHAR] (200)  NULL ,
  [JOB_GROUP] [VARCHAR] (200)  NULL ,
  [IS_NONCONCURRENT] [VARCHAR] (1)  NULL ,
  [REQUESTS_RECOVERY] [VARCHAR] (1)  NULL 
) ON [PRIMARY]
;

CREATE TABLE [${SCHEMA}].[${TABLE_PREFIX}PAUSED_TRIGGER_GRPS] (
  [SCHED_NAME] [VARCHAR] (120)  NOT NULL ,
  [TRIGGER_GROUP] [VARCHAR] (200)  NOT NULL 
) ON [PRIMARY]
;

CREATE TABLE [${SCHEMA}].[${TABLE_PREFIX}SCHEDULER_STATE] (
  [SCHED_NAME] [VARCHAR] (120)  NOT NULL ,
  [INSTANCE_NAME] [VARCHAR] (200)  NOT NULL ,
  [LAST_CHECKIN_TIME] [BIGINT] NOT NULL ,
  [CHECKIN_INTERVAL] [BIGINT] NOT NULL
) ON [PRIMARY]
;

CREATE TABLE [${SCHEMA}].[${TABLE_PREFIX}LOCKS] (
  [SCHED_NAME] [VARCHAR] (120)  NOT NULL ,
  [LOCK_NAME] [VARCHAR] (40)  NOT NULL 
) ON [PRIMARY]
;

CREATE TABLE [${SCHEMA}].[${TABLE_PREFIX}JOB_DETAILS] (
  [SCHED_NAME] [VARCHAR] (120)  NOT NULL ,
  [JOB_NAME] [VARCHAR] (200)  NOT NULL ,
  [JOB_GROUP] [VARCHAR] (200)  NOT NULL ,
  [DESCRIPTION] [VARCHAR] (250) NULL ,
  [JOB_CLASS_NAME] [VARCHAR] (250)  NOT NULL ,
  [IS_DURABLE] [VARCHAR] (1)  NOT NULL ,
  [IS_NONCONCURRENT] [VARCHAR] (1)  NOT NULL ,
  [IS_UPDATE_DATA] [VARCHAR] (1)  NOT NULL ,
  [REQUESTS_RECOVERY] [VARCHAR] (1)  NOT NULL ,
  [JOB_DATA] [IMAGE] NULL
) ON [PRIMARY]
;

CREATE TABLE [${SCHEMA}].[${TABLE_PREFIX}SIMPLE_TRIGGERS] (
  [SCHED_NAME] [VARCHAR] (120)  NOT NULL ,
  [TRIGGER_NAME] [VARCHAR] (200)  NOT NULL ,
  [TRIGGER_GROUP] [VARCHAR] (200)  NOT NULL ,
  [REPEAT_COUNT] [BIGINT] NOT NULL ,
  [REPEAT_INTERVAL] [BIGINT] NOT NULL ,
  [TIMES_TRIGGERED] [BIGINT] NOT NULL
) ON [PRIMARY]
;

CREATE TABLE [${SCHEMA}].[${TABLE_PREFIX}SIMPROP_TRIGGERS] (
  [SCHED_NAME] [VARCHAR] (120)  NOT NULL ,
  [TRIGGER_NAME] [VARCHAR] (200)  NOT NULL ,
  [TRIGGER_GROUP] [VARCHAR] (200)  NOT NULL ,
  [STR_PROP_1] [VARCHAR] (512) NULL,
  [STR_PROP_2] [VARCHAR] (512) NULL,
  [STR_PROP_3] [VARCHAR] (512) NULL,
  [INT_PROP_1] [INT] NULL,
  [INT_PROP_2] [INT] NULL,
  [LONG_PROP_1] [BIGINT] NULL,
  [LONG_PROP_2] [BIGINT] NULL,
  [DEC_PROP_1] [NUMERIC] (13,4) NULL,
  [DEC_PROP_2] [NUMERIC] (13,4) NULL,
  [BOOL_PROP_1] [VARCHAR] (1) NULL,
  [BOOL_PROP_2] [VARCHAR] (1) NULL,
) ON [PRIMARY]
;

CREATE TABLE [${SCHEMA}].[${TABLE_PREFIX}BLOB_TRIGGERS] (
  [SCHED_NAME] [VARCHAR] (120)  NOT NULL ,
  [TRIGGER_NAME] [VARCHAR] (200)  NOT NULL ,
  [TRIGGER_GROUP] [VARCHAR] (200)  NOT NULL ,
  [BLOB_DATA] [IMAGE] NULL
) ON [PRIMARY]
;

CREATE TABLE [${SCHEMA}].[${TABLE_PREFIX}TRIGGERS] (
  [SCHED_NAME] [VARCHAR] (120)  NOT NULL ,
  [TRIGGER_NAME] [VARCHAR] (200)  NOT NULL ,
  [TRIGGER_GROUP] [VARCHAR] (200)  NOT NULL ,
  [JOB_NAME] [VARCHAR] (200)  NOT NULL ,
  [JOB_GROUP] [VARCHAR] (200)  NOT NULL ,
  [DESCRIPTION] [VARCHAR] (250) NULL ,
  [NEXT_FIRE_TIME] [BIGINT] NULL ,
  [PREV_FIRE_TIME] [BIGINT] NULL ,
  [PRIORITY] [INTEGER] NULL ,
  [TRIGGER_STATE] [VARCHAR] (16)  NOT NULL ,
  [TRIGGER_TYPE] [VARCHAR] (8)  NOT NULL ,
  [START_TIME] [BIGINT] NOT NULL ,
  [END_TIME] [BIGINT] NULL ,
  [CALENDAR_NAME] [VARCHAR] (200)  NULL ,
  [MISFIRE_INSTR] [SMALLINT] NULL ,
  [JOB_DATA] [IMAGE] NULL
) ON [PRIMARY]
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}CALENDARS] WITH NOCHECK ADD
  CONSTRAINT [PK_${TABLE_PREFIX}CALENDARS] PRIMARY KEY  CLUSTERED
  (
    [SCHED_NAME],
    [CALENDAR_NAME]
  )  ON [PRIMARY]
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}CRON_TRIGGERS] WITH NOCHECK ADD
  CONSTRAINT [PK_${TABLE_PREFIX}CRON_TRIGGERS] PRIMARY KEY  CLUSTERED
  (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
  )  ON [PRIMARY]
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}FIRED_TRIGGERS] WITH NOCHECK ADD
  CONSTRAINT [PK_${TABLE_PREFIX}FIRED_TRIGGERS] PRIMARY KEY  CLUSTERED
  (
    [SCHED_NAME],
    [ENTRY_ID]
  )  ON [PRIMARY]
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}PAUSED_TRIGGER_GRPS] WITH NOCHECK ADD
  CONSTRAINT [PK_${TABLE_PREFIX}PAUSED_TRIGGER_GRPS] PRIMARY KEY  CLUSTERED
  (
    [SCHED_NAME],
    [TRIGGER_GROUP]
  )  ON [PRIMARY]
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}SCHEDULER_STATE] WITH NOCHECK ADD
  CONSTRAINT [PK_${TABLE_PREFIX}SCHEDULER_STATE] PRIMARY KEY  CLUSTERED
  (
    [SCHED_NAME],
    [INSTANCE_NAME]
  )  ON [PRIMARY]
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}LOCKS] WITH NOCHECK ADD
  CONSTRAINT [PK_${TABLE_PREFIX}LOCKS] PRIMARY KEY  CLUSTERED
  (
    [SCHED_NAME],
    [LOCK_NAME]
  )  ON [PRIMARY]
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}JOB_DETAILS] WITH NOCHECK ADD
  CONSTRAINT [PK_${TABLE_PREFIX}JOB_DETAILS] PRIMARY KEY  CLUSTERED
  (
    [SCHED_NAME],
    [JOB_NAME],
    [JOB_GROUP]
  )  ON [PRIMARY]
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}SIMPLE_TRIGGERS] WITH NOCHECK ADD
  CONSTRAINT [PK_${TABLE_PREFIX}SIMPLE_TRIGGERS] PRIMARY KEY  CLUSTERED
  (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
  )  ON [PRIMARY]
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}SIMPROP_TRIGGERS] WITH NOCHECK ADD
  CONSTRAINT [PK_${TABLE_PREFIX}SIMPROP_TRIGGERS] PRIMARY KEY  CLUSTERED
  (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
  )  ON [PRIMARY]
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}TRIGGERS] WITH NOCHECK ADD
  CONSTRAINT [PK_${TABLE_PREFIX}TRIGGERS] PRIMARY KEY  CLUSTERED
  (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
  )  ON [PRIMARY]
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}CRON_TRIGGERS] ADD
  CONSTRAINT [FK_${TABLE_PREFIX}CRON_TRIGGERS_${TABLE_PREFIX}TRIGGERS] FOREIGN KEY
  (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
  ) REFERENCES [${SCHEMA}].[${TABLE_PREFIX}TRIGGERS] (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
  ) ON DELETE CASCADE
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}SIMPLE_TRIGGERS] ADD
  CONSTRAINT [FK_${TABLE_PREFIX}SIMPLE_TRIGGERS_${TABLE_PREFIX}TRIGGERS] FOREIGN KEY
  (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
  ) REFERENCES [${SCHEMA}].[${TABLE_PREFIX}TRIGGERS] (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
  ) ON DELETE CASCADE
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}SIMPROP_TRIGGERS] ADD
  CONSTRAINT [FK_${TABLE_PREFIX}SIMPROP_TRIGGERS_${TABLE_PREFIX}TRIGGERS] FOREIGN KEY
  (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
  ) REFERENCES [${SCHEMA}].[${TABLE_PREFIX}TRIGGERS] (
    [SCHED_NAME],
    [TRIGGER_NAME],
    [TRIGGER_GROUP]
  ) ON DELETE CASCADE
;

ALTER TABLE [${SCHEMA}].[${TABLE_PREFIX}TRIGGERS] ADD
  CONSTRAINT [FK_${TABLE_PREFIX}TRIGGERS_${TABLE_PREFIX}JOB_DETAILS] FOREIGN KEY
  (
    [SCHED_NAME],
    [JOB_NAME],
    [JOB_GROUP]
  ) REFERENCES [${SCHEMA}].[${TABLE_PREFIX}JOB_DETAILS] (
    [SCHED_NAME],
    [JOB_NAME],
    [JOB_GROUP]
  )
;
