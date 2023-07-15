unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, AACfile;

type
  TMainForm = class(TForm)
    DriveList: TDriveComboBox;
    FolderList: TDirectoryListBox;
    FileList: TFileListBox;
    CloseButton: TButton;
    InfoBevel: TBevel;
    IconImage: TImage;
    LabelValidHeader: TLabel;
    LabelFileSize: TLabel;
    LabelType: TLabel;
    LabelChannels: TLabel;
    LabelSampleRate: TLabel;
    LabelBitRate: TLabel;
    LabelDuration: TLabel;
    EditValidHeader: TEdit;
    EditFileSize: TEdit;
    EditType: TEdit;
    EditChannels: TEdit;
    EditSampleRate: TEdit;
    EditBitRate: TEdit;
    EditDuration: TEdit;
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileListChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    AACfile: TAACfile;
    procedure ClearAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ClearAll;
begin
  { Clear all captions }
  EditValidHeader.Text := '';
  EditFileSize.Text := '';
  EditType.Text := '';
  EditChannels.Text := '';
  EditSampleRate.Text := '';
  EditBitRate.Text := '';
  EditDuration.Text := '';
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  { Exit }
  Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object and reset captions }
  AACfile := TAACfile.Create;
  ClearAll;
end;

procedure TMainForm.FileListChange(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if FileList.FileName = '' then exit;
  if FileExists(FileList.FileName) then
    { Load AAC header }
    if AACfile.ReadFromFile(FileList.FileName) then
      if AACfile.Valid then
      begin
        { Fill captions }
        EditValidHeader.Text := AACfile.HeaderType;
        EditFileSize.Text := IntToStr(AACfile.FileSize) + ' bytes';
        if AACfile.MPEGVersionID = AAC_MPEG_VERSION_UNKNOWN then
          EditType.Text := AACfile.Profile
        else
          EditType.Text := AACfile.MPEGVersion + ' ' + AACfile.Profile;
        EditChannels.Text := IntToStr(AACfile.Channels);
        EditSampleRate.Text := IntToStr(AACfile.SampleRate) + ' hz';
        if AACfile.BitRateTypeID = AAC_BITRATE_TYPE_VBR then
          EditBitRate.Text := IntToStr(Round(AACfile.BitRate / 1000)) +
            ' kbit/s VBR'
        else
          EditBitRate.Text := IntToStr(Round(AACfile.BitRate / 1000)) +
            ' kbit/s CBR';
        EditDuration.Text := FormatFloat('.0', AACfile.Duration) + ' sec.';
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

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Free memory }
  AACfile.Free;
end;

end.
