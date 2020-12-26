unit ObjectSet4D;

interface

uses
	DB,
  TypInfo,
  Classes,
  Contnrs,
  Forms,
  ObjectInterf4D,
  ObjectSQL4D,
  ObjectRTTI4D,
  ObjectZeos4D;

type
  iObjectSet4D = interface
  	['{5B642A48-FD6A-42E7-81A4-AA2699BCC1C8}']
    function Find(var aList : TObjectList) : iObjectSet4D; overload;
    function Find : iObjectSet4D; overload;
    function Insert(aValue : TObject) : iObjectSet4D; overload;
    function Update(aValue : TObject; AWhere: string): iObjectSet4D; overload;
    function Delete(AWhere: string) : iObjectSet4D;
    function DataSet : TDataSet;
    function DataSource(ADataSource: TDataSource): iObjectSet4D;
    function _This: TObject;
    function BindForm(aForm : TForm): iObjectSet4D;
    function Insert: iObjectSet4D; overload;
    function Update(AWhere: string) : iObjectSet4D; overload;
//    function Delete : iObjectSet4D; overload;
//		function SQL : iSimpleDAOSQLAttribute<T>;
  end;

  TObjectSet4D = class(TInterfacedObject, iObjectSet4D)
  private
    FQuery : iDataSet4D;
    FTypeInfo : PTypeInfo;
    FEntity: TObject;
    FDataSource: TDataSource;
    FForm : TForm;
    procedure OnDataChange(Sender: TObject; Field: TField);
  public
    constructor Create(aConn : TComponent; AClass: TClass);
    destructor Destroy; override;
    class function New(aConn : TComponent; AClass: TClass) : iObjectSet4D;
    function Insert(aValue : TObject) : iObjectSet4D; overload;
    function Update(aValue : TObject; AWhere: string) : iObjectSet4D; overload;
    function Delete(AWhere: string) : iObjectSet4D;
    function DataSet : TDataSet;
    function DataSource(ADataSource: TDataSource): iObjectSet4D;
    function Find(var aList : TObjectList) : iObjectSet4D; overload;
    function Find : iObjectSet4D; overload;
    function _This: TObject;
    function BindForm(aForm : TForm): iObjectSet4D;
    function Insert: iObjectSet4D; overload;
    function Update(AWhere: string) : iObjectSet4D; overload;
//    function Delete : iObjectSet4D; overload;
  end;

implementation

uses
	SysUtils;

{ TORMPersistent }

constructor TObjectSet4D.Create(aConn : TComponent; AClass: TClass);
begin
  FQuery := TObjectZeos4D.New(aConn);
  FTypeInfo := AClass.ClassInfo;
  FEntity := GetTypeData(FTypeInfo)^.ClassType.Create;
end;

function TObjectSet4D.DataSet: TDataSet;
begin
	Result := FQuery.DataSet;
end;

function TObjectSet4D.Find(var aList: TObjectList): iObjectSet4D;
var
  aSQL : String;
begin
  Result := Self;

  TObjectSQL4D
    .New(FTypeInfo)
//    .Fields(FSQLAttribute.Fields)
//    .Join(FSQLAttribute.Join)
//    .Where(FSQLAttribute.Where)
//    .OrderBy(FSQLAttribute.OrderBy)
    .Select(aSQL);

  FQuery.DataSet.DisableControls;
  FQuery.Open(aSQL);

  TObjectRTTI4D.New(FTypeInfo).DataSetToEntityList(FQuery.DataSet, AList);

//  FSQLAttribute.Clear;
  FQuery.DataSet.EnableControls;
end;

destructor TObjectSet4D.Destroy;
begin
  FreeAndNil(FEntity);
  inherited;
end;

function TObjectSet4D.Find : iObjectSet4D;
var
  aSQL : String;
begin
  Result := Self;

  TObjectSQL4D
    .New(FTypeInfo)
////    .Fields(FSQLAttribute.Fields)
////    .Join(FSQLAttribute.Join)
////    .Where(FSQLAttribute.Where)
////    .OrderBy(FSQLAttribute.OrderBy)
    .Select(aSQL);

  FQuery.DataSet.DisableControls;
  FQuery.Open(aSQL);

//  if ABindList then
//    TSimpleRTTI<T>.New(nil).DataSetToEntityList(FQuery.DataSet, FList);

//  FSQLAttribute.Clear;
  FQuery.DataSet.EnableControls;
end;

function TObjectSet4D.Insert: iObjectSet4D;
var
  LSQL : String;
  LEntity: TObject;
begin
  Result := Self;
  LEntity := GetTypeData(FTypeInfo)^.ClassType.Create;
  try
    TObjectSQL4D.New(FTypeInfo).Insert(LSQL);
    FQuery.SQL.Clear;
    FQuery.SQL.Add(LSQL);
    TObjectRTTI4D.New(FTypeInfo)
      .BindFormToClass(FForm, LEntity)
      .ListFields(LEntity, FQuery.Params);
    FQuery.ExecSQL;
  finally
    FreeAndNil(LEntity);
  end;
end;

function TObjectSet4D.Insert(aValue: TObject): iObjectSet4D;
var
  aSQL : String;
begin
  Result := Self;
  TObjectSQL4D.New(FTypeInfo).Insert(aSQL);
  FQuery.SQL.Clear;
  FQuery.SQL.Add(aSQL);
  TObjectRTTI4D.New(FTypeInfo).ListFields(aValue, FQuery.Params);
  FQuery.ExecSQL;
end;

class function TObjectSet4D.New(aConn : TComponent; AClass: TClass): iObjectSet4D;
begin
	Result := Self.Create(aConn, AClass);
end;

function TObjectSet4D.Update(aValue: TObject; AWhere: string): iObjectSet4D;
var
  LSQL : String;
begin
  Result := Self;
  TObjectSQL4D.New(FTypeInfo).Update(LSQL);
  FQuery.SQL.Clear;
  FQuery.SQL.Add(LSQL + AWhere);
  TObjectRTTI4D.New(FTypeInfo).ListFields(aValue, FQuery.Params);
  FQuery.ExecSQL;
end;

function TObjectSet4D.Delete(AWhere: string): iObjectSet4D;
var
	aSQL: string;
begin
	Result := Self;
  TObjectSQL4D.New(FTypeInfo).Delete(aSQL);
  FQuery.SQL.Clear;
  FQuery.SQL.Add(aSQL + AWhere);
  FQuery.ExecSQL;
end;

procedure TObjectSet4D.OnDataChange(Sender: TObject; Field: TField);
begin
  TObjectRTTI4D
    .New(FTypeInfo)
    .DataSetToEntity(FQuery.DataSet, FEntity);

  if Assigned(FForm) then
    TObjectRTTI4D.New(FTypeInfo).BindClassToForm(FForm, FEntity);
end;

function TObjectSet4D.Update(AWhere: string) : iObjectSet4D;
var
  LSQL : String;
  LEntity: TObject;
begin
  Result := Self;
  LEntity := GetTypeData(FTypeInfo)^.ClassType.Create;
  try
    TObjectSQL4D.New(FTypeInfo).Update(LSQL);
    FQuery.SQL.Clear;
    FQuery.SQL.Add(LSQL + AWhere);
    TObjectRTTI4D.New(FTypeInfo)
      .BindFormToClass(FForm, LEntity)
      .ListFields(LEntity, FQuery.Params);
    FQuery.ExecSQL;
  finally
    FreeAndNil(LEntity);
  end;
end;

function TObjectSet4D.DataSource(ADataSource: TDataSource): iObjectSet4D;
begin
  Result := Self;
  FDataSource := ADataSource;
  FDataSource.DataSet := FQuery.DataSet;
  {$IfDef FPC}
  FDataSource.OnDataChange := @OnDataChange;
  {$ELSE}
  FDataSource.OnDataChange := OnDataChange;
  {$EndIf}
end;

function TObjectSet4D._This: TObject;
begin
	Result := FEntity; 
end;

function TObjectSet4D.BindForm(aForm: TForm): iObjectSet4D;
begin
	Result := Self;
  FForm := aForm;
end;

end.
