unit client.login.form;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  ExtCtrls,
  client.core;

type
  TLoginForm = class(TForm)
    Panel1: TPanel;
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    UserNameEdit: TEdit;
    PasswordEdit: TEdit;
    procedure OkButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fTaskClient: TTaskClient;
  public
    constructor Create(aOwner: TComponent; aTaskClient: TTaskClient); reintroduce;
  end;

implementation

{$R *.dfm}

constructor TLoginForm.Create(aOwner: TComponent; aTaskClient: TTaskClient);
begin
  inherited Create(aOwner);
  fTaskClient := aTaskClient;
end;

procedure TLoginForm.OkButtonClick(Sender: TObject);
begin
  if Trim(UserNameEdit.Text) = '' then
  begin
    MessageDlg('Digite o usuário', mtWarning, [mbOk], 0);
    UserNameEdit.SetFocus;
    Exit;
  end;
  if Trim(PasswordEdit.Text) = '' then
  begin
    MessageDlg('Digite a senha ', mtWarning, [mbOk], 0);
    PasswordEdit.SetFocus;
    Exit;
  end;
  try
    _User.UserName := UserNameEdit.Text;
    _User.Password := PasswordEdit.Text;
    if fTaskClient.Service.Login(_User) then
    begin
      _User.Logged := True;
      ModalResult := mrOK;
    end
    else
      MessageDlg('Usuário ou senha inválidos.', mtError, [mbOk], 0);
  except
    on e: Exception do
      MessageDlg('Erro no servidor.', mtError, [mbOk], 0);
  end;
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin
  UserNameEdit.SetFocus;
end;

end.
