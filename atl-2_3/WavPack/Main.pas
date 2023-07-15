unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, WAVPackFile;

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
    EncoderLabel: TLabel;
    EncoderValue: TEdit;
    BitrateLabel: TLabel;
    BitrateValue: TEdit;
    lblBlock_samples: TLabel;
    edtBlock_samples: TEdit;
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
    WAVPackFile: TWAVPackfile;
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
  TotalSamplesValue.Text := '';
  edtBlock_samples.Text := '';
  EncoderValue.Text := '';
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
  WAVPackFile := TWAVPackfile.Create;
  ClearAll;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load WavPack's data }
    if WAVPackFile.ReadFromFile(FileList.FileName) then
      if WAVPackFile.Valid then
      begin
        { Fill captions }
        ValidHeaderValue.Text := 'Yes, version ' + IntToStr(WAVPackFile.Version);
        FileLengthValue.Text := IntToStr(WAVPackFile.FileSize) + ' bytes';
        ChannelModeValue.Text := IntToStr(WAVPackFile.Channels);
        SampleRateValue.Text := IntToStr(WAVPackFile.SampleRate) + ' hz';
        BitsPerSampleValue.Text := IntToStr(WAVPackFile.Bits) + ' bit';
        DurationValue.Text := FormatFloat('.000', WAVPackFile.Duration) + ' sec.';
        //FlagsValue.Text := IntToStr(WAVPackFile.FormatFlags);
        BitrateValue.Text := FormatFloat('.000', WAVPackFile.Bitrate);
        TotalSamplesValue.Text := IntToStr(WAVPackFile.Samples);
        edtBlock_samples.Text := IntToStr(WAVPackFile.BSamples);
        EncoderValue.Text := WAVPackFile.Encoder;
        //SeekElementsValue.Text := BoolToStr(Monkey.HasSeekElements);
        CompressionValue.Text := FormatFloat('0.00', WAVPackFile.Ratio) + '%';
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
  WAVPackFile.Free;
end;

end.
