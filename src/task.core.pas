unit task.core;

interface

{$I mormot.defines.inc}

uses
  SysUtils,
  Classes,
  mormot.core.base,
  mormot.core.interfaces,
  mormot.soa.core;

const
  /// constantes compartilhas entre client e server
  __URI = 'localhost';
  __PORT = '8888';
  __SIC = sicShared;

type
  /// dados do usuário
  TTaskUser = record
    UserName: string;
    Password: string;
    Logged: Boolean;
  end;
  
  /// tipos de status de uma tarefa
  TTaskStatus = (
    tsPendente,
    tsConcluida
  );

  TTaskStatusSet = set of TTaskStatus;

  /// objeto adaptador para TTaskStatus
  // - internamente o sistema trabalha com enums
  // mas tem conversões para exibir uma string mais amigável
  // para o usuário
  {$ifdef USERECORDWITHMETHODS}
  TTaskStatusAdapter = packed record
  {$else}
  TTaskStatusAdapter = packed object
  {$endif USERECORDWITHMETHODS}
  public
    /// converte enum em descrição(caption)
    function EnumToDescricao(const aValue: TTaskStatus): string;
    /// converte descrição(caption) em enum
    function DescricaoToEnum(const aValue: string): TTaskStatus;
    /// converte descrição(ões) em strings
    // - aDest deve ser uma instância válida ou ocorrerá uma AV
    // - utilize aCustom para customizar valores - default: todos
    procedure DescricaoToStrings(aDest: TStrings;
      const aCustom: TTaskStatusSet = [low(TTaskStatus)..high(TTaskStatus)]);
  end;

  /// interface do serviço de tarefas
  ITaskService = interface(IInvokable)
  ['{68BA71A9-46F4-4F48-828B-7D50DB00486C}']
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

var
  _TaskStatusAdapter: TTaskStatusAdapter;

implementation

{ TTaskStatusAdapter }

const
  _TASK_STATUS: array[TTaskStatus] of string = (
    'PENDENTE', 'CONCLUÍDA'
  );

function TTaskStatusAdapter.EnumToDescricao(
  const aValue: TTaskStatus): string;
begin
  result := _TASK_STATUS[aValue];
end;

function TTaskStatusAdapter.DescricaoToEnum(
  const aValue: string): TTaskStatus;
var
  v: TTaskStatus;
begin
  result := low(TTaskStatus);
  for v := low(TTaskStatus) to high(TTaskStatus) do
    if _TASK_STATUS[v] = aValue then
    begin
      result := v;
      exit;
    end;
end;

procedure TTaskStatusAdapter.DescricaoToStrings(aDest: TStrings;
  const aCustom: TTaskStatusSet);
var
  v: TTaskStatus;
begin
  if not Assigned(aDest) then
    exit;
  aDest.Clear;
  for v := low(TTaskStatus) to high(TTaskStatus) do
    if v in aCustom then
      aDest.Append(_TASK_STATUS[v]);
end;

initialization
  TInterfaceFactory.RegisterInterfaces([TypeInfo(ITaskService)]);
  
end.
