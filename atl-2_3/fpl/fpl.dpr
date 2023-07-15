program fpl;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  FPLfile in 'FPLfile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
