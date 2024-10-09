-- previamente deverá existir o BD abaixo
use montreal

---------------------------------------------------------------------------------------------------
-- dados para testes
---------------------------------------------------------------------------------------------------
insert into TbUser (uid, username, password) values
  (newid(), 'joao', 'joao')
 ,(newid(), 'maria', 'maria')

declare @counter int = 1;
declare @startdate datetime;
declare @enddate datetime;

while @counter <= 50
begin
  -- data de início aleatória entre 2 semanas atrás e hoje
  set @startdate = dateadd(day, -14 + @counter, getdate());
  -- data de término de 7 dias atrás, apenas para alguns rgistros
  if @counter <= 10
  begin
    set @enddate = dateadd(day, -7, getdate());
  end
  else
  begin
    set @enddate = null;
  end
  insert into TbTask (
    uid, user_uid, title, description, startdate, enddate, priority
  ) values (
    newid()
   ,(select top 1 uid from TbUser order by newid())
   ,'Tarefa ' + cast(@counter as varchar)
   ,'Descrição da tarefa ' + cast(@counter as varchar)
   ,@startdate
   ,@enddate
   ,(1 + (@counter % 3))
  );
  set @counter = @counter + 1;
end;
