object Form1: TForm1
  Left = 347
  Top = 174
  Caption = 'Form1'
  ClientHeight = 329
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 207
    Width = 33
    Height = 13
    Caption = 'Codigo'
  end
  object Label2: TLabel
    Left = 136
    Top = 207
    Width = 63
    Height = 13
    Caption = 'Raz'#227'o Social'
  end
  object Button1: TButton
    Left = 9
    Top = 283
    Width = 75
    Height = 25
    Caption = 'Find'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 321
    Top = 283
    Width = 75
    Height = 25
    Caption = 'Insert'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 401
    Top = 283
    Width = 75
    Height = 25
    Caption = 'Update'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 481
    Top = 283
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
    OnClick = Button4Click
  end
  object CODIGO: TEdit
    Left = 9
    Top = 223
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object RAZAO_SOCIAL: TEdit
    Left = 136
    Top = 223
    Width = 420
    Height = 21
    TabOrder = 5
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 548
    Height = 193
    DataSource = DataSource1
    TabOrder = 6
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object ZConnection1: TZConnection
    ControlsCodePage = cCP_UTF16
    Properties.Strings = (
      'RawStringEncoding=DB_CP'
      'controls_cp=CP_UTF16')
    AfterConnect = ZConnection1AfterConnect
    Port = 0
    Database = '..\database.sdb3'
    Protocol = 'sqlite'
    LibraryLocation = '..\sqlite3.dll'
    Left = 409
    Top = 65
  end
  object DataSource1: TDataSource
    Left = 408
    Top = 113
  end
end
