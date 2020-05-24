UNIT ViewCharSet;

// ============================================================================
INTERFACE

USES
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ovceditf, ovcedpop, ovcedsld;

type
  TdlgViewCharacterSet = class(TForm)
    lblFontName: TLabel;
    cbItalic: TSpeedButton;
    cbBold: TSpeedButton;
    cbUnderline: TSpeedButton;
    cbStrikeout: TSpeedButton;
    bClose: TButton;
    eSample: TMemo;
    cbASCIIcodes: TCheckBox;
    dgSample: TDrawGrid;
    osePointSize: TOvcSliderEdit;

    procedure osePointSizeChange(Sender: TObject);
    procedure cbBoldClick(Sender: TObject);
    procedure cbItalicClick(Sender: TObject);
    procedure cbUnderlineClick(Sender: TObject);
    procedure cbStrikeoutClick(Sender: TObject);
    procedure cbASCIIcodesClick(Sender: TObject);
    procedure dgSampleDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);

  private

  public
    procedure Execute (fntName: String);

  end;

var
  dlgViewCharacterSet: TdlgViewCharacterSet;

// ============================================================================
IMPLEMENTATION

{$R *.dfm}

//------------------------------------------------------------------------------
procedure TdlgViewCharacterSet.Execute (fntName: String);
var
  i: integer;

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

  eSample.Text := '';
  for i := 0 to 255 do
    eSample.Text := eSample.Text + chr (i);

  dgSample.Visible := cbASCIIcodes.Checked;
  eSample.Visible := not cbASCIIcodes.Checked;

  ShowModal
end;

//------------------------------------------------------------------------------
procedure TdlgViewCharacterSet.osePointSizeChange(Sender: TObject);
begin
  eSample.Font.Size := osePointSize.AsInteger;
  dgSample.Refresh
end;

//------------------------------------------------------------------------------
procedure TdlgViewCharacterSet.cbBoldClick(Sender: TObject);
begin
  if cbBold.Down then
    eSample.Font.Style := eSample.Font.Style + [fsBold]
  else
    eSample.Font.Style := eSample.Font.Style - [fsBold];
  dgSample.Refresh
end;

//------------------------------------------------------------------------------
procedure TdlgViewCharacterSet.cbItalicClick(Sender: TObject);
begin
  if cbItalic.Down then
    eSample.Font.Style := eSample.Font.Style + [fsItalic]
  else
    eSample.Font.Style := eSample.Font.Style - [fsItalic];
  dgSample.Refresh
end;

//------------------------------------------------------------------------------
procedure TdlgViewCharacterSet.cbUnderlineClick(Sender: TObject);
begin
  if cbUnderline.Down then
    eSample.Font.Style := eSample.Font.Style + [fsUnderline]
  else
    eSample.Font.Style := eSample.Font.Style - [fsUnderline];
  dgSample.Refresh
end;

//------------------------------------------------------------------------------
procedure TdlgViewCharacterSet.cbStrikeoutClick(Sender: TObject);
begin
  if cbStrikeout.Down then
    eSample.Font.Style := eSample.Font.Style + [fsStrikeout]
  else
    eSample.Font.Style := eSample.Font.Style - [fsStrikeout];
  dgSample.Refresh
end;

//------------------------------------------------------------------------------
procedure TdlgViewCharacterSet.cbASCIIcodesClick(Sender: TObject);
begin
  dgSample.Visible := cbASCIIcodes.Checked;
  eSample.Visible := not cbASCIIcodes.Checked
end;

//------------------------------------------------------------------------------
procedure TdlgViewCharacterSet.dgSampleDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  ValNo: integer;

begin
  if ACol < 2 then
    ValNo := ARow
  else if ACol < 4 then
    ValNo := ARow + 64
  else if ACol < 6 then
    ValNo := ARow + 128
  else
    ValNo := ARow + 192;

  with dgSample.Canvas do
  if (ACol mod 2 = 0) then
  // Standard cell
  begin
    Font.Name := 'Arial';
    Font.Size := 10;
    Font.Style := [];
    TextOut (Rect.Left + 1, Rect.Top + 1, IntToStr (ValNo))
  end
  else
  // Sample cell
  begin
    Font.Name := lblFontName.Caption;
    Font.Size := osePointSize.AsInteger;
    Font.Style := [];

    if cbBold.Down then
      Font.Style := [fsBold];
    if cbItalic.Down then
      Font.Style := Font.Style + [fsItalic];
    if cbUnderline.Down then
      Font.Style := Font.Style + [fsUnderline];
    if cbStrikeout.Down then
      Font.Style := Font.Style + [fsStrikeout];

    TextOut (Rect.Left + 1, Rect.Top + 1, chr (ValNo))
  end
end;

END.
