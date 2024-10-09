object LoginForm: TLoginForm
  Left = 424
  Top = 274
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 149
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 28
    Width = 36
    Height = 13
    Caption = 'Usu'#225'rio'
  end
  object Label2: TLabel
    Left = 37
    Top = 60
    Width = 31
    Height = 13
    Caption = 'Senha'
  end
  object Panel1: TPanel
    Left = 0
    Top = 108
    Width = 274
    Height = 41
    Align = alBottom
    TabOrder = 0
    object OkButton: TBitBtn
      Left = 112
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = OkButtonClick
    end
    object CancelButton: TBitBtn
      Left = 192
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object UserNameEdit: TEdit
    Left = 80
    Top = 24
    Width = 137
    Height = 21
    TabOrder = 1
  end
  object PasswordEdit: TEdit
    Left = 80
    Top = 56
    Width = 137
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
end
