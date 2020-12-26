unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  ObjectSet4D, ObjectInterf4D, CLIENTE, ZConnection;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    CODIGO_CLI: TEdit;
    NOME_CLI: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ZConnection1: TZConnection;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FObjectSet: iObjectSet4D;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button4Click(Sender: TObject);
begin
  FObjectSet.Find;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FObjectSet := TObjectSet4D.New(ZConnection1, TypeInfo(TACLIENGE));
  //FObjectSet.PrimaryKey(['CODIGO_CLI', 'SEQUENCIA_CLI']);
  FObjectSet.DataSource(DataSource1);
  FObjectSet.BindForm(Self);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  FObjectSet.Insert;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  FObjectSet.Update('CODIGO_CLI = '+ QuotedStr(CODIGO_CLI.Text));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  FObjectSet.Delete('CODIGO_CLI = '+ QuotedStr(CODIGO_CLI.Text));
end;

end.

