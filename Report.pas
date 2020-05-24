UNIT Report;

// ============================================================================
INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, quickrpt, Qrctrls, StdCtrls;

const
  kTEXT_LEFT = 228;            // Default left position for main sample text
  kMARGIN = 4;                 // Margin spacing on either side
  kGUTTER = 4;                 // Gutter between columns (if using two cols)
  kLINESPACE = 4;              // Spacing between detail bands
  kBANDHEIGHT = 24;            // Default detail band height
  kTOPGUTTER = 4;              // ... for title, header and footer bands

type
  TfrmReport = class(TForm)
    qrFontRpt: TQuickRep;
    qbDetail: TQRBand;
    qrlText1: TQRLabel;
    qbHeader: TQRBand;
    qbFooter: TQRBand;
    sdDateTime: TQRSysData;
    sdPageNo: TQRSysData;
    qrlHeader: TQRLabel;
    qrlFontInfo: TQRLabel;
    qrlFontName1: TQRLabel;
    qrlFontName2: TQRLabel;
    qrlText2: TQRLabel;
    qbTitle: TQRBand;
    qrlTitle: TQRLabel;
    procedure qrFontRptBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure qrFontRptNeedData(Sender: TObject; var MoreData: Boolean);
    procedure qrFontRptPreview(Sender: TObject);
    procedure qrFontRptAfterPrint(Sender: TObject);
    procedure qrFontRptEndPage(Sender: TCustomQuickRep);

  private
    FontList: TStrings;
    FontIndex: integer;

    function GetSampleText (fntName: String): String;

  public

  end;

var
  frmReport: TfrmReport;

// ============================================================================
IMPLEMENTATION

USES
  Main, Printers, QRPreview, QRPrntr;

{$R *.DFM}

// ----------------------------------------------------------------------------
procedure TfrmReport.qrFontRptBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
var
  i: integer;

begin
    qbDetail.Height := kBANDHEIGHT;

    case frmAdvanced.rgPaperSize.ItemIndex of
        0: qrFontRpt.Page.PaperSize := A4;
        1: qrFontRpt.Page.PaperSize := A3;
        2: qrFontRpt.Page.PaperSize := Letter;
        3: qrFontRpt.Page.PaperSize := B5;
    end;

    if frmAdvanced.rgUnits.ItemIndex = 0 then
      qrFontRpt.Page.Units := MM
    else
      qrFontRpt.Page.Units := Inches;

    try qrFontRpt.Page.TopMargin := StrToFloat (frmAdvanced.eTop.Text)
    except end;
    try qrFontRpt.Page.BottomMargin := StrToFloat (frmAdvanced.eBottom.Text)
    except end;
    try qrFontRpt.Page.LeftMargin := StrToFloat (frmAdvanced.eLeft.Text)
    except end;
    try qrFontRpt.Page.RightMargin := StrToFloat (frmAdvanced.eRight.Text)
    except end;

    qrlText1.Font.Size := frmAdvanced.osePointSize.AsInteger;
    qrlText1.Font.Style := [];
    qrlFontInfo.Caption := 'Size ' + IntToStr (frmAdvanced.osePointSize.AsInteger);

    if frmAdvanced.cbBold.Down then
    begin
        qrlText1.Font.Style := [fsBold];
        qrlFontInfo.Caption := qrlFontInfo.Caption + ', bold';
    end;
    if frmAdvanced.cbItalic.Down then
    begin
        qrlText1.Font.Style := qrlText1.Font.Style + [fsItalic];
        qrlFontInfo.Caption := qrlFontInfo.Caption + ', italic';
    end;
    if frmAdvanced.cbUnderline.Down then
    begin
        qrlText1.Font.Style := qrlText1.Font.Style + [fsUnderline];
        qrlFontInfo.Caption := qrlFontInfo.Caption + ', underline';
    end;
    if frmAdvanced.cbStrikeout.Down then
    begin
        qrlText1.Font.Style := qrlText1.Font.Style + [fsStrikeout];
        qrlFontInfo.Caption := qrlFontInfo.Caption + ', strikeout';
    end;

    qrlText2.Font.Assign (qrlText1.Font);

    sdDateTime.Enabled := frmAdvanced.cbDateTime.Checked;
    sdPageNo.Enabled := frmAdvanced.cbPageNo.Checked;
    if sdDateTime.Enabled or sdPageNo.Enabled then
        qbFooter.Enabled := True
    else
        qbFooter.Enabled := False;

    qrFontRpt.PrinterSettings.PrinterIndex := frmAdvanced.cbPrinters.ItemIndex;

    if frmAdvanced.rgOrientation.ItemIndex = 0 then
        qrFontRpt.Page.Orientation := poPortrait
    else
        qrFontRpt.Page.Orientation := poLandscape;

    with qrlText1.Frame do
    begin
      DrawBottom := frmAdvanced.cbBorders.Checked;
      DrawLeft := frmAdvanced.cbBorders.Checked;
      DrawRight := frmAdvanced.cbBorders.Checked;
      DrawTop := frmAdvanced.cbBorders.Checked
    end;

    with qrlText2.Frame do
    begin
      DrawBottom := frmAdvanced.cbBorders.Checked;
      DrawLeft := frmAdvanced.cbBorders.Checked;
      DrawRight := frmAdvanced.cbBorders.Checked;
      DrawTop := frmAdvanced.cbBorders.Checked
    end;

    qrlFontInfo.Left := trunc (qbHeader.Width - qrlFontInfo.Width - (kMARGIN * 2));
    sdPageNo.Left := trunc (qbFooter.Width - sdPageNo.Width - (kMARGIN * 2));

    qrlFontName1.Left := kMARGIN;
    qrlFontName1.Top := kLINESPACE div 2;
    qrlText1.Top := qrlFontName1.Top;
// The following -kGUTTER has been chopped out because it causes the end
// of qrlText1 to run into the beginning of qrlFontName2
    qrlFontName2.Left := (qbDetail.Width - (kMARGIN * 2){- kGUTTER}) div 2;
    qrlFontName2.Top := qrlFontName1.Top;
    qrlText2.Top := qrlFontName1.Top;

    qrlFontName1.Enabled := frmAdvanced.cbFontName.Checked;
    qrlFontName2.Enabled := frmAdvanced.cbFontName.Checked;
    qrlFontName1.Visible := frmAdvanced.cbFontName.Checked;
    qrlFontName2.Visible := frmAdvanced.cbFontName.Checked;

    if frmAdvanced.cbFontName.Checked then
    begin
      qrlText1.Left := kTEXT_LEFT;
      qrlText2.Left := qrlFontName2.Left + kTEXT_LEFT + kMARGIN
    end
    else
    begin
      qrlText1.Left := qrlFontName1.Left;
      qrlText2.Left := qrlFontName2.Left
    end;

    if frmAdvanced.rgColumns.ItemIndex = 0 then
    begin
      qrlFontName2.Enabled := False;
      qrlFontName2.Visible := False;
      qrlText2.Enabled := False;
      qrlText2.Visible := False;
      qrlText1.Width := qbDetail.Width - qrlText1.Left - kMARGIN
    end
    else
    begin
      qrlText2.Enabled := True;
      qrlText2.Visible := True;
      qrlText1.Width := ((qbDetail.Width - kMARGIN) div 2) - qrlText1.Left - kGUTTER;
      qrlText2.Width := qrlText1.Width;
      if frmAdvanced.cbFontName.Checked then
        qrlFontName2.Width := qrlText2.Left - qrlFontName2.Left - kGUTTER
      else
        qrlFontName2.Width := 0
    end;

    if frmAdvanced.cbFontName.Checked then
      qrlFontName1.Width := qrlText1.Left - qrlFontName1.Left - 2
    else
      qrlFontName1.Width := 0;

    qbTitle.Enabled := frmAdvanced.cbTitle.Checked;
    qrlTitle.Caption := frmAdvanced.eTitleText.Text;

    if frmAdvanced.cbHeader.Checked and not frmAdvanced.cbSuppressHeader.Checked then
      qbHeader.Enabled := True
    else
      qbHeader.Enabled := False;
    qrlHeader.Caption := frmAdvanced.eHeaderText.Text;

    with qrlTitle do
    begin
      Font.Name := frmAdvanced.cbRTFontName.Items [frmAdvanced.cbRTFontName.ItemIndex];
      Font.Size := frmAdvanced.oseRTFontSize.AsInteger;
      Font.Style := [];
      if frmAdvanced.sbRTBold.Down then
        Font.Style := [fsBold];
      if frmAdvanced.sbRTItalic.Down then
        Font.Style := Font.Style + [fsItalic];
      if frmAdvanced.sbRTUnderline.Down then
        Font.Style := Font.Style + [fsUnderline];
      if frmAdvanced.sbRTStrikeout.Down then
        Font.Style := Font.Style + [fsStrikeout]
    end;
    qrlTitle.Top := kTOPGUTTER;
    qbTitle.Height := qrlTitle.Height + (kTOPGUTTER * 2);

    with qrlHeader do
    begin
      Font.Name := frmAdvanced.cbHFontName.Items [frmAdvanced.cbHFontName.ItemIndex];
      Font.Size := frmAdvanced.oseHFontSize.AsInteger;
      Font.Style := [];
      if frmAdvanced.sbHBold.Down then
        Font.Style := [fsBold];
      if frmAdvanced.sbHItalic.Down then
        Font.Style := Font.Style + [fsItalic];
      if frmAdvanced.sbHUnderline.Down then
        Font.Style := Font.Style + [fsUnderline];
      if frmAdvanced.sbHStrikeout.Down then
        Font.Style := Font.Style + [fsStrikeout]
    end;
    qrlFontInfo.Font.Assign (qrlHeader.Font);
    qrlHeader.Top := kTOPGUTTER;
    qrlFontInfo.Top := kTOPGUTTER;
    qbHeader.Height := qrlHeader.Height + (kTOPGUTTER * 2);

    with sdDateTime do
    begin
      Font.Name := frmAdvanced.cbFFontName.Items [frmAdvanced.cbFFontName.ItemIndex];
      Font.Size := frmAdvanced.oseFFontSize.AsInteger;
      Font.Style := [];
      if frmAdvanced.sbFBold.Down then
        Font.Style := [fsBold];
      if frmAdvanced.sbFItalic.Down then
        Font.Style := Font.Style + [fsItalic];
      if frmAdvanced.sbFUnderline.Down then
        Font.Style := Font.Style + [fsUnderline];
      if frmAdvanced.sbFStrikeout.Down then
        Font.Style := Font.Style + [fsStrikeout]
    end;
    sdPageNo.Font.Assign (sdDateTime.Font);
    sdDateTime.Top := kTOPGUTTER;
    sdPageNo.Top := kTOPGUTTER;
    qbFooter.Height := sdPageNo.Height + (kTOPGUTTER * 2);

    qrlFontInfo.Enabled := frmAdvanced.cbListChars.Enabled;

    qrFontRpt.PrinterSettings.FirstPage := frmAdvanced.oseFirstPage.AsInteger;

    FontIndex := 0;
    FontList := TStringList.Create;
    for i := 0 to frmAdvanced.clbFonts.Items.Count - 1 do
      if frmAdvanced.cbAllFonts.Checked or frmAdvanced.clbFonts.Checked [i] then
        FontList.Add (frmAdvanced.clbFonts.Items [i])
end;

// ----------------------------------------------------------------------------
procedure TfrmReport.qrFontRptNeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  if FontIndex >= FontList.Count then
    MoreData := False
  else
  begin
// Reset the font height
    qrlText1.Height := 0;
    qrlText2.Height := 0;

// Process the first column
    qrlText1.Font.Name := FontList [FontIndex];
    qrlText1.Caption := GetSampleText (FontList [FontIndex]);

    if frmAdvanced.cbFontName.Checked then
      qrlFontName1.Caption := FontList [FontIndex];

    if frmAdvanced.cbFontName.Checked and (qrlText1.Height < qrlFontName1.Height) then
      qbDetail.Height := qrlFontName1.Height + kLINESPACE
    else
      qbDetail.Height := qrlText1.Height + kLINESPACE;

    Inc (FontIndex);

// Process the second column
    if (FontIndex < FontList.Count) and (frmAdvanced.rgColumns.ItemIndex = 1) then
    begin
      qrlText2.Font.Name := FontList [FontIndex];
      qrlText2.Caption := GetSampleText (FontList [FontIndex]);
      if frmAdvanced.cbFontName.Checked then
        qrlFontName2.Caption := FontList [FontIndex];
      if qbDetail.Height < (qrlText2.Height + kLINESPACE) then
        qbDetail.Height := qrlText2.Height + kLINESPACE;
      Inc (FontIndex);
    end;

    MoreData := True
  end;

  if not MoreData then
    RptPreviewFrm.Finish
  else
    RptPreviewFrm.pgbReport.Position := Trunc ((FontIndex / FontList.Count) * 100)
end;

// ----------------------------------------------------------------------------
procedure TfrmReport.qrFontRptPreview(Sender: TObject);
begin
  with RptPreviewFrm do
  begin
    RptPreview.QRPrinter := TQRPrinter (Sender);
    Show
  end
end;

// ----------------------------------------------------------------------------
procedure TfrmReport.qrFontRptAfterPrint(Sender: TObject);
begin
  if not frmAdvanced.cbAllFonts.Checked then
    FontList.Free
end;

// ----------------------------------------------------------------------------
function TfrmReport.GetSampleText (fntName: String): String;
var
  i: integer;
  preMessage: String;

begin
  preMessage := frmAdvanced.mMessage.Text;

  Result := '';
  i := 1;
  while i <= Length (preMessage) do
  begin
    if ((Length (preMessage) > i) and
      (preMessage [i] = '%') and
      (preMessage [i + 1] = 'f')) then
    begin
      Result := Result + fntName;
      Inc (i)
    end
    else if ((Length (preMessage) > i) and
      (preMessage [i] = '%') and
      (preMessage [i + 1] = 'F')) then
    begin
      Result := Result + UpperCase (fntName);
      Inc (i)
    end
    else
      Result := Result + preMessage [i];

    Inc (i)
  end
end;

// ----------------------------------------------------------------------------
procedure TfrmReport.qrFontRptEndPage(Sender: TCustomQuickRep);
begin
  qbHeader.Enabled := frmAdvanced.cbHeader.Checked
end;

END.

