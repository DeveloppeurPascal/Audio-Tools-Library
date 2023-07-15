program Test;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  AC3 in 'AC3.pas',
  WideStrings in '..\Common\WideStrings.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'AC3 Test';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
