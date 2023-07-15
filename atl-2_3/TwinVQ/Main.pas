unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, TwinVQ;

type
  TMainForm = class(TForm)
    DriveList: TDriveComboBox;
    FolderList: TDirectoryListBox;
    FileList: TFileListBox;
    CloseButton: TButton;
    InfoBevel: TBevel;
    IconImage: TImage;
    ValidHeaderLabel: TLabel;
    FileSizeLabel: TLabel;
    ValidHeaderText: TEdit;
    SampleRateText: TEdit;
    ChannelModeLabel: TLabel;
    BitRateLabel: TLabel;
    SampleRateLabel: TLabel;
    BitRateText: TEdit;
    ChannelModeText: TEdit;
    FileSizeText: TEdit;
    DurationText: TEdit;
    DurationLabel: TLabel;
    TitleText: TEdit;
    CommentText: TEdit;
    AuthorText: TEdit;
    CopyrightText: TEdit;
    OriginalFileText: TEdit;
    TitleLabel: TLabel;
    CommentLabel: TLabel;
    AuthorLabel: TLabel;
    CopyrightLabel: TLabel;
    OriginalFileLabel: TLabel;
    AlbumLabel: TLabel;
    AlbumText: TEdit;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileListChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    TwinVQ: TTwinVQ;
    procedure ClearAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ClearAll;
begin
  { Clear all captions }
  ValidHeaderText.Text := '';
  ChannelModeText.Text := '';
  BitRateText.Text := '';
  SampleRateText.Text := '';
  FileSizeText.Text := '';
  DurationText.Text := '';
  TitleText.Text := '';
  CommentText.Text := '';
  AuthorText.Text := '';
  CopyrightText.Text := '';
  OriginalFileText.Text := '';
  AlbumText.Text := '';
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  { Exit }
  Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object }
  TwinVQ := TTwinVQ.Create;
  { Reset captions }
  ClearAll;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load TwinVQ header data }
    if TwinVQ.ReadFromFile(FileList.FileName) then
      if TwinVQ.Valid then
      begin
        { Fill captions }
        ValidHeaderText.Text := 'Yes';
        if TwinVQ.Corrupted then
          ValidHeaderText.Text := ValidHeaderText.Text + ' (file corrupted)';
        ChannelModeText.Text := TwinVQ.ChannelMode;
        BitRateText.Text := IntToStr(TwinVQ.BitRate) + ' kbit';
        SampleRateText.Text := IntToStr(TwinVQ.SampleRate) + ' hz';
        FileSizeText.Text := IntToStr(TwinVQ.FileSize) + ' bytes';
        DurationText.Text := FormatFloat('.000', TwinVQ.Duration) + ' sec.';
        TitleText.Text := TwinVQ.Title;
        CommentText.Text := TwinVQ.Comment;
        AuthorText.Text := TwinVQ.Author;
        CopyrightText.Text := TwinVQ.Copyright;
        OriginalFileText.Text := TwinVQ.OriginalFile;
        AlbumText.Text := TwinVQ.Album;
      end
      else
        { Header not found }
        ValidHeaderText.Text := 'No'
    else
      { Read error }
      ShowMessage('Can not read header in the file: ' + FileList.FileName)
  else
    { File does not exist }
    ShowMessage('The file does not exist: ' + FileList.FileName);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Free memory }
  TwinVQ.Free;
end;

end.
