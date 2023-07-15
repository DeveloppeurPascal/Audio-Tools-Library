unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, Speex;

type
  TMainForm = class(TForm)
    DriveList: TDriveComboBox;
    FolderList: TDirectoryListBox;
    FileList: TFileListBox;
    ButtonClose: TButton;
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
    procedure ButtonCloseClick(Sender: TObject);
  private
    { Private declarations }
    Speex: TSpeex;
    procedure ClearAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

(* -------------------------------------------------------------------------- *)

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

(* -------------------------------------------------------------------------- *)

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object and clear captions }
  Speex := TSpeex.Create;
  ClearAll;
end;

(* -------------------------------------------------------------------------- *)

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Free memory }
  Speex.Free;
end;

(* -------------------------------------------------------------------------- *)

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load Speex data }
    if Speex.ReadFromFile(FileList.FileName) then
      if Speex.Valid then
      begin
        { Fill captions }
        EditValidHeader.Text := 'Yes';
        EditFileSize.Text := IntToStr(Speex.FileSize) + ' bytes';
        EditChannelMode.Text := Speex.ChannelMode;
        EditSampleRate.Text := IntToStr(Speex.SampleRate) + ' Hz';
        EditDuration.Text := FormatFloat('.000', Speex.Duration) + ' sec.';
        EditBitRate.Text := IntToStr(Speex.BitRate) + ' kbps';
        EditVendor.Text := Speex.Vendor;
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

(* -------------------------------------------------------------------------- *)

procedure TMainForm.ButtonCloseClick(Sender: TObject);
begin
  { Exit }
  Close;
end;

(* -------------------------------------------------------------------------- *)

end.
