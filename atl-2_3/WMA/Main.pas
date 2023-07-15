unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, ExtCtrls, WMAfile, ComCtrls, ShellCtrls;

type
  TMainForm = class(TForm)
    CloseButton: TButton;
    InfoBevel: TBevel;
    IconImage: TImage;
    ValidDataLabel: TLabel;
    FileSizeLabel: TLabel;
    ValidDataText: TEdit;
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
    ArtistText: TEdit;
    TrackText: TEdit;
    AlbumText: TEdit;
    TitleLabel: TLabel;
    CommentLabel: TLabel;
    ArtistLabel: TLabel;
    TrackLabel: TLabel;
    AlbumLabel: TLabel;
    YearText: TEdit;
    YearLabel: TLabel;
    GenreLabel: TLabel;
    GenreText: TEdit;
    ShellTreeView: TShellTreeView;
    lblEncoder: TLabel;
    edtEncoder: TEdit;
    lblBits: TLabel;
    edtBits: TEdit;
    procedure ShellTreeViewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    WMAfile: TWMAfile;
    procedure ClearAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ClearAll;
begin
  { Clear all captions }
  ValidDataText.Text := '';
  FileSizeText.Text := '';
  ChannelModeText.Text := '';
  SampleRateText.Text := '';
  DurationText.Text := '';
  BitRateText.Text := '';
  TitleText.Text := '';
  ArtistText.Text := '';
  AlbumText.Text := '';
  TrackText.Text := '';
  YearText.Text := '';
  GenreText.Text := '';
  CommentText.Text := '';
  edtEncoder.Text := '';
  edtBits.Text := '';
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  { Exit }
  Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  { Create object and clear captions }
  WMAfile := TWMAfile.Create;
  ClearAll;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Free memory }
  WMAfile.Free;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  ShellTreeView.SetFocus;
end;

procedure TMainForm.ShellTreeViewClick(Sender: TObject);
begin
  { Clear captions }
  ClearAll;
  if (LowerCase(ExtractFileExt(ShellTreeView.Path)) = '.wma') then
    { Load file data }
    if WMAfile.ReadFromFile(ShellTreeView.Path) then
      if WMAfile.Valid then
      begin
        { Fill captions }
        ValidDataText.Text := 'Yes';
        FileSizeText.Text := IntToStr(WMAfile.FileSize) + ' bytes';
        ChannelModeText.Text := WMAfile.ChannelMode;
        SampleRateText.Text := IntToStr(WMAfile.SampleRate) + ' hz';
        DurationText.Text := FormatFloat('.000', WMAfile.Duration) + ' sec.';
        BitRateText.Text := IntToStr(WMAfile.BitRate) + ' kbit';
        TitleText.Text := WMAfile.Title;
        ArtistText.Text := WMAfile.Artist;
        AlbumText.Text := WMAfile.Album;
        TrackText.Text := WMAfile.TrackString;
        YearText.Text := WMAfile.Year;
        GenreText.Text := WMAfile.Genre;
        CommentText.Text := WMAfile.Comment;
        edtEncoder.Text := WMAfile.Codec;
        edtBits.Text := IntToStr(WMAfile.Bits);
      end
      else
        { Data not valid }
        ValidDataText.Text := 'No';
end;

end.
