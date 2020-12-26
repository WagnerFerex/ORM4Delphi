unit ObjectSQL4D;

interface

uses
  TypInfo,
  ObjectInterf4D,
  ObjectRTTI4D;

type
  TObjectSQL4D = class(TInterfacedObject, iObjectSQL4D)
  private
  	FTypeInfo : PTypeInfo;
    FFields : String;
    FWhere : String;
    FOrderBy : String;
    FGroupBy : String;
    FJoin : String;
  public
    constructor Create(ATypeInfo: PTypeInfo);
    destructor Destroy; override;
    class function New(ATypeInfo: PTypeInfo): iObjectSQL4D;
    function Insert (var aSQL : String) : iObjectSQL4D;
    function Update (var aSQL : String) : iObjectSQL4D;
    function Delete (var aSQL : String) : iObjectSQL4D;
    function Select (var aSQL : String) : iObjectSQL4D;
    function SelectId(var aSQL: String): iObjectSQL4D;
    function Fields (aSQL : String) : iObjectSQL4D;
    function Where (aSQL : String) : iObjectSQL4D;
    function OrderBy (aSQL : String) : iObjectSQL4D;
    function GroupBy (aSQL : String) : iObjectSQL4D;
    function Join (aSQL : String) : iObjectSQL4D;
  end;

implementation

{ TORMSQL }

constructor TObjectSQL4D.Create(ATypeInfo: PTypeInfo);
begin
  FTypeInfo := ATypeInfo;
end;

function TObjectSQL4D.Delete(var aSQL: String): iObjectSQL4D;
var
  aClassName, aWhere : String;
begin
  Result := Self;
  TObjectRTTI4D.New(FTypeInfo).ClassName(aClassName);
  aSQL := 'DELETE FROM ' + aClassName +' WHERE '+ aWhere;
end;

destructor TObjectSQL4D.Destroy;
begin

  inherited;
end;

function TObjectSQL4D.Fields(aSQL: String): iObjectSQL4D;
begin
	Result := Self;
  FFields := aSQL;
end;

function TObjectSQL4D.GroupBy(aSQL: String): iObjectSQL4D;
begin
	Result := Self;
  FGroupBy := aSQL;
end;

function TObjectSQL4D.Insert(var aSQL: String): iObjectSQL4D;
var
  aClassName, aFields, aParam : String;
begin
  Result := Self;

    TObjectRTTI4D.New(FTypeInfo)
      .ClassName(aClassName)
      .Fields(aFields)
      .Param(aParam);

    aSQL := aSQL + 'INSERT INTO ' + aClassName;
    aSQL := aSQL + ' (' + aFields + ') ';
    aSQL := aSQL + ' VALUES (' + aParam + ');';
end;

function TObjectSQL4D.Join(aSQL: String): iObjectSQL4D;
begin
	Result := Self;
  FJoin := aSQL;
end;

class function TObjectSQL4D.New(ATypeInfo: PTypeInfo): iObjectSQL4D;
begin
	Result := Self.Create(ATypeInfo);
end;

function TObjectSQL4D.OrderBy(aSQL: String): iObjectSQL4D;
begin
	Result := Self;
  FOrderBy := aSQL;
end;

function TObjectSQL4D.Select(var aSQL: String): iObjectSQL4D;
var
  aFields, aClassName : String;
begin
	Result := Self;

  TObjectRTTI4D.New(FTypeInfo)
    .Fields(aFields)
    .ClassName(aClassName);

  if FFields <> '' then
    aSQL := aSQL + ' SELECT ' + FFields
  else
    aSQL := aSQL + ' SELECT ' + aFields;

  aSQL := aSQL + ' FROM ' + aClassName;

  if FJoin <> '' then
    aSQL := aSQL + ' ' + FJoin + ' ';

  if FWhere <> '' then
    aSQL := aSQL + ' WHERE ' + FWhere;

  if FGroupBy <> '' then
    aSQL := aSQL + ' GROUP BY ' + FGroupBy;  

  if FOrderBy <> '' then
    aSQL := aSQL + ' ORDER BY ' + FOrderBy;
end;

function TObjectSQL4D.SelectId(var aSQL: String): iObjectSQL4D;
var
  aFields, aClassName, aWhere : String;
begin
	Result := Self;

  TObjectRTTI4D.New(FTypeInfo)
    .Fields(aFields)
    .ClassName(aClassName);
  if FWhere <> '' then
    aSQL := aSQL + ' WHERE ' + FWhere;

  aSQL := aSQL + ' SELECT ' + aFields;
  aSQL := aSQL + ' FROM ' + aClassName;
  aSQL := aSQL + ' WHERE ' + aWhere;
end;

function TObjectSQL4D.Update(var aSQL: String): iObjectSQL4D;
var
  aClassName, aUpdate, aWhere : String;
begin
	Result := Self;

  TObjectRTTI4D.New(FTypeInfo)
    .ClassName(aClassName)
    .Update(aUpdate);

  aSQL := aSQL + 'UPDATE ' + aClassName;
  aSQL := aSQL + ' SET ' + aUpdate;
  aSQL := aSQL + ' WHERE ' + aWhere;
end;

function TObjectSQL4D.Where(aSQL: String): iObjectSQL4D;
begin
	Result := Self;
  FWhere := aSQL;
end;

end.
