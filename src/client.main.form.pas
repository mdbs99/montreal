unit client.main.form;

{$I mormot.defines.inc}

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
  ComCtrls,
  ExtCtrls,
  StdCtrls,
  ToolWin,
  ImgList,
  DateUtils,
  Spin,
  mormot.core.base,
  mormot.core.variants,
  mormot.core.datetime,
  task.core,
  client.core,
  client.login.form;

type
  TMainForm = class(TForm)
    StatusBar: TStatusBar;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    TaskListView: TListView;
    Label1: TLabel;
    QtdeLabel: TLabel;
    Panel4: TPanel;
    DescriptionMemo: TMemo;
    ToolBar2: TToolBar;
    SaveButton: TToolButton;
    ToolBar1: TToolBar;
    NewButton: TToolButton;
    DelButton: TToolButton;
    ToolButton4: TToolButton;
    ConcludeButton: TToolButton;
    Panel3: TPanel;
    StatusCombo: TComboBox;
    ImageList1: TImageList;
    LoginButton: TToolButton;
    ToolButton9: TToolButton;
    Panel5: TPanel;
    Label2: TLabel;
    TitleEdit: TEdit;
    StartDateDate: TDateTimePicker;
    Label3: TLabel;
    LoginTimer: TTimer;
    ToolButton1: TToolButton;
    RevertButton: TToolButton;
    RefreshButton: TToolButton;
    ToolButton3: TToolButton;
    Label5: TLabel;
    PriorityEdit: TSpinEdit;
    StatisticsButton: TToolButton;
    ToolButton5: TToolButton;
    procedure LoginTimerTimer(Sender: TObject);
    procedure LoginButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TaskListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure TaskListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure DelButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure RevertButtonClick(Sender: TObject);
    procedure RefreshButtonClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure ConcludeButtonClick(Sender: TObject);
    procedure StatusComboChange(Sender: TObject);
    procedure StatisticsButtonClick(Sender: TObject);
  private
    fTaskClient: TTaskClient;
    fDocList: IDocList;
    procedure Login;
    procedure FillList;
    procedure FillEditItem(aIndex: Integer);
    procedure EnableListActions(aValue: Boolean);
    procedure EnableEditActions(aValue: Boolean);
    procedure ClearEditWidgets;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

function NewUid: string;
var
  vGuid: TGuid;
begin
  CreateGUID(vGuid);
  result := GUIDToString(vGuid);
end;

procedure TMainForm.Login;
var
  vLogin: TLoginForm;
  vText: string;
begin
  vLogin := TLoginForm.Create(self, fTaskClient);
  try
    vLogin.ShowModal;
    if _User.Logged then
    begin
      vText := 'Usuário: ' + _User.UserName;
      RefreshButton.Click;
    end
    else
      vText := '';
    StatusBar.Panels[0].Text := vText;
  finally
    vLogin.Free;
  end;
end;

procedure TMainForm.LoginTimerTimer(Sender: TObject);
begin
  LoginTimer.Enabled := False;
  Login;
end;

procedure TMainForm.LoginButtonClick(Sender: TObject);
begin
  Login;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fTaskClient := TTaskClient.Create;
  _TaskStatusAdapter.DescricaoToStrings(StatusCombo.Items);
  StatusCombo.ItemIndex := 0;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  fTaskClient.Free;
end;

procedure TMainForm.FillList;
var
  v: Integer;
  vListItem: TListItem;
  vDocDict: IDocDict;
begin
  TaskListView.Items.Clear;
  fDocList := DocList(
    fTaskClient.Service.SelectAll(
      _User, _TaskStatusAdapter.DescricaoToEnum(StatusCombo.Text)
    )
  );
  for v := 0 to fDocList.Len-1 do
  begin
    vDocDict := fDocList.D[v];
    vListItem := TaskListView.Items.Add;
    vListItem.Caption := vDocDict.S['title'];
    vListItem.SubItems.Add(vDocDict.S['priority']);
  end;
  QtdeLabel.Caption := IntToStr(fDocList.Len);
  EnableListActions(fDocList.Len > 0);
  ClearEditWidgets;
end;

procedure TMainForm.FillEditItem(aIndex: Integer);
begin
  with fDocList.D[aIndex] do
  begin
    TitleEdit.Text := S['title'];
    PriorityEdit.Text := S['priority'];
    StartDateDate.DateTime := Iso8601ToDateTime(S['startdate']);
    DescriptionMemo.Text := S['description'];
  end;
end;

procedure TMainForm.EnableListActions(aValue: Boolean);
begin
  DelButton.Enabled := aValue;
  ConcludeButton.Enabled := aValue and
    (_TaskStatusAdapter.DescricaoToEnum(StatusCombo.Text) <> tsConcluida);
  StatisticsButton.Enabled := aValue;
end;

procedure TMainForm.EnableEditActions(aValue: Boolean);
begin
  SaveButton.Enabled := aValue;
  RevertButton.Enabled := aValue;
end;

procedure TMainForm.ClearEditWidgets;
begin
  TitleEdit.Clear;
  StartDateDate.DateTime := EncodeDate(1900, 1, 1);
  DescriptionMemo.Clear;
end;

procedure TMainForm.TaskListViewEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

procedure TMainForm.TaskListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  EnableEditActions(Selected);
  if Selected then
    FillEditItem(Item.Index);
end;

procedure TMainForm.DelButtonClick(Sender: TObject);
var
  vListItem: TListItem;
begin
  vListItem := TaskListView.Selected;
  with fDocList.D[vListItem.Index] do
  begin
    if MessageDlg(Format('Excluir "%s"?', [S['title']]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      // exclui o item no servidor
      fTaskClient.Service.Delete(_User, S['uid']);
      // atualiza os dados locais
      fDocList.Del(vListItem.Index);
      // atualiza na tela
      vListItem.Delete;
      QtdeLabel.Caption := IntToStr(fDocList.Len);
      ClearEditWidgets;
    end;
  end;
end;

procedure TMainForm.SaveButtonClick(Sender: TObject);
var
  vListItem: TListItem;
begin
  if Trim(TitleEdit.Text) = '' then
  begin
    MessageDlg('Digite um Título', mtWarning, [mbOk], 0);
    TitleEdit.SetFocus;
    Exit;
  end;
  if PriorityEdit.Value > PriorityEdit.MaxValue then
  begin
    MessageDlg(
      Format('Prioridade de estar entre %d e %d', [PriorityEdit.MinValue, PriorityEdit.MaxValue]),
      mtWarning, [mbOk], 0);
    PriorityEdit.SetFocus;
    Exit;
  end;
  vListItem := TaskListView.Selected;
  with fDocList.D[vListItem.Index] do
  begin
    // atualiza no servidor
    fTaskClient.Service.Save(
      _User,
      S['uid'], TitleEdit.Text, DescriptionMemo.Text,
      PriorityEdit.Value, StartDateDate.DateTime);
    // atualiza os dados locais
    S['title'] := TitleEdit.Text;
    S['priority'] := PriorityEdit.Text;
    S['startdate'] := DateTimeToIso8601(StartDateDate.DateTime, True);
    S['description'] := DescriptionMemo.Text;
    // atualiza na tela
    vListItem.Caption := TitleEdit.Text;
    vListItem.SubItems.Text := PriorityEdit.Text;
  end;
end;

procedure TMainForm.RevertButtonClick(Sender: TObject);
begin
  FillEditItem(TaskListView.Selected.Index);
end;

procedure TMainForm.RefreshButtonClick(Sender: TObject);
begin
  RefreshButton.Enabled := True;
  NewButton.Enabled := True;
  FillList;
end;

procedure TMainForm.NewButtonClick(Sender: TObject);
var
  vTitle: string;
  vListItem: TListItem;
  vDocDict: IDocDict;
  vUid: string;
begin
  if InputQuery('Nova tarefa', 'Digite um título:', vTitle) then
  begin
    vUid := NewUid;
    // atualiza no servidor
    fTaskClient.Service.Insert(_User, vUid, vTitle);
    // atualiza os dados locais
    vDocDict := DocDict([
      'uid', vUid, 'title', vTitle, 'priority', 1, 'startdate', DateTimeToIso8601(Now, True)]);
    fDocList.AppendDoc(vDocDict);
    // atualiza na tela
    vListItem := TaskListView.Items.Add;
    vListItem.Caption := vDocDict.S['title'];
    vListItem.SubItems.Add(vDocDict.S['priority']);
    QtdeLabel.Caption := IntToStr(fDocList.Len);
    // seleciona o último item incluído
    with TaskListView.Items[TaskListView.Items.Count-1] do
    begin
      Selected := True;
      // garante que o item seja visível
      MakeVisible(True);
    end;
    // focus na descrição para o usuário começar a digitar
    DescriptionMemo.SetFocus;
  end;
end;

procedure TMainForm.ConcludeButtonClick(Sender: TObject);
var
  vListItem: TListItem;
begin
  vListItem := TaskListView.Selected;
  with fDocList.D[vListItem.Index] do
  begin
    if MessageDlg(Format('Concluir "%s"?', [S['title']]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      // atualiza o item no servidor
      fTaskClient.Service.Done(_User, S['uid']);
      // atualiza na tela
      FillList;
    end;
  end;
end;

procedure TMainForm.StatusComboChange(Sender: TObject);
begin
  FillList;
end;

procedure TMainForm.StatisticsButtonClick(Sender: TObject);
var
  vDocList: IDocList;
  vDocDict: IDocDict;
  vMsg: string;
begin
  if fDocList.Len > 0 then
  begin
    vDocList := DocList(fTaskClient.Service.Statistics(_User));
    vDocDict := vDocList.D[0];
    vMsg := 'O número total de tarefas: ' + vDocDict.S['task_total'] + #13
          + 'A média das tarefas pendentes: Prioridade ' + vDocDict.S['priority_avg'] + #13
          + 'A quantidade de tarefas concluídas nos últimos 7 dias: ' + vDocDict.S['task_completed_total'] + #13          ;    vDocDict.S['title'];
    MessageDlg(vMsg, mtInformation, [mbOk], 0);
  end
  else
    MessageDlg('Não há dados para exibir as estatísticas.', mtWarning, [mbOk], 0);
end;

end.
