unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, Musepack;

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
    ChannelModeText: TEdit;
    ChannelModeLabel: TLabel;
    BitRateLabel: TLabel;
    FrameCountLabel: TLabel;
    DurationLabel: TLabel;
    BitRateText: TEdit;
    FrameCountText: TEdit;
    DurationText: TEdit;
    FileSizeText: TEdit;
    TypeLabel: TLabel;
    TypeText: TEdit;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileListChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    MPEGplus: TMPEGplus;
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
  FileSizeText.Text := '';
  FrameCountText.Text := '';
  BitRateText.Text := '';
  TypeText.Text := '';
  DurationText.Text := '';
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  { Exit }
  Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object }
  MPEGplus := TMPEGplus.Create;
  { Reset captions }
  ClearAll;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load MPEGplus header }
    if MPEGplus.ReadFromFile(FileList.FileName) then
      if MPEGplus.Valid then
      begin
        { Fill captions }
        ValidHeaderText.Text := 'Yes';
        if MPEGplus.Corrupted then
          ValidHeaderText.Text := ValidHeaderText.Text + ' (file corrupted)';
        ChannelModeText.Text := MPEGplus.ChannelMode;
        FileSizeText.Text := IntToStr(MPEGplus.FileSize) + ' bytes';
        FrameCountText.Text := IntToStr(MPEGplus.FrameCount);
        BitRateText.Text := IntToStr(MPEGplus.BitRate) + ' kbit';
        TypeText.Text := 'Stream Version ' + IntToStr(MPEGplus.StreamVersion div 10) + '.' + IntToStr(MPEGplus.StreamVersion mod 10);
        if (MPEGplus.StreamVersion = 7) or (MPEGplus.StreamVersion = 71) then
          TypeText.Text := TypeText.Text + ', Profile ' + MPEGplus.Profile;
        DurationText.Text := FormatFloat('.000', MPEGplus.Duration) + ' sec.';
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
  MPEGplus.Free;
end;

end.
