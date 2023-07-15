unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellAPI, FPLfile;

type
  TfrmMain = class(TForm)
    ListViewFPL: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure PerformFileOpen(const FileName: String);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

(* -------------------------------------------------------------------------- *)

procedure TfrmMain.WMDropFiles(var Msg: TWMDropFiles);
var
  FileName: array[0..MAX_PATH] of Char;
begin
  try
    if DragQueryFile(Msg.Drop, 0, FileName, MAX_PATH) > 0 then
    begin
      PerformFileOpen(FileName);
      Msg.Result := 0;
    end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

(* -------------------------------------------------------------------------- *)

procedure TfrmMain.PerformFileOpen(const FileName: String);
var
  FPLfile: TFPLfile;
  i: Cardinal;
  NewItem : TListItem;
begin
  FPLfile := TFPLfile.Create;
  if FPLfile.ReadFromFile(FileName) then
  begin
    for i := 1 to FPLfile.NumberOfFiles do
    begin
      //AddFile(FPLfile.GetFilePath(i), LowerCase(ExtractFileExt(FPLfile.GetFilePath(i))));
      NewItem := ListViewFPL.Items.Add;
      NewItem.Caption := FPLfile.GetFilePath(i);
      NewItem.SubItems.Add(FPLfile.GetTrack(i));
      NewItem.SubItems.Add(FPLfile.GetArtist(i));
      NewItem.SubItems.Add(FPLfile.GetTitle(i));
      NewItem.SubItems.Add(FPLfile.GetAlbum(i));
      NewItem.SubItems.Add(FPLfile.GetYear(i));
      NewItem.SubItems.Add(FPLfile.GetGenre(i));
      NewItem.SubItems.Add(FPLfile.GetComment(i));
      NewItem.SubItems.Add(FPLfile.GetSamplerate(i));
      NewItem.SubItems.Add(FPLfile.GetChannels(i));
      NewItem.SubItems.Add(FPLfile.GetBitrate(i));
      NewItem.SubItems.Add(FPLfile.GetCodec(i));      
    end;
  end;
  FPLfile.Free;
end;

(* -------------------------------------------------------------------------- *)

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle, True);
end;
                           
(* -------------------------------------------------------------------------- *)

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(Handle, False);
end;

(* -------------------------------------------------------------------------- *)

end.
