program Test;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  OggVorbis in 'OggVorbis.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'OggVorbis Test';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
