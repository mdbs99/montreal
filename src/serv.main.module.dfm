object MainModule: TMainModule
  OldCreateOrder = False
  Left = 446
  Top = 247
  Height = 294
  Width = 363
  object Conn: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;Initial Catalog=montreal;Data Source=V1;'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 157
    Top = 43
  end
  object ListQuery: TADOQuery
    Connection = Conn
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'username'
        DataType = ftString
        Size = 50
        Value = Null
      end
      item
        Name = 'status'
        DataType = ftString
        Size = 100
        Value = Null
      end
      item
        Name = 'concluido_desc'
        DataType = ftString
        Size = 100
        Value = Null
      end>
    SQL.Strings = (
      'declare @username varchar(50) = :username'
      'declare @status varchar(100) = :status'
      'declare @concluido_desc varchar(100) = :concluido_desc'
      ''
      'select'
      '  t.*'
      'from TbTask t'
      'inner join TbUser u'
      '  on u.uid = t.user_uid'
      ' and u.username = @username'
      'where 1=1'
      'and ('
      '  (@status = @concluido_desc and t.enddate is not null)'
      '  or'
      '  (@status <> @concluido_desc and t.enddate is null)'
      ')'
      'order by startdate')
    Left = 91
    Top = 99
  end
  object DelScript: TADOQuery
    Connection = Conn
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'uid'
        DataType = ftGuid
        NumericScale = 255
        Precision = 255
        Size = 16
        Value = Null
      end>
    SQL.Strings = (
      'delete from TbTask where uid = :uid')
    Left = 157
    Top = 99
  end
  object SaveScript: TADOQuery
    Connection = Conn
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'title'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 100
        Value = Null
      end
      item
        Name = 'priority'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = Null
      end
      item
        Name = 'description'
        Attributes = [paNullable, paLong]
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 2147483647
        Value = Null
      end
      item
        Name = 'startdate'
        DataType = ftDateTime
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end
      item
        Name = 'uid'
        DataType = ftGuid
        NumericScale = 255
        Precision = 255
        Size = 16
        Value = Null
      end>
    SQL.Strings = (
      'update TbTask set'
      '  title = :title'
      ' ,priority = :priority'
      ' ,description = :description'
      ' ,startdate = :startdate'
      'where 1=1'
      'and uid = :uid')
    Left = 224
    Top = 99
  end
  object InsertScript: TADOQuery
    Connection = Conn
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'uid'
        DataType = ftGuid
        NumericScale = 255
        Precision = 255
        Size = 16
        Value = Null
      end
      item
        Name = 'username'
        DataType = ftString
        NumericScale = 50
        Precision = 50
        Size = 16
        Value = Null
      end
      item
        Name = 'title'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 100
        Value = Null
      end>
    SQL.Strings = (
      'insert into TbTask ('
      '  uid, user_uid, title'
      ') values ('
      
        '  :uid, (select uid from TbUser where username = :username), :ti' +
        'tle'
      ')')
    Left = 91
    Top = 155
  end
  object DoneScript: TADOQuery
    Connection = Conn
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'uid'
        DataType = ftGuid
        NumericScale = 255
        Precision = 255
        Size = 16
        Value = Null
      end>
    SQL.Strings = (
      'update TbTask set'
      '  enddate = getdate()'
      'where 1=1'
      'and uid = :uid')
    Left = 157
    Top = 155
  end
  object StatisticsQuery: TADOQuery
    Connection = Conn
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'username'
        DataType = ftString
        Size = 50
        Value = Null
      end
      item
        Name = 'days_total'
        DataType = ftInteger
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'declare @username varchar(50) = :username'
      'declare @days_total int = :days_total'
      ''
      'declare @result table ('
      '  task_total int, task_completed_total int, priority_avg int'
      ')'
      ''
      'insert into @result values (0, 0, 0);'
      ''
      'update @result set '
      '  -- O n'#250'mero total de tarefas'
      '  task_total = ('
      '    select value = count(1)'
      '    from TbTask t'
      '    inner join TbUser u'
      '      on u.uid = t.user_uid'
      '     and u.username = @username'
      '  )'
      '  -- A m'#233'dia de prioridade das tarefas pendentes'
      ' ,priority_avg = ('
      '    select value = avg(priority)'
      '    from TbTask t'
      '    inner join TbUser u'
      '      on u.uid = t.user_uid'
      '     and u.username = @username'
      '    where t.enddate is null'
      '  )'
      '  -- A quantidade de tarefas conclu'#237'das nos '#250'ltimos @days_total'
      ' ,task_completed_total = ('
      '    select value = count(1)'
      '    from TbTask t'
      '    inner join TbUser u'
      '      on u.uid = t.user_uid'
      '     and u.username = @username'
      '    where t.enddate is not null'
      
        '      and t.enddate >= dateadd(day, -@days_total, cast(getdate()' +
        ' as date))'
      '  );'
      ''
      'select * from @result')
    Left = 224
    Top = 155
  end
  object LoginQuery: TADOQuery
    Connection = Conn
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'username'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 50
        Value = Null
      end
      item
        Name = 'password'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 100
        Value = Null
      end>
    SQL.Strings = (
      'select 1 '
      'from TbUser '
      'where 1=1'
      'and username = :username '
      'and password = :password')
    Left = 35
    Top = 99
  end
end
