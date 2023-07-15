unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, APEtag;

type
  TMainForm = class(TForm)
    DriveList: TDriveComboBox;
    FolderList: TDirectoryListBox;
    FileList: TFileListBox;
    SaveButton: TButton;
    RemoveButton: TButton;
    CloseButton: TButton;
    InfoBevel: TBevel;
    IconImage: TImage;
    TagExistsLabel: TLabel;
    TagExistsValue: TEdit;
    VersionLabel: TLabel;
    VersionValue: TEdit;
    SizeLabel: TLabel;
    SizeValue: TEdit;
    TitleLabel: TLabel;
    TitleEdit: TEdit;
    ArtistLabel: TLabel;
    ArtistEdit: TEdit;
    AlbumLabel: TLabel;
    AlbumEdit: TEdit;
    TrackLabel: TLabel;
    TrackEdit: TEdit;
    YearLabel: TLabel;
    YearEdit: TEdit;
    GenreLabel: TLabel;
    GenreEdit: TEdit;
    CommentLabel: TLabel;
    CommentEdit: TEdit;
    CopyrightLabel: TLabel;
    CopyrightEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FileListChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SaveButtonClick(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
  private
    { Private declarations }
    FileTag: TAPEtag;
    procedure ClearAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ClearAll;
begin
  { Clear all captions }
  TagExistsValue.Text := '';
  VersionValue.Text := '';
  SizeValue.Text := '';
  TitleEdit.Text := '';
  ArtistEdit.Text := '';
  AlbumEdit.Text := '';
  TrackEdit.Text := '';
  YearEdit.Text := '';
  GenreEdit.Text := '';
  CommentEdit.Text := '';
  CopyrightEdit.Text := '';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object and clear captions }
  FileTag := TAPEtag.Create;
  ClearAll;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load tag data }
    if FileTag.ReadFromFile(FileList.FileName) then
      if FileTag.Exists then
      begin
        { Fill captions }
        TagExistsValue.Text := 'Yes';
        VersionValue.Text := FormatFloat('0,000', FileTag.Version);
        SizeValue.Text := IntToStr(FileTag.Size) + ' bytes';
        TitleEdit.Text := FileTag.SeekField('Title');
        ArtistEdit.Text := FileTag.SeekField('Artist');
        AlbumEdit.Text := FileTag.SeekField('Album');
        TrackEdit.Text := FileTag.SeekField('Track');
        YearEdit.Text := FileTag.SeekField('Year');
        GenreEdit.Text := FileTag.SeekField('Genre');
        CommentEdit.Text := FileTag.SeekField('Comment');
        CopyrightEdit.Text := FileTag.SeekField('Copyright');
      end
      else
        { Tag not found }
        TagExistsValue.Text := 'No'
    else
      { Read error }
      ShowMessage('Can not read tag from the file: ' + FileList.FileName)
  else
    { File does not exist }
    ShowMessage('The file does not exist: ' + FileList.FileName);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Free memory }
  FileTag.Free;
end;

procedure TMainForm.SaveButtonClick(Sender: TObject);
var
  Value, Code: Integer;
begin
  { Prepare tag data }
  FileTag.AppendField('Title', TitleEdit.Text);
  FileTag.AppendField('Artist', ArtistEdit.Text);
  FileTag.AppendField('Album', AlbumEdit.Text);
  FileTag.AppendField('Track', TrackEdit.Text);
  FileTag.AppendField('Year', YearEdit.Text);
  FileTag.AppendField('Genre', GenreEdit.Text);
  FileTag.AppendField('Comment', CommentEdit.Text);
  FileTag.AppendField('Copyright', CopyrightEdit.Text);
  { Save tag data }
  if (not FileExists(FileList.FileName)) or
    (not FileTag.WriteTagInFile(FileList.FileName)) then
    ShowMessage('Can not save tag to the file: ' + FileList.FileName);
  FileListChange(Self);
end;

procedure TMainForm.RemoveButtonClick(Sender: TObject);
begin
  { Delete tag data }
  if (FileExists(FileList.FileName)) and
    (FileTag.RemoveTagFromFile(FileList.FileName)) then ClearAll
  else ShowMessage('Can not remove tag from the file: ' + FileList.FileName);
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  { Exit }
  Close;
end;

end.
