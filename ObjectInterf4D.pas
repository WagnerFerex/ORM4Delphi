unit ObjectInterf4D;

interface

uses
  DB, Contnrs, Classes, Forms;

type
  iDataSet4D = interface
    ['{6DCCA942-736D-4C66-AC9B-94151F14853A}']
    function SQL : TStrings;
    function Params : TParams;
    function ExecSQL : iDataSet4D;
    function DataSet : TDataSet;
    function Open(aSQL : String) : iDataSet4D; overload;
    function Open : iDataSet4D; overload;
  end;

  iObjectRTTI4D = interface
    ['{EEC49F47-24AC-4D82-9BEE-C259330A8993}']
    function ClassName (var AClassName : String) : iObjectRTTI4D;
    function Update (var AUpdate : String) : iObjectRTTI4D;
//    function Where (var AWhere : String) : iORMTypeInfo;
    function Fields (var aFields : String) : iObjectRTTI4D;
//    function FieldsInsert (var aFields : String) : iORMTypeInfo;
    function Param (var aParam : String) : iObjectRTTI4D;
    function DataSetToEntity (aDataSet : TDataSet; var aEntity : TObject) : iObjectRTTI4D;
    function DataSetToEntityList (ADataSet : TDataSet; var AList : TObjectList) : iObjectRTTI4D;
//    function ListFields (var AList : TList<String>) : iORMTypeInfo;
    function ListFields(AInstance: TObject; AParams : TParams) : iObjectRTTI4D;
    {$IFNDEF CONSOLE}
    function BindClassToForm(AForm : TForm;  const AEntity : TObject) : iObjectRTTI4D;
    function BindFormToClass(AForm : TForm; var AEntity : TObject) : iObjectRTTI4D;
    {$ENDIF}
  end;

  iObjectSQL4D = interface
    ['{1590A7C6-6E32-4579-9E60-38C966C1EB49}']
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


end.
