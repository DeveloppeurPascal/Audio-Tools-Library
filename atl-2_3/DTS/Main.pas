unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, DTS;

type
  TMainForm = class(TForm)
    DriveList: TDriveComboBox;
    FolderList: TDirectoryListBox;
    FileList: TFileListBox;
    CloseButton: TButton;
    InfoBevel: TBevel;
    IconImage: TImage;
    ValidHeaderLabel: TLabel;
    FileLengthLabel: TLabel;
    ValidHeaderValue: TEdit;
    ChannelModeValue: TEdit;
    ChannelModeLabel: TLabel;
    SampleRateLabel: TLabel;
    BitsPerSampleLabel: TLabel;
    DurationLabel: TLabel;
    SampleRateValue: TEdit;
    BitsPerSampleValue: TEdit;
    DurationValue: TEdit;
    FileLengthValue: TEdit;
    CompressionLabel: TLabel;
    CompressionValue: TEdit;
    BitrateLabel: TLabel;
    BitrateValue: TEdit;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileListChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    DTS: TDTS;
    procedure ClearAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ClearAll;
begin
  { Clear all captions }
  ValidHeaderValue.Text := '';
  FileLengthValue.Text := '';
  ChannelModeValue.Text := '';
  SampleRateValue.Text := '';
  BitsPerSampleValue.Text := '';
  DurationValue.Text := '';
  BitrateValue.Text := '';
  CompressionValue.Text := '';
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  { Exit }
  Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object and reset captions }
  DTS := TDTS.Create;
  ClearAll;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load DTS's Audio data }
    if DTS.ReadFromFile(FileList.FileName) then
      if DTS.Valid then
      begin
        { Fill captions }
        ValidHeaderValue.Text := 'Yes';
        FileLengthValue.Text := IntToStr(DTS.FileSize) + ' bytes';
        ChannelModeValue.Text := IntToStr(DTS.Channels);
        SampleRateValue.Text := IntToStr(DTS.SampleRate) + ' hz';
        BitsPerSampleValue.Text := IntToStr(DTS.Bits) + ' bit';
        DurationValue.Text := FormatFloat('.000', DTS.Duration) + ' sec.';
        BitrateValue.Text := IntToStr(DTS.Bitrate) + ' kbps';
        CompressionValue.Text := FormatFloat('0.00', DTS.Ratio) + '%';
      end
      else
        { Header not found }
        ValidHeaderValue.Text := 'No'
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
  DTS.Free;
end;

end.
