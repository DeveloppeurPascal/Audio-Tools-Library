unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, OggVorbis;

type
  TMainForm = class(TForm)
    DriveList: TDriveComboBox;
    FolderList: TDirectoryListBox;
    FileList: TFileListBox;
    ButtonClose: TButton;
    ButtonSaveTag: TButton;
    ButtonClearTag: TButton;
    InfoBevel: TBevel;
    IconImage: TImage;
    LabelValidHeader: TLabel;
    LabelFileSize: TLabel;
    LabelChannelMode: TLabel;
    LabelSampleRate: TLabel;
    LabelDuration: TLabel;
    LabelBitRate: TLabel;
    LabelVendor: TLabel;
    LabelTitle: TLabel;
    LabelArtist: TLabel;
    LabelAlbum: TLabel;
    LabelTrack: TLabel;
    LabelDate: TLabel;
    LabelGenre: TLabel;
    LabelComment: TLabel;
    EditValidHeader: TEdit;
    EditFileSize: TEdit;
    EditChannelMode: TEdit;
    EditSampleRate: TEdit;
    EditDuration: TEdit;
    EditBitRate: TEdit;
    EditVendor: TEdit;
    EditTitle: TEdit;
    EditArtist: TEdit;
    EditAlbum: TEdit;
    EditTrack: TEdit;
    EditDate: TEdit;
    EditGenre: TEdit;
    EditComment: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FileListChange(Sender: TObject);
    procedure ButtonSaveTagClick(Sender: TObject);
    procedure ButtonClearTagClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
  private
    { Private declarations }
    Vorbis: TOggVorbis;
    procedure ClearAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ClearAll;
begin
  { Clear all captions }
  EditValidHeader.Text := '';
  EditFileSize.Text := '';
  EditChannelMode.Text := '';
  EditSampleRate.Text := '';
  EditDuration.Text := '';
  EditBitRate.Text := '';
  EditVendor.Text := '';
  EditTitle.Text := '';
  EditArtist.Text := '';
  EditAlbum.Text := '';
  EditTrack.Text := '';
  EditDate.Text := '';
  EditGenre.Text := '';
  EditComment.Text := '';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object and clear captions }
  Vorbis := TOggVorbis.Create;
  ClearAll;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Free memory }
  Vorbis.Free;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load OggVorbis data }
    if Vorbis.ReadFromFile(FileList.FileName) then
      if Vorbis.Valid then
      begin
        { Fill captions }
        EditValidHeader.Text := 'Yes';
        if Vorbis.ID3v2 then
          EditValidHeader.Text := EditValidHeader.Text + ', ID3v2 tag found'; 
        EditFileSize.Text := IntToStr(Vorbis.FileSize) + ' bytes';
        EditChannelMode.Text := Vorbis.ChannelMode;
        EditSampleRate.Text := IntToStr(Vorbis.SampleRate) + ' hz';
        EditDuration.Text := FormatFloat('.000', Vorbis.Duration) + ' sec.';
        EditBitRate.Text := IntToStr(Vorbis.BitRate) + ' kbps, nominal ';
        EditBitRate.Text := EditBitRate.Text + IntToStr(Vorbis.BitRateNominal);
        EditVendor.Text := Vorbis.Vendor;
        EditTitle.Text := Vorbis.Title;
        EditArtist.Text := Vorbis.Artist;
        EditAlbum.Text := Vorbis.Album;
        if Vorbis.Track > 0 then EditTrack.Text := IntToStr(Vorbis.Track);
        EditDate.Text := Vorbis.Date;
        EditGenre.Text := Vorbis.Genre;
        EditComment.Text := Vorbis.Comment;
      end
      else
        { Header not found }
        EditValidHeader.Text := 'No'
    else
      { Read error }
      ShowMessage('Can not read header in the file: ' + FileList.FileName)
  else
    { File does not exist }
    ShowMessage('The file does not exist: ' + FileList.FileName);
end;

procedure TMainForm.ButtonSaveTagClick(Sender: TObject);
var
  Value, Code: Integer;
begin
  { Prepare tag data }
  Vorbis.Title := EditTitle.Text;
  Vorbis.Artist := EditArtist.Text;
  Vorbis.Album := EditAlbum.Text;
  Val(EditTrack.Text, Value, Code);
  if (Code = 0) and (Value > 0) then Vorbis.Track := Value
  else Vorbis.Track := 0;
  Vorbis.Date := EditDate.Text;
  Vorbis.Genre := EditGenre.Text;
  Vorbis.Comment := EditComment.Text;
  { Save tag data }
  if (not FileExists(FileList.FileName)) or
    (not Vorbis.SaveTag(FileList.FileName)) then
    ShowMessage('Can not save tag to the file: ' + FileList.FileName);
  FileListChange(Self);
end;

procedure TMainForm.ButtonClearTagClick(Sender: TObject);
begin
  { Clear tag data }
  if (FileExists(FileList.FileName)) and
    (Vorbis.ClearTag(FileList.FileName)) then ClearAll
  else ShowMessage('Can not remove tag from the file: ' + FileList.FileName);
end;

procedure TMainForm.ButtonCloseClick(Sender: TObject);
begin
  { Exit }
  Close;
end;

end.
