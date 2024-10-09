program client;

{$I mormot.defines.inc}

uses
  {$I mormot.uses.inc} // use FastMM4 on older versions of Delphi
  Forms,
  client.main.form in 'client.main.form.pas' {MainForm},
  client.login.form in 'client.login.form.pas' {LoginForm},
  client.core in 'client.core.pas',
  task.core in 'task.core.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Montreal';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
