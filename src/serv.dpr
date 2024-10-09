program serv;

{$apptype console}
{$I mormot.defines.inc}

uses
  {$I mormot.uses.inc} // use FastMM4 on older versions of Delphi
  SysUtils,
  mormot.core.base,
  mormot.core.os,
  mormot.core.log,
  mormot.rest.core,
  mormot.rest.server,
  mormot.rest.http.server,
  mormot.soa.core,
  task.core in 'task.core.pas',
  serv.core in 'serv.core.pas',
  serv.main.module in 'serv.main.module.pas' {MainModule: TDataModule};

var
  vServer: TTaskServer;
  vHttpServer: TRestHttpServer;
begin
  with TSynLog.Family do
  begin
    Level := LOG_VERBOSE;
    PerThreadLog := ptMergedInOneFile;
    EchoToConsole := LOG_VERBOSE;
  end;
  vServer := TTaskServer.Create('root');
  try
    //vServer.AuthenticationRegister(TRestServerAuthenticationDefault);
    vHttpServer := TRestHttpServer.Create(
      __PORT, [vServer], '+', useHttpApiRegisteringURI, 3 {threads});
    try
      Writeln('Server running on port ' + __PORT);
      Readln;
    finally
      vHttpServer.Free;
    end;
  finally
    vServer.Free;
  end;
end.

