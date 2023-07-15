program Test;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  ID3v1 in '..\ID3v1\ID3v1.pas',
  ID3v2 in '..\ID3v2\ID3v2.pas',
  FLACfile in 'FLACfile.pas',
  CommonATL in '..\Common\CommonATL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'FLACfile Test';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
