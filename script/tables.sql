-- previamente deverá existir o BD abaixo
use montreal

---------------------------------------------------------------------------------------------------
-- excluir todas as tabelas, se já existirem
---------------------------------------------------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TbTask]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table dbo.TbTask
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TbUser]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  drop table dbo.TbUser

---------------------------------------------------------------------------------------------------
-- criação de todas as tabelas
---------------------------------------------------------------------------------------------------
create table dbo.TbUser(
 uid uniqueidentifier not null
,username varchar(50) not null
,password varchar(100) not null
) on [primary]
alter table dbo.TbUser add constraint pk_TbUser primary key clustered (uid) with (statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [primary]
create unique nonclustered index ix_TbTask_1 on dbo.TbUser(uid, username, password) with(statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [primary]
--grant select,insert,update on TbUser to ...

create table dbo.TbTask(
 uid uniqueidentifier not null
,user_uid uniqueidentifier not null
,title varchar(100) not null
,description text null
,startdate datetime not null     -- quando foi criada
,enddate datetime null           -- quando foi concluída
,priority int not null
) on [primary]
alter table dbo.TbTask add constraint TbTask_user_uid foreign key (user_uid) references dbo.TbUser (uid)
alter table dbo.TbTask add constraint pk_TbTask primary key clustered (uid) with (statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [primary]
alter table dbo.TbTask add constraint df_TbTask_startdate default getdate() for startdate
alter table dbo.TbTask add constraint df_TbTask_priority default 1 for priority
alter table dbo.TbTask add constraint ck_TbTask_priority check (priority in (1, 2, 3))
create nonclustered index ix_TbTask_1 on dbo.TbTask(title) with(statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [primary]
create nonclustered index ix_TbTask_2 on dbo.TbTask(title, startdate, enddate) with(statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on) on [primary]
--grant select,insert,update on TbTask to ...
