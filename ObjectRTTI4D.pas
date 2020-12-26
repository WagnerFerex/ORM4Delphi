{$TYPEINFO ON}
{$IfNDef FPC}
  {$if COMPILERVERSION > 20}
    {$WARN IMPLICIT_STRING_CAST OFF}
  {$ifend}
{$EndIf}
unit ObjectRTTI4D;

interface

uses
  Classes,
  Contnrs,
  SysConst,
  TypInfo,
  Forms,
  DB,
  ObjectInterf4D;

type
  TObjectRTTI4D = class(TInterfacedObject, iObjectRTTI4D)
  private
    FTypeInfo : PTypeInfo;
    function _findComponent(const AName: string; const AForm: TForm): TComponent;
    function _getPropValue(Instance: TObject; PropInfo: PPropInfo; PreferStrings: Boolean = True): Variant;
    procedure _setPropValue(Instance: TObject; PropInfo: PPropInfo; const Value: Variant);
  public
    constructor Create(ATypeInfo: PTypeInfo);
    destructor Destroy; override;
    class function New(ATypeInfo: PTypeInfo): iObjectRTTI4D;
    function ClassName (var AClassName : String) : iObjectRTTI4D;
    function Update (var AUpdate : String) : iObjectRTTI4D;
    function Fields (var aFields : String) : iObjectRTTI4D;
    function Param (var aParam : String) : iObjectRTTI4D;
    function DataSetToEntity (aDataSet : TDataSet; var aEntity : TObject) : iObjectRTTI4D;
    function DataSetToEntityList (ADataSet : TDataSet; var AList : TObjectList) : iObjectRTTI4D;
    function ListFields(AInstance: TObject; AParams : TParams) : iObjectRTTI4D;
    function BindClassToForm(AForm : TForm;  const AEntity : TObject) : iObjectRTTI4D;
    function BindFormToClass(AForm : TForm; var AEntity : TObject) : iObjectRTTI4D;
  end;

implementation

uses
  Variants, SysUtils, StdCtrls, ExtCtrls, ComCtrls;

{ TORMTypeInfo }

function TObjectRTTI4D.BindClassToForm(AForm: TForm;
  const AEntity: TObject): iObjectRTTI4D;
var
  LPropList: PPropList;
  I: Integer;
  LComponent: TComponent;
  LValue: Variant;

begin
  Result := Self;
  for I := 0 to GetPropList(FTypeInfo, LPropList) - 1 do
  begin
    LComponent := _findComponent(LPropList^[I]^.Name, AForm);

    if (LComponent <> nil) then
    begin
      LValue := _getPropValue(AEntity, LPropList^[I]);

      if (LComponent is TEdit) then
        (LComponent as TEdit).Text := VarToStr(LValue);

      if (LComponent is TRadioGroup) then
        (LComponent as TRadioGroup).ItemIndex := LValue;

      if (LComponent is TMemo) then
        (LComponent as TMemo).Lines.Text := VarToStr(LValue);

      if (LComponent is TComboBox) then
        (LComponent as TComboBox).ItemIndex := LValue;

      {$IFDEF JVCL}
      if (LComponent is TJvDateEdit) then
        (LComponent as TJvDateEdit).Text := VarToStr(LValue);
      {$ENDIF}

      {$IfNDef FPC}
      if (LComponent is TDateTimePicker) then
        (LComponent as TDateTimePicker).DateTime := TDateTime(LValue);
      {$EndIf}
    end;
  end;
  FreeMem(LPropList);
end;

function TObjectRTTI4D.BindFormToClass(AForm: TForm;
  var AEntity: TObject): iObjectRTTI4D;
var
  LPropList: PPropList;
  I: Integer;
  LComponent: TComponent;
  LValue: Variant;
begin
  Result := Self;
  for I := 0 to GetPropList(FTypeInfo, LPropList) - 1 do
  begin
    LValue := Unassigned;
    LComponent := _findComponent(LPropList^[I]^.Name, AForm);

    if (LComponent <> nil) then
    begin
      if (LComponent is TEdit) then
        LValue := (LComponent as TEdit).Text;

      if (LComponent is TRadioGroup) then
        LValue := (LComponent as TRadioGroup).ItemIndex;

      if (LComponent is TMemo) then
        LValue := (LComponent as TMemo).Lines.Text;

      if (LComponent is TComboBox) then
        LValue := (LComponent as TComboBox).ItemIndex;

      {$IFDEF JVCL}
      if (LComponent is TJvDateEdit) then
        LValue := (LComponent as TJvDateEdit).Text;
      {$ENDIF}

      {$IFNDEF FPC}
      if (LComponent is TDateTimePicker) then
        LValue := (LComponent as TDateTimePicker).DateTime;
      {$ENDIF}

      _setPropValue(AEntity, LPropList^[I], LValue);
    end;
  end;
  FreeMem(LPropList);
end;

function TObjectRTTI4D.ClassName(var AClassName: String): iObjectRTTI4D;
begin
  Result := Self;
  AClassName := Copy(FTypeInfo^.Name, 2, Length(FTypeInfo^.Name));
end;

constructor TObjectRTTI4D.Create(ATypeInfo: PTypeInfo);
begin
  FTypeInfo := ATypeInfo;
end;

function TObjectRTTI4D.DataSetToEntity(aDataSet: TDataSet;
  var AEntity: TObject): iObjectRTTI4D;
var
  LPropList: PPropList;
  I: Integer;
  LValue : Variant;
begin
  Result := Self;
  if (not aDataSet.IsEmpty) then
  begin
    for I := 0 to GetPropList(FTypeInfo, LPropList) - 1 do
    begin
    	case LPropList^[I]^.PropType^.Kind of
        tkUnknown, tkString, tkWChar, tkLString, tkWString:
          LValue := aDataSet.FieldByName(LPropList^[I]^.Name).AsString;
        tkInteger, tkInt64:
          LValue := aDataSet.FieldByName(LPropList^[I]^.Name).AsInteger;
        tkChar: ;
        tkEnumeration: ;
        tkFloat:
          LValue := aDataSet.FieldByName(LPropList^[I]^.Name).AsFloat;
        tkSet: ;
        tkClass: ;
        tkMethod: ;
        tkVariant: ;
        tkArray: ;
        tkRecord: ;
        tkInterface: ;
        tkDynArray: ;
      else
      	LValue := aDataSet.FieldByName(LPropList^[I]^.Name).AsString;
      end;

      _setPropValue(AEntity, LPropList^[I], LValue);
    end;
  end;
  FreeMem(LPropList);
end;

function TObjectRTTI4D.DataSetToEntityList(ADataSet: TDataSet;
  var AList: TObjectList): iObjectRTTI4D;
var
  LPropList: PPropList;
  I: Integer;
  LValue : Variant;
begin
  Result := Self;
  AList.Clear;
  while not aDataSet.Eof do
  begin
    AList.Add(GetTypeData(FTypeInfo)^.ClassType.Create);
    for I := 0 to GetPropList(FTypeInfo, LPropList) - 1 do
    begin
    	case LPropList^[I]^.PropType^.Kind of
        tkUnknown, tkString, tkWChar, tkLString, tkWString:
          LValue := aDataSet.FieldByName(LPropList^[I]^.Name).AsString;
        tkInteger, tkInt64:
          LValue := aDataSet.FieldByName(LPropList^[I]^.Name).AsInteger;
        tkChar: ;
        tkEnumeration: ;
        tkFloat:
          LValue := aDataSet.FieldByName(LPropList^[I]^.Name).AsFloat;
        tkSet: ;
        tkClass: ;
        tkMethod: ;
        tkVariant: ;
        tkArray: ;
        tkRecord: ;
        tkInterface: ;
        tkDynArray: ;
      else
      	LValue := aDataSet.FieldByName(LPropList^[I]^.Name).AsString;
      end;

      _setPropValue(AList[Pred(AList.Count)], LPropList^[I], LValue);
    end;

    aDataSet.Next;
  end;
  FreeMem(LPropList);
end;

destructor TObjectRTTI4D.Destroy;
begin

  inherited;
end;

function TObjectRTTI4D.Fields(var aFields: String): iObjectRTTI4D;
var
  I: Integer;
  PropList: PPropList;
begin
  Result := Self;
  try
    for I := 0 to GetPropList(FTypeInfo, PropList) - 1 do
      aFields := aFields + PropList^[I]^.Name + ', ';
  finally
    FreeMem(PropList);
    aFields := Copy(aFields, 0, Length(aFields) - 2) + ' ';
  end;
end;

function TObjectRTTI4D._getPropValue(Instance: TObject; PropInfo: PPropInfo;
  PreferStrings: Boolean): Variant;
begin
  // assume failure
  Result := Null;

  // return the right type
  case PropInfo^.PropType^.Kind of
    tkInteger, tkChar, tkWChar, tkClass:
      Result := GetOrdProp(Instance, PropInfo);
    tkEnumeration:
      if PreferStrings then
        Result := GetEnumProp(Instance, PropInfo)
      else if GetTypeData(PropInfo^.PropType^).BaseType = TypeInfo(Boolean) then
        Result := Boolean(GetOrdProp(Instance, PropInfo))
      else
        Result := GetOrdProp(Instance, PropInfo);
    tkSet:
      if PreferStrings then
        Result := GetSetProp(Instance, PropInfo, False)
      else
        Result := GetOrdProp(Instance, PropInfo);
    tkFloat:
      Result := GetFloatProp(Instance, PropInfo);
    tkMethod:
      //Result := GetTypeName(PropInfo^.PropType^)
      ;
    tkString, tkLString:
      Result := GetStrProp(Instance, PropInfo);
    tkWString:
      Result := GetWideStrProp(Instance, PropInfo);
    //tkUString:
      // Result := GetUnicodeStrProp(Instance, PropInfo);
    tkVariant:
      Result := GetVariantProp(Instance, PropInfo);
    tkInt64:
      Result := GetInt64Prop(Instance, PropInfo);
//    tkDynArray:
//      begin
//        DynArray := GetDynArrayProp(Instance, PropInfo);
//        DynArrayToVariant(Result, DynArray, PropInfo^.PropType^);
//      end;
  else
    Result := GetStrProp(Instance, PropInfo);
  end;
end;

function TObjectRTTI4D.ListFields(AInstance: TObject; AParams : TParams): iObjectRTTI4D;
var
	LPropList: PPropList;
  I: Integer;
  LValue: Variant;
begin
  Result := Self;
  try
    for I := 0 to GetPropList(FTypeInfo, LPropList) - 1 do
    begin
      if (AParams.ParamByName(LPropList^[I]^.Name) <> nil) then
      begin
        LValue := _getPropValue(AInstance, LPropList^[I]);
//        case TVarData(LValue).VType of
//          varEmpty: ;
//          varDate: ;
//          varNull: ;
//          varInteger: ;
//          varDouble: ;
//          varString: ;
//          else
//            ;
//        end;

        case LPropList^[I]^.PropType^.Kind of
          tkUnknown, tkString, tkWChar, tkLString,
          tkWString:
          	AParams.ParamByName(LPropList^[I]^.Name).Value := VarToStr(LValue);
          tkInteger,
          tkInt64:
          	AParams.ParamByName(LPropList^[I]^.Name).AsInteger := LValue;
          tkChar: ;
          tkEnumeration: ;
          tkFloat:
            if CompareText('TDateTime',LPropList^[I]^.PropType^.Name)=0 then
              AParams.ParamByName(LPropList^[I]^.Name).Value := TDateTime(LValue)
            else
              AParams.ParamByName(LPropList^[I]^.Name).Value := LValue;
          tkSet: ;
          tkClass: ;
          tkMethod: ;
          tkVariant: ;
          tkArray: ;
          tkRecord: ;
          tkInterface: ;
          tkDynArray: ;
        else
          AParams.ParamByName(LPropList^[I]^.Name).Value := VarToStr(LValue);
        end;
      end;
    end;

  finally
    FreeMem(LPropList);
  end;
end;

class function TObjectRTTI4D.New(ATypeInfo: PTypeInfo): iObjectRTTI4D;
begin
  Result := Self.Create(ATypeInfo);
end;

function TObjectRTTI4D.Param(var aParam: String): iObjectRTTI4D;
var
  I: Integer;
  PropList: PPropList;
begin
	Result := Self;
  try
  	for I := 0 to GetPropList(FTypeInfo, PropList) - 1 do
  		aParam := aParam + ':' + PropList^[I]^.Name + ', ';
  finally
    FreeMem(PropList);
    aParam := Copy(aParam, 0, Length(aParam) - 2) + ' ';
  end;
end;


procedure TObjectRTTI4D._setPropValue(Instance: TObject; PropInfo: PPropInfo;
  const Value: Variant);
  function RangedValue(const AMin, AMax: Int64): Int64;
  begin
    Result := StrToInt(VarToStr(Value));
    if (Result < AMin) or (Result > AMax) then
       raise ERangeError.CreateRes(@SRangeError);
  end;

  function RangedCharValue(const AMin, AMax: Int64): Int64;
  var
    s: string;
    ws: string;
  begin
    case VarType(Value) of
      varString:
        begin
          s := Value;
          if Length(s) = 1 then
            Result := Ord(s[1])
          else
            Result := AMin-1;
       end;

//      varUString:
//        begin
//          s := Value;
//          if Length(s) = 1 then
//            Result := Ord(s[1])
//          else
//            Result := AMin-1;
//       end;

      varOleStr:
        begin
          ws := Value;
          if Length(ws) = 1 then
            Result := Ord(ws[1])
          else
            Result := AMin-1;
        end;
    else
      Result := StrToInt(VarToStr(Value));
    end;

    if (Result < AMin) or (Result > AMax) then
      raise ERangeError.CreateRes(@SRangeError);
  end;

var
  TypeData: PTypeData;
begin
  TypeData := GetTypeData(PropInfo^.PropType^);

  // set the right type
  case PropInfo^.PropType^.Kind of
    tkChar, tkWChar:
      SetOrdProp(Instance, PropInfo, RangedCharValue(TypeData^.MinValue,
        TypeData^.MaxValue));
    tkInteger:
      if TypeData^.MinValue < TypeData^.MaxValue then
        SetOrdProp(Instance, PropInfo, RangedValue(TypeData^.MinValue,
          TypeData^.MaxValue))
      else
        // Unsigned type
        SetOrdProp(Instance, PropInfo,
          RangedValue(LongWord(TypeData^.MinValue),
          LongWord(TypeData^.MaxValue)));
    tkEnumeration:
      if (VarType(Value) = varString) or (VarType(Value) = varOleStr) {or (VarType(Value) = varUString)} then
        SetEnumProp(Instance, PropInfo, VarToStr(Value))
      else if VarType(Value) = varBoolean then
        // Need to map variant boolean values -1,0 to 1,0
        SetOrdProp(Instance, PropInfo, Abs(StrToInt(VarToStr(Value))))
      else
        SetOrdProp(Instance, PropInfo, RangedValue(TypeData^.MinValue,
          TypeData^.MaxValue));
    tkSet:
      if VarType(Value) = varInteger then
        SetOrdProp(Instance, PropInfo, Value)
      else
        SetSetProp(Instance, PropInfo, VarToStr(Value));
    tkFloat:
      SetFloatProp(Instance, PropInfo, Value);
    tkString, tkLString:
      SetStrProp(Instance, PropInfo, VarToStr(Value));
    tkWString:
      SetWideStrProp(Instance, PropInfo, VarToWideStr(Value));
//    tkUString:
//      SetUnicodeStrProp(Instance, PropInfo, VarToStr(Value)); //SB: ??
    tkVariant:
      SetVariantProp(Instance, PropInfo, Value);
    tkInt64:
      SetInt64Prop(Instance, PropInfo, RangedValue(TypeData^.MinInt64Value,
        TypeData^.MaxInt64Value));
//    tkDynArray:
//      begin
//        DynArray := nil; // "nil array"
//        DynArrayFromVariant(DynArray, Value, PropInfo^.PropType^);
//        SetDynArrayProp(Instance, PropInfo, DynArray);
//      end;
  else
    SetStrProp(Instance, PropInfo, VarToStr(Value));
  end;
end;

function TObjectRTTI4D.Update(var AUpdate: String): iObjectRTTI4D;
var
	I: Integer;
  PropList: PPropList;
begin
	Result := Self;
  try
  	for I := 0 to GetPropList(FTypeInfo, PropList) - 1 do
  		AUpdate := AUpdate + PropList^[I]^.Name + ' = :' + PropList^[I]^.Name + ', ';
  finally
    FreeMem(PropList);
    AUpdate := Copy(AUpdate, 0, Length(AUpdate) - 2) + ' ';
  end;
end;

function TObjectRTTI4D._findComponent(const AName: string;
  const AForm: TForm): TComponent;
var
  I: Integer;
begin
  for I := 0 to AForm.ComponentCount - 1 do
  begin
    if not (AForm.Components[I] is TLabel) then
    begin
      if Copy(AForm.Components[I].Name, Pos(AName, AForm.Components[I].Name), 100) = AName then
      begin
        Result := AForm.Components[I];
        Exit;
      end;
    end;
  end;
  Result := nil;
end;

end.
