unit orm4d.model.cliente;

interface

uses
  DB,
  CLIENTE,
  Forms,
  ObjectSet4D;

type
  iModelDAO = interface
    ['{68F6A79F-1C86-4A13-BBDE-9BC491396E28}']
    function Find(): iModelDAO;
    function Insert : iModelDAO; overload;
    function Update : iModelDAO; overload;
    function Delete(AWhere: string): iModelDAO;
    function Insert(AInstance: TObject): iModelDAO; overload;
    function Update(AInstance: TObject): iModelDAO; overload;
  end;

  iModelCliente = interface
    ['{EB31B112-27F5-4F7A-BCCF-21883D89EE7A}']
    function DAO: iModelDAO;
    function DataSource(ADataSource: TDataSource): iModelCliente;
    function BindForm(AForm: TForm): iModelCliente;
    function Entidade: TCLIENTE;
  end;

  TModelCliente = class(TInterfacedObject, iModelCliente, iModelDAO)
  private
    FEntidade: TCLIENTE;
    FDataSource: TDataSource;
    FObjectSet: iObjectSet4D;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iModelCliente;
    function DAO: iModelDAO;
    function DataSource(ADataSource: TDataSource): iModelCliente;
    function BindForm(AForm: TForm): iModelCliente;
    function Entidade: TCLIENTE;
    function Find(): iModelDAO;
    function Insert : iModelDAO; overload;
    function Update : iModelDAO; overload;
    function Delete(AWhere: string): iModelDAO;
    function Insert(AInstance: TObject): iModelDAO; overload;
    function Update(AInstance: TObject): iModelDAO; overload;
  end;

implementation

uses
  Unit1, SysUtils;

{ TModelCliente }

function TModelCliente.BindForm(AForm: TForm): iModelCliente;
begin
  Result := Self;
  FObjectSet.BindForm(Aform);
end;

constructor TModelCliente.Create;
begin
  FEntidade := TCLIENTE.Create;
  FObjectSet := TObjectSet4D.New(Form1.ZConnection1, TCLIENTE);
end;

function TModelCliente.DAO: iModelDAO;
begin
  Result := Self;
end;

function TModelCliente.DataSource(ADataSource: TDataSource): iModelCliente;
begin
  Result := Self;
  FDataSource := ADataSource;
  FObjectSet.DataSource(ADataSource);
end;

function TModelCliente.Delete(AWhere: string): iModelDAO;
begin
  Result := Self;
  FObjectSet.Delete(AWhere);
end;

destructor TModelCliente.Destroy;
begin
  Entidade.Free;
  inherited;
end;

function TModelCliente.Entidade: TCLIENTE;
begin
  Result := FEntidade;
end;

function TModelCliente.Find: iModelDAO;
begin
  Result := Self;
  FObjectSet.Find;
end;

function TModelCliente.Insert: iModelDAO;
begin
  Result := Self;
  FObjectSet.Insert(FEntidade);
end;

function TModelCliente.Insert(AInstance: TObject): iModelDAO;
begin
  Result := Self;
  FObjectSet.Insert(AInstance);
end;

class function TModelCliente.New: iModelCliente;
begin
  Result := Self.Create;
end;

function TModelCliente.Update(AInstance: TObject): iModelDAO;
begin
  Result := Self;
  FObjectSet.Update(AInstance, 'CODIGO = '+ IntToStr(TCLIENTE(AInstance).CODIGO));
end;

function TModelCliente.Update: iModelDAO;
begin
  Result := Self;
  FObjectSet.Update(FEntidade, 'CODIGO = '+ IntToStr(FEntidade.CODIGO));
end;

end.
