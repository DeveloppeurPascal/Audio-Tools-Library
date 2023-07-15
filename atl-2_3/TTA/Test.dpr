program Test;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  ID3v1 in '..\ID3v1\ID3v1.pas',
  ID3v2 in '..\ID3v2\ID3v2.pas',
  APEtag in '..\APE Tag\APEtag.pas',
  TTA in 'TTA.pas',
  CommonATL in '..\Common\CommonATL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'TTA Test';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
