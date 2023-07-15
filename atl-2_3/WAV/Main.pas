unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, WAVfile, ComCtrls, ShellCtrls;

type
  TMainForm = class(TForm)
    CloseButton: TButton;
    InfoBevel: TBevel;
    IconImage: TImage;
    ValidHeaderLabel: TLabel;
    FileSizeLabel: TLabel;
    ValidHeaderText: TEdit;
    ChannelModeText: TEdit;
    ChannelModeLabel: TLabel;
    SampleRateLabel: TLabel;
    BitsPerSampleLabel: TLabel;
    DurationLabel: TLabel;
    SampleRateText: TEdit;
    BitsPerSampleText: TEdit;
    DurationText: TEdit;
    FileSizeText: TEdit;
    FormatLabel: TLabel;
    FormatText: TEdit;
    BytesPerSecondLabel: TLabel;
    BytesPerSecondText: TEdit;
    BlockAlignLabel: TLabel;
    BlockAlignText: TEdit;
    HeaderSizeLabel: TLabel;
    HeaderSizeText: TEdit;
    lblTrimBegin: TLabel;
    edtTrimBegin: TEdit;
    btnWriteEnd: TButton;
    lblTrimEnd: TLabel;
    edtSamples: TEdit;
    lblSamples: TLabel;
    btnWriteBegin: TButton;
    edtTrimEnd: TEdit;
    btnFindEnd: TButton;
    btnFindBegin: TButton;
    lblMod588: TLabel;
    edtMod588: TEdit;
    lblFormatSize: TLabel;
    edtFormatSize: TEdit;
    lblChannels: TLabel;
    edtChannels: TEdit;
    ShellTreeView: TShellTreeView;
    procedure FormShow(Sender: TObject);
    procedure ShellTreeViewClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnWriteBeginClick(Sender: TObject);
    procedure btnWriteEndClick(Sender: TObject);
    procedure btnFindBeginClick(Sender: TObject);
    procedure btnFindEndClick(Sender: TObject);
    procedure edtTrimBeginChange(Sender: TObject);
    procedure edtTrimEndChange(Sender: TObject);
  private
    { Private declarations }
    WAVfile: TWAVfile;
    procedure ClearAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}
      
{ --------------------------------------------------------------------------- }

procedure TMainForm.ClearAll;
begin
  { Clear all captions }
  ValidHeaderText.Text := '';
  FormatText.Text := '';
  ChannelModeText.Text := '';
  SampleRateText.Text := '';
  BytesPerSecondText.Text := '';
  BlockAlignText.Text := '';
  BitsPerSampleText.Text := '';
  HeaderSizeText.Text := '';
  FileSizeText.Text := '';
  edtFormatSize.Text := '';
  edtChannels.Text := '';
  DurationText.Text := '';
  edtSamples.Text := '';
  edtMod588.Text := '';
  edtTrimBegin.Text := '';
  edtTrimEnd.Text := '';
end;
       
{ --------------------------------------------------------------------------- }

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  { Exit }
  Close;
end;
    
{ --------------------------------------------------------------------------- }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object }
  WAVfile := TWAVfile.Create;
  { Reset captions }
  ClearAll;
end;

{ --------------------------------------------------------------------------- }

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Free memory }
  WAVfile.Free;
end;
      
{ --------------------------------------------------------------------------- }

procedure TMainForm.edtTrimBeginChange(Sender: TObject);
begin
  btnWriteBegin.Enabled := True;
end;
      
{ --------------------------------------------------------------------------- }

procedure TMainForm.edtTrimEndChange(Sender: TObject);
begin
  btnWriteEnd.Enabled := True;
end;

{ --------------------------------------------------------------------------- }

procedure TMainForm.btnWriteBeginClick(Sender: TObject);
begin
  // writes the new values
  WAVfile.TrimFromBeginning(StrToInt(edtTrimBegin.Text));
  btnWriteBegin.Enabled := False;
end;

{ --------------------------------------------------------------------------- }

procedure TMainForm.btnWriteEndClick(Sender: TObject);
begin
  // writes the new values and trims the end
  WAVfile.TrimFromEnd(StrToInt(edtTrimEnd.Text));
  btnWriteEnd.Enabled := False;
end;

{ --------------------------------------------------------------------------- }

procedure TMainForm.btnFindBeginClick(Sender: TObject);
begin
  WAVfile.FindSilence(True, False);
  edtTrimBegin.Text := IntToStr(WAVfile.AmountTrimBegin);
end;

{ --------------------------------------------------------------------------- }

procedure TMainForm.btnFindEndClick(Sender: TObject);
begin
  WAVfile.FindSilence(False, True);
  edtTrimEnd.Text := IntToStr(WAVfile.AmountTrimEnd);
end;

{ --------------------------------------------------------------------------- }

procedure TMainForm.ShellTreeViewClick(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  { Load WAV header }
  if (LowerCase(ExtractFileExt(ShellTreeView.Path)) = '.wav') and WAVfile.ReadFromFile(ShellTreeView.Path) then
    if WAVfile.Valid then
    begin
      { Fill captions }
      ValidHeaderText.Text := 'Yes';
      FormatText.Text := WAVfile.Format;
      ChannelModeText.Text := WAVfile.ChannelMode;
      SampleRateText.Text := IntToStr(WAVfile.SampleRate) + ' hz';
      BytesPerSecondText.Text := IntToStr(WAVfile.BytesPerSecond) + ' bytes, ' + IntToStr(WAVfile.BytesPerSecond * 8 div 1000) + 'kbps';
      BlockAlignText.Text := IntToStr(WAVfile.BlockAlign) + ' bytes';
      BitsPerSampleText.Text := IntToStr(WAVfile.BitsPerSample) + ' bit';
      HeaderSizeText.Text := IntToStr(WAVfile.HeaderSize) + ' bytes';
      FileSizeText.Text := IntToStr(WAVfile.FileSize) + ' bytes';
      edtFormatSize.Text := IntToStr(WAVfile.FormatSize);
      edtChannels.Text := IntToStr(WAVfile.ChannelNumber);
      DurationText.Text := FormatFloat('.000', WAVfile.Duration) + ' sec.';
      edtSamples.Text := IntToStr(WAVfile.SampleNumber);
      edtMod588.Text := IntToStr(WAVfile.SampleNumber mod 588);
    end
    else
      { Header not found }
      ValidHeaderText.Text := 'No';

  btnWriteBegin.Enabled := False;
  btnWriteEnd.Enabled := False;
  btnFindBegin.Enabled := True;
  btnFindEnd.Enabled := True;
end;

{ --------------------------------------------------------------------------- }

procedure TMainForm.FormShow(Sender: TObject);
begin
  ShellTreeView.SetFocus;
end;
      
{ --------------------------------------------------------------------------- }

end.
