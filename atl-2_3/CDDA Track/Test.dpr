program Test;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  CDAtrack in 'CDAtrack.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'CDAtrack Test';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
