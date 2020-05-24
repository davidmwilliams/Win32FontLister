UNIT Main;
(*

  Win 32 Font lister

    by David M. Williams
       Computer Consultant
       ap_dmw@bigpond.com
       http://www.geocities.com/rankinlibs/listfonts.zip

 *)

// ============================================================================
INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, Grids, checklst, Menus,
  Wizard, Advanced;

// {$D E FINE BETA}
// {$ D E FINE PRINTSCREENPRINTS}
// {$ D E FINE REGISTERED}

const
  App_Name = 'Listfonts';
  Secret_Name = 'IEDLL';
  Version_Number = '4.0';
  kAdvanced = 'Advanced...';
  kWizard = 'Wizard...';

{$IFDEF BETA}
  Beta_Expiry = '31st of August, 2003';
  Expire_Day = 31;
  Expire_Month = 8;
  Expire_Year = 2003;
{$ENDIF}

{$IFDEF PRINTSCREENPRINTS}
  id_SnapShot = 101;
{$ENDIF}

type
  TfrmMain = class(TForm)
    bAbout: TButton;
    bClose: TButton;
    bPreview: TButton;
    bPrint: TButton;
    Bevel1: TBevel;
    Label3: TLabel;
    lblAuthor: TLabel;
    lblTitle: TLabel;
    bAdvanced: TButton;
    pnlBackground: TPanel;
    bRegister: TButton;

    procedure bPrintClick(Sender: TObject);
    procedure bPreviewClick(Sender: TObject);
    procedure bRegisterClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bAdvancedClick(Sender: TObject);
    procedure bAboutClick(Sender: TObject);
    procedure bCloseClick(Sender: TObject);

  private
    RegName: String;

    procedure SetupTheDisplay;
    procedure SetupAdvancedMode;
    procedure SetupWizardMode;
    procedure SetRegistered (RegName: String);
    procedure WMNCHitTest (var Msg: TWMNCHitTest); message wm_NCHitTest;
{$IFDEF PRINTSCREENPRINTS}
    procedure WMHotKey (var Msg: TWMHotKey); message WM_HOTKEY;
{$ENDIF}
    procedure GetHintInfo (var HintStr: string; var CanShow: boolean;
                           var HintInfo: THintInfo);
  public
    procedure SetButtons;

  end;

var
  frmMain: TfrmMain;
  frmWizard: TfrmWizard;
  frmAdvanced: TfrmAdvanced;
  DontDoIt: boolean;

// ============================================================================
IMPLEMENTATION

USES
  Report, About, WinReg, uRegister, uPrevInstance, ShellAPI, QRPreview,
  Printers;

{$R *.DFM}

//------------------------------------------------------------------------------
procedure TfrmMain.bCloseClick(Sender: TObject);
begin
  Close
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.bPrintClick(Sender: TObject);
begin
  Application.CreateForm(TfrmReport, frmReport);
  frmReport.qrFontRpt.Print;
  frmReport.Free
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.bPreviewClick(Sender: TObject);
begin
  Application.CreateForm(TfrmReport, frmReport);
  frmReport.qrFontRpt.Preview;
  frmReport.Free
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.bAboutClick(Sender: TObject);
begin
  frmAbout.ShowModal
end;

//------------------------------------------------------------------------------
procedure TfrmMain.bRegisterClick(Sender: TObject);
var
  RegName: String;

begin
  if RegisterDlg.Execute (App_Name, Secret_Name, RegName) then
    SetRegistered (RegName)
end;

//------------------------------------------------------------------------------
procedure TfrmMain.SetRegistered (RegName: String);
begin
  bRegister.Visible := False;
  frmAbout.lblReg1.Caption := 'Registered to:';
  frmAbout.lblReg2.Caption := RegName
end;

//------------------------------------------------------------------------------
procedure TfrmMain.FormShow(Sender: TObject);
var
  S: String;
  Reg: TWinRegistry;

begin
  if not DontDoIt then
  begin
    frmWizard := TfrmWizard.Create (pnlBackground);
    frmWizard.Parent := pnlBackground;
    frmAdvanced := TfrmAdvanced.Create (pnlBackground);
    frmAdvanced.Parent := pnlBackground;

    Reg := TWinRegistry.Create ('Software\FontLister');
    with frmAdvanced do
    with Reg do
    begin
      mMessage.Text := ReadString ('ListingProperties', 'Message', 'This is %f');
      cbFontName.Checked := ReadBool ('ListingProperties', 'FontName', True);
      cbTitle.Checked := ReadBool ('ListingProperties', 'TitleHeader', True);
      eTitleText.Text := ReadString ('ListingProperties', 'TitleText', 'Win32 Font Lister');
      cbHeader.Checked := ReadBool ('ListingProperties', 'DisplayHeader', True);
      eHeaderText.Text := ReadString ('ListingProperties', 'HeaderText', 'Windows font list');
      cbListChars.Checked := ReadBool ('ListingProperties', 'ListChars', True);
      cbSuppressHeader.Checked := ReadBool ('ListingProperties', 'SuppressHeader', True);
      cbDateTime.Checked := ReadBool ('ListingProperties', 'DateTime', True);
      cbPageNo.Checked := ReadBool ('ListingProperties', 'PageNo', True);
      oseFirstPage.AsInteger := ReadInteger ('ListingProperties', 'FirstPage', 1);
      try
        cbPrinters.ItemIndex := ReadInteger
            ('PageLayout', 'PrinterIndex', Printer.PrinterIndex);
      except
      end;
      rgOrientation.ItemIndex := ReadInteger ('PageLayout', 'Orientation', 0);
      osePointSize.AsInteger := ReadInteger ('PageLayout', 'PointSize', 12);
      cbBold.Down := ReadBool ('PageLayout', 'Bold', False);
      cbItalic.Down := ReadBool ('PageLayout', 'Italic', False);
      cbUnderline.Down := ReadBool ('PageLayout', 'Underline', False);
      cbStrikeout.Down := ReadBool ('PageLayout', 'Strikeout', False);
      rgPaperSize.ItemIndex := ReadInteger ('PageLayout', 'PaperSize', 2);
      rgUnits.ItemIndex := ReadInteger ('PageLayout', 'Units', 0);
      OldUnits := rgUnits.ItemIndex;
      eTop.Text := ReadString ('PageLayout', 'Top', '10.0');
      eBottom.Text := ReadString ('PageLayout', 'Bottom', '15.0');
      eLeft.Text := ReadString ('PageLayout', 'Left', '10.0');
      eRight.Text := ReadString ('PageLayout', 'Right', '10.0');
      rgColumns.ItemIndex := ReadInteger ('PageLayout', 'Columns', 0);
      cbMinimise.Checked := ReadBool ('Options', 'StartMinimised', False);
      cbBorders.Checked := ReadBool ('Options', 'UseBorders', False);
      rgStartup.ItemIndex := ReadInteger ('Options', 'Startup', 0);
      S := ReadString ('HeaderFooter', 'RTFontName', 'Arial');
      cbRTFontName.ItemIndex := cbRTFontName.Items.IndexOf (S);
      oseRTFontSize.AsInteger := ReadInteger ('HeaderFooter', 'RTFontSize', 14);
      sbRTBold.Down := ReadBool ('HeaderFooter', 'RTBold', True);
      sbRTItalic.Down := ReadBool ('HeaderFooter', 'RTItalic', False);
      sbRTUnderline.Down := ReadBool ('HeaderFooter', 'RTUnderline', False);
      sbRTStrikeout.Down := ReadBool ('HeaderFooter', 'RTStrikeout', False);
      S := ReadString ('HeaderFooter', 'HFontName', 'Arial');
      cbHFontName.ItemIndex := cbHFontName.Items.IndexOf (S);
      oseHFontSize.AsInteger := ReadInteger ('HeaderFooter', 'HFontSize', 8);
      sbHBold.Down := ReadBool ('HeaderFooter', 'HBold', False);
      sbHItalic.Down := ReadBool ('HeaderFooter', 'HItalic', False);
      sbHUnderline.Down := ReadBool ('HeaderFooter', 'HUnderline', False);
      sbHStrikeout.Down := ReadBool ('HeaderFooter', 'HStrikeout', False);
      S := ReadString ('HeaderFooter', 'FFontName', 'Arial');
      cbFFontName.ItemIndex := cbFFontName.Items.IndexOf (S);
      oseFFontSize.AsInteger := ReadInteger ('HeaderFooter', 'FFontSize', 8);
      sbFBold.Down := ReadBool ('HeaderFooter', 'FBold', False);
      sbFItalic.Down := ReadBool ('HeaderFooter', 'FItalic', False);
      sbFUnderline.Down := ReadBool ('HeaderFooter', 'FUnderline', False);
      sbFStrikeout.Down := ReadBool ('HeaderFooter', 'FStrikeout', False)
    end;

    Reg.Free;

    if frmAdvanced.cbMinimise.Checked then
      WindowState := wsMinimized;
    frmAbout.lblCaption.Caption := Caption;

{$IFDEF REGISTERED}
    SetRegistered ('Debug version');
{$ELSE}
    if RegisterDlg.isRegistered (App_Name, Secret_Name, RegName) then
      SetRegistered (RegName);
{$ENDIF}

    SetupTheDisplay
  end
end;

//------------------------------------------------------------------------------
procedure TfrmMain.SetupTheDisplay;
begin
  if frmAdvanced.rgStartup.ItemIndex = 0 then
    SetupWizardMode
  else
    SetupAdvancedMode
end;

//------------------------------------------------------------------------------
procedure TfrmMain.SetupWizardMode;
begin
  with frmWizard do
  with frmAdvanced do
  begin
    cbWizPrinters.Items.Assign (cbPrinters.Items);
    cbWizPrinters.ItemIndex := cbPrinters.ItemIndex;
    mWizMessage.Text := mMessage.Text;
    rgWizColumns.ItemIndex := rgColumns.ItemIndex;
    cbWizFontName.Checked := cbFontName.Checked;
    cbWizTitle.Checked := cbTitle.Checked;
    eWizTitleText.Text := eTitleText.Text;
    cbWizDateTime.Checked := cbDateTime.Checked;
    cbWizPageNo.Checked := cbPageNo.Checked;
    bAdvanced.Caption := kAdvanced;
    bPrint.Visible := False;
    bPreview.Visible := False;
    bPrev.Enabled := False;
    bNext.Enabled := True;
    pgWizard.ActivePage := tsPage1;
    frmAdvanced.Visible := False;
    frmWizard.Visible := True
  end
end;

//------------------------------------------------------------------------------
procedure TfrmMain.SetupAdvancedMode;
begin
  bAdvanced.Caption := kWizard;
  bPrint.Visible := True;
  bPreview.Visible := True;
  frmWizard.Visible := False;
  with frmAdvanced do
  begin
    pgFontLister.ActivePage := tsFonts;
    cbAllFontsClick (Self)
  end;
  frmAdvanced.Visible := True;
end;

//------------------------------------------------------------------------------
procedure TfrmMain.bAdvancedClick(Sender: TObject);
begin
  if bAdvanced.Caption = kAdvanced then
  begin
    Screen.Cursor := crHourGlass;
    SetupAdvancedMode;
    Screen.Cursor := crDefault
  end
  else
    SetupWizardMode
end;

//------------------------------------------------------------------------------
procedure TfrmMain.SetButtons;
begin
  if frmAdvanced.cbAllFonts.State = cbUnchecked then
  begin
    bPrint.Enabled := False;
    bPreview.Enabled := False;
  end
  else
  begin
    bPrint.Enabled := True;
    bPreview.Enabled := True;
  end
end;

//------------------------------------------------------------------------------
procedure TfrmMain.FormCreate(Sender: TObject);
{$IFDEF BETA}
var
  Present, Expire: TDateTime;
  lpBuffer: _MEMORYSTATUS;
{$ENDIF}

begin
  LookForPreviousInstance;

{$IFDEF BETA}
  Present := Now;
  Expire := EncodeDate (Expire_Year, Expire_Month, Expire_Day);
  if Expire <= Present then
  begin
    ShowMessage ('Sorry, this beta software has expired. Please visit' + #13 +
                 'http://qed.newcastle.edu.au/intelligent' + #13 +
                 'for a newer version.');
    Halt;
  end;

  ShowMessage ('This is beta software. It may not reflect the' + #13 +
               'final version and some functions may not work yet.' + #13 +
               'This version will expire on the ' + Beta_Expiry + '.');
  GlobalMemoryStatus (lpBuffer);
  ShowMessage ('You have ' + IntToStr (lpBuffer.dwTotalPhys) + ' RAM, with ' +
               IntToStr (lpBuffer.dwAvailPhys) + ' available. The load is ' +
               IntToStr (lpBuffer.dwMemoryLoad) + '.');
{$ENDIF}

  Application.OnShowHint := GetHintInfo;
{$IFDEF PRINTSCREENPRINTS}
  RegisterHotKey (Handle, id_SnapShot, 0, VK_SNAPSHOT);
{$ENDIF}

  DontDoIt := False;

  Caption := Application.Title + ' - ver. ' + Version_Number;
  lblTitle.Caption := Application.Title
end;

//------------------------------------------------------------------------------
procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  frmAdvanced.RemoveFonts;

  frmWizard.Release;
  frmWizard := nil;
  frmAdvanced.Release;
  frmAdvanced := nil;

{$IFDEF PRINTSCREENPRINTS}
  UnRegisterHotKey (Handle, id_SnapShot);
{$ENDIF}
  EnableOtherInstances
end;

//------------------------------------------------------------------------------
procedure TfrmMain.WMNCHitTest (var Msg: TWMNCHitTest);
// This routine allows a user to drag the form about by clicking anywhere,
// not just on the title bar. This works by fooling Windows and telling it
// that the mouse is in the caption area even though it is in the client area.
begin
  inherited;
  if (Msg.Result = htClient) then
    Msg.Result := htCaption
end;

{$IFDEF PRINTSCREENPRINTS}
//------------------------------------------------------------------------------
procedure TfrmMain.WMHotKey (var Msg: TWMHotKey);
// Catch the print screen key and turn it into a print request.
begin
  if Msg.HotKey = id_SnapShot then
    bPrintClick (Self)
end;
{$ENDIF}

//------------------------------------------------------------------------------
procedure TfrmMain.GetHintInfo (var HintStr: string; var CanShow: boolean;
                                var HintInfo: THintInfo);
// Display a nicer hint message than standard.
var
  II: TIconInfo;
  Bmp: Windows.TBitmap;

begin
  with HintInfo do begin
    // Make sure we have a control that fired the hint.
    if HintControl = nil then
      exit;

    // Convert the cursor's coordinates from relative to hint to
    // relative to screen.
    HintPos := HintControl.ClientToScreen (CursorPos);
    // Get some information about the cursor that is used for the
    // hint control.
    GetIconInfo (Screen.Cursors [HintControl.Cursor], II);
    // Get some information about the bitmap representing the cursor
    GetObject (II.hbmMask, SizeOf (Windows.TBitmap), @Bmp);
    // If the info did not include a colour bitmap then the mask bitmap
    // is really two bitmaps, an AND and a XOR mask.  Increment our Y
    // position by the bitmap's height.
    if II.hbmColor = 0 then
      inc (HintPos.Y, Bmp.bmHeight div 2)
    else
      inc (HintPos.Y, Bmp.bmHeight);
    // Subtract out the Y hotspot position.
    dec (HintPos.Y, II.yHotSpot);
    // We are responsible for cleaning up the bitmap handles returned
    // by GetIconInfo.
    DeleteObject (II.hbmMask);
    DeleteObject (II.hbmColor)
  end
end;

END.
