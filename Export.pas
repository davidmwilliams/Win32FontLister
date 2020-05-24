UNIT Export;

// ============================================================================
INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ExtDlgs, ovceditf, ovcedpop, ovcedsld;

type
  TdlgJPEGExport = class(TForm)
    gbSample: TGroupBox;
    lblFontName: TLabel;
    cbBold: TSpeedButton;
    cbItalic: TSpeedButton;
    cbUnderline: TSpeedButton;
    cbStrikeout: TSpeedButton;
    eSample: TEdit;
    rgExportAs: TRadioGroup;
    bExport: TButton;
    bClose: TButton;
    dlgSavePicture: TSavePictureDialog;
    osePointSize: TOvcSliderEdit;

    procedure cbBoldClick(Sender: TObject);
    procedure cbItalicClick(Sender: TObject);
    procedure cbUnderlineClick(Sender: TObject);
    procedure cbStrikeoutClick(Sender: TObject);
    procedure osePointSizeChange(Sender: TObject);
    procedure bExportClick(Sender: TObject);

  private

  public
    procedure Execute (fntName: String);

  end;

var
  dlgJPEGExport: TdlgJPEGExport;

// ============================================================================
IMPLEMENTATION

USES
  Jpeg;
  
{$R *.DFM}

//------------------------------------------------------------------------------
procedure TdlgJPEGExport.Execute (fntName: String);
begin
  lblFontName.Caption := fntName;

  eSample.Font.Name := fntName;
  eSample.Font.Size := osePointSize.AsInteger;
  eSample.Font.Style := [];
  if cbBold.Down then
    eSample.Font.Style := eSample.Font.Style + [fsBold];
  if cbItalic.Down then
    eSample.Font.Style := eSample.Font.Style + [fsItalic];
  if cbUnderline.Down then
    eSample.Font.Style := eSample.Font.Style + [fsUnderline];
  if cbStrikeout.Down then
    eSample.Font.Style := eSample.Font.Style + [fsStrikeout];

  if eSample.Text = '' then
    eSample.Text := 'Hello';

  ShowModal
end;

//------------------------------------------------------------------------------
procedure TdlgJPEGExport.cbBoldClick(Sender: TObject);
begin
  if cbBold.Down then
    eSample.Font.Style := eSample.Font.Style + [fsBold]
  else
    eSample.Font.Style := eSample.Font.Style - [fsBold]
end;

//------------------------------------------------------------------------------
procedure TdlgJPEGExport.cbItalicClick(Sender: TObject);
begin
  if cbItalic.Down then
    eSample.Font.Style := eSample.Font.Style + [fsItalic]
  else
    eSample.Font.Style := eSample.Font.Style - [fsItalic]
end;

//------------------------------------------------------------------------------
procedure TdlgJPEGExport.cbUnderlineClick(Sender: TObject);
begin
  if cbUnderline.Down then
    eSample.Font.Style := eSample.Font.Style + [fsUnderline]
  else
    eSample.Font.Style := eSample.Font.Style - [fsUnderline]
end;

//------------------------------------------------------------------------------
procedure TdlgJPEGExport.cbStrikeoutClick(Sender: TObject);
begin
  if cbStrikeout.Down then
    eSample.Font.Style := eSample.Font.Style + [fsStrikeout]
  else
    eSample.Font.Style := eSample.Font.Style - [fsStrikeout]
end;

//------------------------------------------------------------------------------
procedure TdlgJPEGExport.osePointSizeChange(Sender: TObject);
begin
  eSample.Font.Size := osePointSize.AsInteger
end;

//------------------------------------------------------------------------------
procedure TdlgJPEGExport.bExportClick(Sender: TObject);
var
  theName, ext: String;
  MyBMP: TBitmap;
  MyJPEG: TJPEGImage;

begin
  if rgExportAs.ItemIndex = 0 then
    dlgSavePicture.DefaultExt := '.bmp'
  else
    dlgSavePicture.DefaultExt := '.jpg';

  if dlgSavePicture.Execute then
  begin
    theName := dlgSavePicture.FileName;

    MyBMP := TBitmap.Create;
    with MyBMP do begin
      Canvas.Font.Assign (eSample.Font);
      Width := Canvas.TextWidth (eSample.Text);
      Height := Canvas.TextHeight (eSample.Text);
      Canvas.TextOut (0, 0, eSample.Text)
    end;

    ext := lowercase (ExtractFileExt (theName));

    try
      if (ext = '.jpg') or (ext = '.jpeg') then
      begin
        MyJPEG := TJPEGImage.Create;
        with MyJPEG do
        begin
          Assign (MyBMP);
          SaveToFile (theName);
          Free
        end
      end
      else
        MyBMP.SaveToFile (theName);

    except
      ShowMessage ('Could not save to ' + theName)
    end;

    MyBMP.Free
  end
end;

END.
