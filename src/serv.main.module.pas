unit serv.main.module;

interface

{$I mormot.defines.inc}

uses
  SysUtils,
  Classes,
  DB,
  ADODB;

type
  TMainModule = class(TDataModule)
    Conn: TADOConnection;
    ListQuery: TADOQuery;
    DelScript: TADOQuery;
    SaveScript: TADOQuery;
    InsertScript: TADOQuery;
    DoneScript: TADOQuery;
    StatisticsQuery: TADOQuery;
    LoginQuery: TADOQuery;
  end;

threadvar
  /// datamodule principal com a conex�o do BD
  // - como o componente de conex�o n�o � threadsafe,
  // a inst�ncia deve ser inicializada/finalizada em cada thread
  MainModule: TMainModule;

implementation

{$R *.dfm}

end.
