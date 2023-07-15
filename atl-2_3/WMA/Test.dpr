program Test;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  WMAfile in 'WMAfile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'WMAfile Test';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
