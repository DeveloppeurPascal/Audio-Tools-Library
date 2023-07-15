unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, FLACfile;

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
    ChannelsValue: TEdit;
    ChannelsLabel: TLabel;
    SampleRateLabel: TLabel;
    BitsPerSampleLabel: TLabel;
    DurationLabel: TLabel;
    SampleRateValue: TEdit;
    BitsPerSampleValue: TEdit;
    DurationValue: TEdit;
    FileLengthValue: TEdit;
    CompressionLabel: TLabel;
    CompressionValue: TEdit;
    TotalSamplesLabel: TLabel;
    TotalSamplesValue: TEdit;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileListChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FLACfile: TFLACfile;
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
  ChannelsValue.Text := '';
  SampleRateValue.Text := '';
  BitsPerSampleValue.Text := '';
  DurationValue.Text := '';
  TotalSamplesValue.Text := '';
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
  FLACfile := TFLACfile.Create;
  ClearAll;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load FLAC data }
    if FLACfile.ReadFromFile(FileList.FileName) then
      if FLACfile.Valid then
      begin
        { Fill captions }
        ValidHeaderValue.Text := 'Yes';
        FileLengthValue.Text := IntToStr(FLACfile.FileLength) + ' bytes';
        ChannelsValue.Text := IntToStr(FLACfile.Channels);
        SampleRateValue.Text := IntToStr(FLACfile.SampleRate) + ' hz';
        BitsPerSampleValue.Text := IntToStr(FLACfile.BitsPerSample) + ' bit';
        DurationValue.Text := FormatFloat('.000', FLACfile.Duration) + ' sec.';
        TotalSamplesValue.Text := IntToStr(FLACfile.Samples);
        CompressionValue.Text := FormatFloat('0.00', FLACfile.Ratio) + '%';
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
  FLACfile.Free;
end;

end.
