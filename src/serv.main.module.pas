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
  /// datamodule principal com a conexão do BD
  // - como o componente de conexão não é threadsafe,
  // a instância deve ser inicializada/finalizada em cada thread
  MainModule: TMainModule;

implementation

{$R *.dfm}

end.
