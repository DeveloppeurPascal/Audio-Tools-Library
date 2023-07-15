unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, MPEGaudio;

type
  TMainForm = class(TForm)
    DriveList: TDriveComboBox;
    FolderList: TDirectoryListBox;
    FileList: TFileListBox;
    CloseButton: TButton;
    InfoBevel: TBevel;
    IconImage: TImage;
    ValidMPEGLabel: TLabel;
    FileSizeLabel: TLabel;
    ValidMPEGText: TEdit;
    FirstFrameAtText: TEdit;
    FirstFrameAtLabel: TLabel;
    BitRateLabel: TLabel;
    MPEGTypeLabel: TLabel;
    DurationLabel: TLabel;
    BitRateText: TEdit;
    MPEGTypeText: TEdit;
    DurationText: TEdit;
    FileSizeText: TEdit;
    SampleRateLabel: TLabel;
    SampleRateText: TEdit;
    ChannelModeLabel: TLabel;
    ChannelModeText: TEdit;
    EmphasisLabel: TLabel;
    EmphasisText: TEdit;
    EncoderLabel: TLabel;
    EncoderText: TEdit;
    CRCProtectionLabel: TLabel;
    CRCProtectionText: TEdit;
    TotalFramesLabel: TLabel;
    TotalFramesText: TEdit;
    CopyrightLabel: TLabel;
    CopyrightText: TEdit;
    OriginalLabel: TLabel;
    OriginalText: TEdit;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileListChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    MPEGaudio: TMPEGaudio;
    procedure ClearAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ClearAll;
begin
  { Clear all captions }
  ValidMPEGText.Text := '';
  FileSizeText.Text := '';
  MPEGTypeText.Text := '';
  BitRateText.Text := '';
  SampleRateText.Text := '';
  ChannelModeText.Text := '';
  DurationText.Text := '';
  FirstFrameAtText.Text := '';
  CRCProtectionText.Text := '';
  TotalFramesText.Text := '';
  CopyrightText.Text := '';
  OriginalText.Text := '';
  EmphasisText.Text := '';
  EncoderText.Text := '';
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  { Exit }
  Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object and clear captions }
  MPEGaudio := TMPEGaudio.Create;
  ClearAll;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load MPEG audio data  }
    if MPEGaudio.ReadFromFile(FileList.FileName) then
      if MPEGaudio.Valid then
      begin
        { Fill captions }
        ValidMPEGText.Text := 'Yes';
        FileSizeText.Text := IntToStr(MPEGaudio.FileLength) + ' bytes';
        MPEGTypeText.Text := MPEGaudio.Version + ' ' + MPEGaudio.Layer;
        if MPEGaudio.VBR.Found then
          BitRateText.Text := 'VBR ' + IntToStr(MPEGaudio.BitRate) + ' kbit/s'
        else
          BitRateText.Text := 'CBR ' + IntToStr(MPEGaudio.BitRate) + ' kbit/s';
        SampleRateText.Text := IntToStr(MPEGaudio.SampleRate) + ' hz';
        ChannelModeText.Text := MPEGaudio.ChannelMode;
        DurationText.Text := FormatFloat('.0', MPEGaudio.Duration) + ' sec.';
        FirstFrameAtText.Text := IntToStr(MPEGaudio.Frame.Position) + ' bytes';
        TotalFramesText.Text := IntToStr(MPEGaudio.Frames);
        if MPEGaudio.Frame.ProtectionBit then CRCProtectionText.Text := 'Yes'
        else CRCProtectionText.Text := 'No';
        if MPEGaudio.Frame.CopyrightBit then CopyrightText.Text := 'Yes'
        else CopyrightText.Text := 'No';
        if MPEGaudio.Frame.OriginalBit then OriginalText.Text := 'Yes'
        else OriginalText.Text := 'No';
        EmphasisText.Text := MPEGaudio.Emphasis;
        EncoderText.Text := MPEGaudio.Encoder;
      end
      else
        { Not valid MPEG file }
        ValidMPEGText.Text := 'No'
    else
      { Read error }
      ShowMessage('Can not read data from the file: ' + FileList.FileName)
  else
    { File does not exist }
    ShowMessage('The file does not exist: ' + FileList.FileName);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Free memory }
  MPEGaudio.Free;
end;

end.
