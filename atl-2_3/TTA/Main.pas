unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, TTA;

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
    AudioFormatLabel: TLabel;
    AudioFormatValue: TEdit;
    BitrateLabel: TLabel;
    BitrateValue: TEdit;
    CRC32Label: TLabel;
    CRC32Value: TEdit;
    SeekElementsLabel: TLabel;
    SeekElementsValue: TEdit;
    TotalSamplesLabel: TLabel;
    TotalSamplesValue: TEdit;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileListChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    TTA: TTTA;
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
  CRC32Value.Text := '';
  BitrateValue.Text := '';
  TotalSamplesValue.Text := '';
  AudioFormatValue.Text := '';
  SeekElementsValue.Text := '';
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
  TTA := TTTA.Create;
  ClearAll;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load TTA's Audio data }
    if TTA.ReadFromFile(FileList.FileName) then
      if TTA.Valid then
      begin
        { Fill captions }
        ValidHeaderValue.Text := 'Yes';
        FileLengthValue.Text := IntToStr(TTA.FileSize) + ' bytes';
        ChannelModeValue.Text := IntToStr(TTA.Channels);
        SampleRateValue.Text := IntToStr(TTA.SampleRate) + ' hz';
        BitsPerSampleValue.Text := IntToStr(TTA.Bits) + ' bit';
        DurationValue.Text := FormatFloat('.000', TTA.Duration) + ' sec.';
        CRC32Value.Text := IntToStr(TTA.CRC32);
        BitrateValue.Text := FormatFloat('.000', TTA.Bitrate);
        TotalSamplesValue.Text := IntToStr(TTA.Samples);
        AudioFormatValue.Text := IntToStr(TTA.AudioFormat);
        //SeekElementsValue.Text := BoolToStr(TTA.HasSeekElements);
        CompressionValue.Text := FormatFloat('0.00', TTA.Ratio) + '%';
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
  TTA.Free;
end;

end.
