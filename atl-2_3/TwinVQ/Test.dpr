program Test;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  TwinVQ in 'TwinVQ.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'TwinVQ Test';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
