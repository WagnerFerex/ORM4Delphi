//{$M+}
//{$TYPEINFO ON}
{$M+}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ZAbstractConnection, ZConnection, DB,
  DBGrids, Grids,
  ACBrBase,
  ObjectSet4D,
  orm4d.model.cliente;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ZConnection1: TZConnection;
    DataSource1: TDataSource;
    Button3: TButton;
    Button4: TButton;
    CODIGO: TEdit;
    RAZAO_SOCIAL: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    DBGrid1: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ZConnection1AfterConnect(Sender: TObject);
  private
  	DAO: iObjectSet4D;
    ModelCliente : iModelCliente;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  CLIENTE, Contnrs;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
//  DAO := TObjectSet4D.New(ZConnection1, TypeInfo(TCLIENTE));
////  DAO.DefFieldsPK(['CODIGO_CLI']);
////  DAO.DefFieldsAutoInc(['CODIGO_CLI']);
////  DAO.DefFieldsIgnore(['CODIGO_CLI']);
//  DAO.DataSource(DataSource1);
//  DAO.BindForm(Self);

  ModelCliente := TModelCliente.New
    .DataSource(DataSource1)
    .BindForm(Self);
end;

procedure TForm1.ZConnection1AfterConnect(Sender: TObject);
begin
  ZConnection1.Protocol := 'sqlite';
  ZConnection1.LibraryLocation := 'sqlite3.dll';
  ZConnection1.Database := '..\DB\database.sdb3';
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  FList: TObjectList;
begin
//  FList := TObjectList.Create;
//  try
//    DAO.Find(FList);
//  finally
//    FreeAndNil(FList);
//  end;

  ModelCliente.DAO.Find();
  ModelCliente.Entidade.CODIGO := -1;
  ModelCliente.Entidade.RAZAO_SOCIAL := 'EMPRESA DE TESTE';
  //ModelCliente.DAO.Update();
end;

procedure TForm1.Button2Click(Sender: TObject);
var
	Entity: TCLIENTE;
begin
	Entity := TCLIENTE.Create;
  try
    Entity.CODIGO := 1;
    Entity.RAZAO_SOCIAL := 'WAGNER VASCONCELOS';
    DAO.Insert();
    DAO.Find;
  finally
    FreeAndNil(Entity);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
	Entity: TCLIENTE;
begin
	Entity := TCLIENTE.Create;
  try
    Entity.CODIGO := 06839;
    Entity.RAZAO_SOCIAL := 'WAGNER FEREX';
    DAO.Update(Entity, 'CODIGO = '+ IntToStr(Entity.CODIGO));
    DAO.Find;
  finally
    FreeAndNil(Entity);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
	DAO.Delete('CODIGO = '+ QuotedStr('06839'));
  DAO.Find;
end;

end.
