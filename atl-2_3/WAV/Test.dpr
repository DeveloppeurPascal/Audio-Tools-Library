program Test;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  WAVfile in 'WAVfile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'WAVfile Test';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
