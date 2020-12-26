program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  ObjectInterf4D in '..\..\ObjectInterf4D.pas',
  ObjectRTTI4D in '..\..\ObjectRTTI4D.pas',
  ObjectSet4D in '..\..\ObjectSet4D.pas',
  ObjectSQL4D in '..\..\ObjectSQL4D.pas',
  ObjectZeos4D in '..\..\ObjectZeos4D.pas',
  CLIENTE in '..\CLIENTE.pas',
  orm4d.model.cliente in 'orm4d.model.cliente.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
