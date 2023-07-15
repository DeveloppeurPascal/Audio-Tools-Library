program Test;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  DTS in 'DTS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DTS Test';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
