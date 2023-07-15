unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure log(s: string);
    procedure ID3v1(Filename: string);
    procedure ID3v2(Filename: string);
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.IOUtils,
  ID3v1,
  ID3v2;

procedure TForm1.Button1Click(Sender: TObject);
var
  Files: TStringDynArray;
  i: integer;
begin
  Files := tdirectory.GetFiles(tpath.GetMusicPath, '*.mp3');
  for i := 0 to length(Files) - 1 do
    ID3v1(Files[i]);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Files: TStringDynArray;
  i: integer;
begin
  Files := tdirectory.GetFiles(tpath.GetMusicPath, '*.mp3');
  for i := 0 to length(Files) - 1 do
    ID3v2(Files[i]);
end;

procedure TForm1.ID3v1(Filename: string);
var
  id3: TID3v1;
begin
  log(Filename);
  id3 := TID3v1.Create;
  try
    if id3.ReadFromFile(Filename) then
      if id3.Exists then
      begin
        log('Yes');
        if id3.VersionID = TAG_VERSION_1_0 then
          log('1.0')
        else
          log('1.1');
        log('Title : ' + id3.Title);
        log('Artist : ' + id3.Artist);
        log('Album : ' + id3.Album);
        log('Track : ' + id3.Track.tostring);
        log('Year : ' + id3.Year);
        log('Genre ID : ' + id3.GenreID.tostring);
        log('Comment : ' + id3.Comment);
      end
      else
        log('No');
  finally
    id3.Free;
  end;
  log('--------------------');
  log('');
end;

procedure TForm1.ID3v2(Filename: string);
var
  id3: TID3v2;
begin
  log(Filename);
  id3 := TID3v2.Create;
  try
    if id3.ReadFromFile(Filename) then
      if id3.Exists then
      begin
        log('Yes');
        log('Version : 2.' + id3.VersionID.tostring);
        log('Size : ' + id3.Size.tostring + ' bytes');
        log('Title : ' + id3.Title);
        log('Artist : ' + id3.Artist);
        log('Album : ' + id3.Album);
        log('Track : ' + id3.Track.tostring);
        log('Year : ' + id3.Year);
        log('Genre : ' + id3.Genre);
        log('Comment : ' + id3.Comment);
        log('Composer : ' + id3.Composer);
        log('Encoder : ' + id3.Encoder);
        log('Copyright : ' + id3.Copyright);
        log('Language : ' + id3.Language);
        log('Link : ' + id3.Link);
      end
      else
        log('No');
  finally
    id3.Free;
  end;
  log('--------------------');
  log('');
end;

procedure TForm1.log(s: string);
begin
  Memo1.Lines.Add(s);
end;

end.
