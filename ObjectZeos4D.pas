unit ObjectZeos4D;

interface

uses
	DB, Classes, ObjectInterf4D,  {ZAbstractConnection,} ZConnection,
  ZAbstractRODataset, ZAbstractDataset, ZAbstractTable, ZDataset;

type
  TObjectZeos4D = class(TInterfacedObject, iDataSet4D)
  private
    FConnection : TZConnection;
    FQuery : TZQuery;
    FParams : TParams;
  public
    constructor Create(AConnection: TZConnection);
    destructor Destroy; override;
    class function New(AConnection: TZConnection): iDataSet4D; overload;
    class function New(AConnection: TComponent): iDataSet4D; overload;
    function SQL : TStrings;
    function Params : TParams;
    function ExecSQL : iDataSet4D;
    function DataSet : TDataSet;
    function Open(aSQL : String) : iDataSet4D; overload;
    function Open : iDataSet4D; overload;
  end;

implementation

uses
	SysUtils;

{ TObjectZeos4D }

constructor TObjectZeos4D.Create(AConnection: TZConnection);
begin
  FQuery := TZQuery.Create(nil);
  FConnection := AConnection;
  FQuery.Connection := FConnection;
end;

function TObjectZeos4D.DataSet: TDataSet;
begin
  Result := TDataSet(FQuery);
end;

destructor TObjectZeos4D.Destroy;
begin
  FreeAndNil(FQuery);

  if Assigned(FParams) then
    FreeAndNil(FParams);
  inherited;
end;

function TObjectZeos4D.ExecSQL: iDataSet4D;
begin
  Result := Self;
  if Assigned(FParams) then
  	FQuery.Params.Assign(FParams);
  FQuery.Prepare;
  FQuery.ExecSQL;

  if Assigned(FParams) then
    FreeAndNil(FParams);
end;

class function TObjectZeos4D.New(AConnection: TComponent): iDataSet4D;
begin
  if not (AConnection is TZConnection) then
    raise Exception.Create('Conexão informada deverá ser zConnection');

  Result := Self.Create(AConnection as TZConnection);
end;

class function TObjectZeos4D.New(AConnection: TZConnection): iDataSet4D;
begin
  Result := Self.Create(AConnection);
end;

function TObjectZeos4D.Open(aSQL: String): iDataSet4D;
begin
  Result := Self;
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(aSQL);
  FQuery.Open;
end;

function TObjectZeos4D.Open: iDataSet4D;
begin
  Result := Self;
  FQuery.Close;

  if Assigned(FParams) then
    FQuery.Params.Assign(FParams);

  FQuery.Prepare;
  FQuery.Open;

  if Assigned(FParams) then
    FreeAndNil(FParams);
end;

function TObjectZeos4D.Params: TParams;
begin
  if not Assigned(FParams) then
  begin
    FParams := TParams.Create(nil);
    FParams.Assign(FQuery.Params);
  end;
  Result := FParams;
end;

function TObjectZeos4D.SQL: TStrings;
begin
  Result := FQuery.SQL;
end;

end.
