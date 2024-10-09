unit client.core;

{$I mormot.defines.inc}

interface

uses
  SysUtils,
  Classes,
  TypInfo,
  mormot.core.interfaces,
  mormot.rest.core,
  mormot.rest.http.client,
  mormot.core.json,
  mormot.core.log,
  mormot.core.rtti,
  mormot.core.unicode,
  mormot.orm.core,
  mormot.soa.core,
  task.core;

type
  /// classe que encapsula as configura��es entre o server e o client
  TTaskClient = class
  private
    fClient: TRestHttpClient;
    fModel: TOrmModel;
    fService: ITaskService;
    function GetService: ITaskService;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    /// acesso ao servi�o (API)
    // - o link com o servidor s� ir� ocorrer na 1� chamada
    property Service: ITaskService read GetService;
  end;

var
  /// usu�rio em uso no sistema
  _User: TTaskUser;

implementation

{ TTaskClient }

function TTaskClient.GetService: ITaskService;
begin
  fClient.SetUser(StringToUtf8(_User.UserName), StringToUtf8(_User.Password));
  if fService = nil then
  begin
    fClient.ServiceDefine([ITaskService], __SIC);
    fClient.Services['TaskService'].Get(fService);
  end;
  result := fService;
end;

constructor TTaskClient.Create;
begin
  inherited Create;
  fModel := TOrmModel.Create([]); // obrigat�rio no mORMot
  fClient := TRestHttpClient.Create(__URI, __PORT, fModel);
end;

destructor TTaskClient.Destroy;
begin
  fService := nil;
  fClient.Free;
  fModel.Free;
  inherited Destroy;
end;

initialization
  RecordZero(@_User, TypeInfo(TTaskUser));

end.
