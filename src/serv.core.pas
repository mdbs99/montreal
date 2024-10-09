unit serv.core;

interface

{$I mormot.defines.inc}

uses
  SysUtils,
  Classes,
  mormot.core.base,
  mormot.core.data,
  mormot.core.unicode,
  mormot.core.os,
  mormot.core.text,
  mormot.core.variants,
  mormot.core.json,
  mormot.orm.core,
  mormot.orm.rest,
  mormot.rest.core,
  mormot.rest.server,
  mormot.rest.memserver,
  mormot.soa.core,
  mormot.soa.server,
  mormot.db.rad.ui,
  task.core;

type
  /// implementação da ITaskService
  TTaskService = class(TInjectableObjectRest, ITaskService)
  protected
    procedure RaiseErroIfNotLogged(const aUser: TTaskUser);
  public
    function Ping: Boolean;
    function Login(const aUser: TTaskUser): Boolean;
    function SelectAll(const aUser: TTaskUser; const aStatus: TTaskStatus): RawUtf8;
    procedure Insert(const aUser: TTaskUser; const aUid, aTitle: string);
    procedure Delete(const aUser: TTaskUser; const aUid: string);
    procedure Save(const aUser: TTaskUser; const aUid, aTitle, aDescription: string;
      aPriority: Integer; aStartDate: TDateTime);
    procedure Done(const aUser: TTaskUser; const aUid: string);
    function Statistics(const aUser: TTaskUser): RawUtf8;
  end;

  TTaskServer = class(TRestServerFullMemory)
  protected
    procedure OnBeginCurrentThread(Sender: TThread); override;
    procedure OnEndCurrentThread(Sender: TThread); override;
  public
    constructor Create(const aRoot: RawUtf8); reintroduce; overload;
  end;

implementation

uses
  serv.main.module;

{ TTaskService }

procedure TTaskService.RaiseErroIfNotLogged(const aUser: TTaskUser);
begin
  if not aUser.Logged then
    raise Exception.Create('Não autorizado.');
end;

function TTaskService.Ping: Boolean;
begin
  result := True;
end;

function TTaskService.Login(const aUser: TTaskUser): Boolean;
begin
  with MainModule do
  begin
    LoginQuery.Close;
    LoginQuery.Parameters.ParamByName('username').Value := aUser.UserName;
    LoginQuery.Parameters.ParamByName('password').Value := aUser.Password;
    LoginQuery.Open;
    result := not LoginQuery.IsEmpty;
    LoginQuery.Close;
  end;
end;

function TTaskService.SelectAll(const aUser: TTaskUser; const aStatus: TTaskStatus): RawUtf8;
begin
  RaiseErroIfNotLogged(aUser);
  with MainModule do
  begin
    ListQuery.Close;
    ListQuery.Parameters.ParamByName('username').Value := aUser.UserName;
    ListQuery.Parameters.ParamByName('concluido_desc').Value :=
      _TaskStatusAdapter.EnumToDescricao(tsConcluida);
    ListQuery.Parameters.ParamByName('status').Value :=
      _TaskStatusAdapter.EnumToDescricao(aStatus);
    ListQuery.Open;
    result := DataSetToJson(ListQuery);
    ListQuery.Close;
  end;
end;

procedure TTaskService.Insert(const aUser: TTaskUser; const aUid, aTitle: string);
begin
  RaiseErroIfNotLogged(aUser);
  with MainModule do
  begin
    InsertScript.Parameters.ParamByName('uid').Value := aUid;
    InsertScript.Parameters.ParamByName('username').Value := aUser.UserName;
    InsertScript.Parameters.ParamByName('title').Value := aTitle;
    InsertScript.ExecSQL;
  end;
end;

procedure TTaskService.Delete(const aUser: TTaskUser; const aUid: string);
begin
  RaiseErroIfNotLogged(aUser);
  with MainModule do
  begin
    DelScript.Parameters.ParamByName('uid').Value := aUid;
    DelScript.ExecSQL;
  end;
end;

procedure TTaskService.Save(const aUser: TTaskUser;
  const aUid, aTitle, aDescription: string;
  aPriority: Integer; aStartDate: TDateTime);
begin
  RaiseErroIfNotLogged(aUser);
  with MainModule do
  begin
    SaveScript.Parameters.ParamByName('uid').Value := aUid;
    SaveScript.Parameters.ParamByName('title').Value := aTitle;
    SaveScript.Parameters.ParamByName('priority').Value := aPriority;
    SaveScript.Parameters.ParamByName('description').Value := aDescription;
    SaveScript.Parameters.ParamByName('startdate').Value := aStartDate;
    SaveScript.ExecSQL;
  end;
end;

procedure TTaskService.Done(const aUser: TTaskUser; const aUid: string);
begin
  RaiseErroIfNotLogged(aUser);
  with MainModule do
  begin
    DoneScript.Parameters.ParamByName('uid').Value := aUid;
    DoneScript.ExecSQL;
  end;
end;

function TTaskService.Statistics(const aUser: TTaskUser): RawUtf8;
begin
  RaiseErroIfNotLogged(aUser);
  with MainModule do
  begin
    StatisticsQuery.Close;
    StatisticsQuery.Parameters.ParamByName('username').Value := aUser.UserName;
    StatisticsQuery.Parameters.ParamByName('days_total').Value := 7;
    StatisticsQuery.Open;
    result := DataSetToJson(StatisticsQuery);
    StatisticsQuery.Close;
  end;
end;

{ TTaskServer }

procedure TTaskServer.OnBeginCurrentThread(Sender: TThread);
begin
  inherited OnBeginCurrentThread(Sender);
  // necessário para ADO
  CoInit;
  // uma instância por thread
  MainModule := TMainModule.Create(nil);
  MainModule.Conn.Open;
end;

procedure TTaskServer.OnEndCurrentThread(Sender: TThread);
begin
  MainModule.Conn.Close;
  FreeAndNil(MainModule);
  CoUninit;
  inherited OnEndCurrentThread(Sender);
end;

constructor TTaskServer.Create(const aRoot: RawUtf8);
begin
  inherited Create(aRoot);
  ServiceDefine(TTaskService, [ITaskService], __SIC);
end;

end.
