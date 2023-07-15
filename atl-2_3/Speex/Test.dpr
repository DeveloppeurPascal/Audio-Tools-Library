program Test;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Speex in 'Speex.pas',
  VorbisComment in '..\Vorbis Comment\VorbisComment.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Speex Test';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
