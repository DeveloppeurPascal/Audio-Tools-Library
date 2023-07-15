unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, CDAtrack;

type
  TMainForm = class(TForm)
    DriveList: TDriveComboBox;
    FolderList: TDirectoryListBox;
    FileList: TFileListBox;
    CloseButton: TButton;
    InfoBevel: TBevel;
    IconImage: TImage;
    ValidFormatLabel: TLabel;
    ValidFormatText: TEdit;
    TitleText: TEdit;
    TitleLabel: TLabel;
    ArtistLabel: TLabel;
    ArtistText: TEdit;
    AlbumLabel: TLabel;
    AlbumText: TEdit;
    DurationText: TEdit;
    DurationLabel: TLabel;
    TrackLabel: TLabel;
    TrackText: TEdit;
    PositionText: TEdit;
    PositionLabel: TLabel;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileListChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    CDAtrack: TCDAtrack;
    procedure ClearAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ClearAll;
begin
  { Clear all captions }
  ValidFormatText.Text := '';
  TitleText.Text := '';
  ArtistText.Text := '';
  AlbumText.Text := '';
  DurationText.Text := '';
  TrackText.Text := '';
  PositionText.Text := '';
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  { Exit }
  Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object and clear captions }
  CDAtrack := TCDAtrack.Create;
  ClearAll;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load CDA track data }
    if CDAtrack.ReadFromFile(FileList.FileName) then
      if CDAtrack.Valid then
      begin
        { Fill captions }
        ValidFormatText.Text := 'Yes';
        TitleText.Text := CDAtrack.Title;
        ArtistText.Text := CDAtrack.Artist;
        AlbumText.Text := CDAtrack.Album;
        DurationText.Text := FormatFloat('.000', CDAtrack.Duration) + ' sec.';
        TrackText.Text := IntToStr(CDAtrack.Track);
        PositionText.Text := FormatFloat('.000', CDAtrack.Position) + ' sec.';
      end
      else
        { Format not valid }
        ValidFormatText.Text := 'No'
    else
      { Read error }
      ShowMessage('Can not read track data: ' + FileList.FileName)
  else
    { File does not exist }
    ShowMessage('The file does not exist: ' + FileList.FileName);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Free memory }
  CDAtrack.Free;
end;

end.
