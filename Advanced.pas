UNIT Advanced;

// ============================================================================
INTERFACE

// The constant below can be used to switch some old code back on.
// Previously, I used EnumFontFamiliesEx to determine all the new fonts
// which had been installed, in one go.  Now, I use a routine to read
// the font name from a font file at the point where it is added to
// the font table.
// {$ D E FINE ENUMFONTS}

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CheckLst, Buttons, ComCtrls, Menus, ovceditf,
  ovcedpop, ovcedsld;

type
  TfrmAdvanced = class(TForm)
    pgFontLister: TPageControl;
    tsFonts: TTabSheet;
    lblFontName: TLabel;
    gbFontPrintingCharacteristics: TGroupBox;
    cbBold: TSpeedButton;
    cbItalic: TSpeedButton;
    cbStrikeout: TSpeedButton;
    cbUnderline: TSpeedButton;
    cbAllFonts: TCheckBox;
    clbFonts: TCheckListBox;
    tsListProperties: TTabSheet;
    gbMessageText: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    cbFontName: TCheckBox;
    gbReportTitle: TGroupBox;
    cbTitle: TCheckBox;
    eTitleText: TEdit;
    gbRTFont: TGroupBox;
    sbRTBold: TSpeedButton;
    sbRTItalic: TSpeedButton;
    sbRTUnderline: TSpeedButton;
    sbRTStrikeout: TSpeedButton;
    cbRTFontName: TComboBox;
    tsHeaderFooter: TTabSheet;
    gbHeader: TGroupBox;
    cbHeader: TCheckBox;
    eHeaderText: TEdit;
    cbListChars: TCheckBox;
    cbSuppressHeader: TCheckBox;
    gbHeaderFont: TGroupBox;
    sbHBold: TSpeedButton;
    sbHItalic: TSpeedButton;
    SBHUnderline: TSpeedButton;
    SBHStrikeout: TSpeedButton;
    cbHFontName: TComboBox;
    gbFooter: TGroupBox;
    cbDateTime: TCheckBox;
    cbPageNo: TCheckBox;
    gbFooterFont: TGroupBox;
    sbFBold: TSpeedButton;
    sbFItalic: TSpeedButton;
    sbFUnderline: TSpeedButton;
    sbFStrikeout: TSpeedButton;
    cbFFontName: TComboBox;
    tsPrinter: TTabSheet;
    gbPrinter: TGroupBox;
    cbPrinters: TComboBox;
    rgOrientation: TRadioGroup;
    rgPaperSize: TRadioGroup;
    gbMargins: TGroupBox;
    lblTop: TLabel;
    lblBottom: TLabel;
    lblLeft: TLabel;
    lblRight: TLabel;
    rgUnits: TRadioGroup;
    eTop: TEdit;
    eBottom: TEdit;
    eLeft: TEdit;
    eRight: TEdit;
    rgColumns: TRadioGroup;
    gbFirstPageNo: TGroupBox;
    tsOptions: TTabSheet;
    gbWindow: TGroupBox;
    cbMinimise: TCheckBox;
    rgStartup: TRadioGroup;
    bSaveSettings: TButton;
    PopupMenu1: TPopupMenu;
    Selectall1: TMenuItem;
    Unselectall1: TMenuItem;
    Toggleselection1: TMenuItem;
    N1: TMenuItem;
    Preview2: TMenuItem;
    ExportsampleasJPEG1: TMenuItem;
    tsPath: TTabSheet;
    gbFontPath: TGroupBox;
    bAdd: TButton;
    bRemove: TButton;
    bApply: TButton;
    lbFontPath: TListBox;
    bNewFonts: TButton;
    Label1: TLabel;
    cbUseInstalled: TCheckBox;
    gbReport: TGroupBox;
    cbBorders: TCheckBox;
    mMessage: TMemo;
    lblInfo: TLabel;
    bAutoText: TButton;
    Viewcharacterset1: TMenuItem;
    osePointSize: TOvcSliderEdit;
    oseRTFontSize: TOvcSliderEdit;
    oseHFontSize: TOvcSliderEdit;
    oseFFontSize: TOvcSliderEdit;
    oseFirstPage: TOvcSliderEdit;

    procedure cbHeaderClick(Sender: TObject);
    procedure cbTitleClick(Sender: TObject);
    procedure ExportsampleasJPEG1Click(Sender: TObject);
    procedure cbAllFontsClick(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure Unselectall1Click(Sender: TObject);
    procedure clbFontsClickCheck(Sender: TObject);
    procedure Toggleselection1Click(Sender: TObject);
    procedure clbFontsClick(Sender: TObject);
    procedure rgUnitsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure clbFontsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure clbFontsMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure clbFontsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure bAddClick(Sender: TObject);
    procedure bRemoveClick(Sender: TObject);
    procedure bApplyClick(Sender: TObject);
    procedure bNewFontsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Preview2Click(Sender: TObject);
    procedure cbUseInstalledClick(Sender: TObject);
    procedure bSaveSettingsClick(Sender: TObject);
    procedure cbBoldClick(Sender: TObject);
    procedure bAutoTextClick(Sender: TObject);
    procedure Viewcharacterset1Click(Sender: TObject);

  private
    AutoTextCount: integer;
    RemoveList: TStringList;
    RemoveNames: TStringList;

    procedure SetStyle (aFont: TFont; Index: integer);
    procedure ProcessDir (Base: String; DoRecurse: boolean);
    procedure AddDir (DirName: String);
    procedure AddTheFonts (FontDir: String);
    procedure ListUninstalledFonts;
    procedure RememberToRemoveFont (FontName: String);
{$IFNDEF ENUMFONTS}
    function GetTypeFaceName (TrueTypeFile: String): String;
{$ENDIF}

  public
    oldUnits: short;

    procedure RemoveFonts;

  end;

{$IFNDEF ENUMFONTS}
  TTableDirectory = record
    Tag: LongInt;
    CheckSum: LongInt;
    Offset: LongInt;
    Length: LongInt;
  end;

  TNamingTable = record
    Format: Word;
    Count: Word;
    StringOffset: Word;
  end;

  TNameRecord = record
    PlatformID: Word;
    SpecificID: Word;
    LanguageID: Word;
    NameID: Word;
    Length: Word;
    Offset: Word;
  end;
{$ENDIF}

// ============================================================================
IMPLEMENTATION

USES
  Main, Export, WinReg, SelectFolderDialog, Wait, Printers, ViewCharSet;

{$R *.DFM}

// ----------------------------------------------------------------------------
procedure TfrmAdvanced.cbHeaderClick(Sender: TObject);
begin
  eHeaderText.Enabled := cbHeader.Checked;
  cbListChars.Enabled := cbHeader.Checked;
  cbSuppressHeader.Enabled := cbHeader.Checked
end;

// ----------------------------------------------------------------------------
procedure TfrmAdvanced.cbTitleClick(Sender: TObject);
begin
  eTitleText.Enabled := cbTitle.Checked
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.ExportsampleasJPEG1Click(Sender: TObject);
begin
  dlgJPEGExport.Execute (lblFontName.Caption)
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.cbAllFontsClick(Sender: TObject);
begin
  if not DontDoIt then
  begin
    if cbAllFonts.Checked then
      SelectAll1Click (Sender)
    else
      UnselectAll1Click (Sender)
  end
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.Selectall1Click(Sender: TObject);
var
  i: integer;

begin
  DontDoIt := True;
  cbAllFonts.Checked := True;
  cbUseInstalled.Checked := True;
  for i := 0 to clbFonts.Items.Count - 1 do
    clbFonts.Checked [i] := True;
  DontDoIt := False;
  frmMain.SetButtons
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.Unselectall1Click(Sender: TObject);
var
  i: integer;

begin
  DontDoIt := True;
  cbAllFonts.Checked := False;
  cbUseInstalled.Checked := False;
  for i := 0 to clbFonts.Items.Count - 1 do
    clbFonts.Checked [i] := False;
  DontDoIt := False;
  frmMain.SetButtons
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.Toggleselection1Click(Sender: TObject);
var
  i: integer;

begin
  DontDoIt := True;
  if cbAllFonts.State = cbChecked then
    cbAllFonts.State := cbUnchecked
  else if cbAllFonts.State = cbUnchecked then
    cbAllFonts.State := cbChecked;
  DontDoIt := False;

  for i := 0 to clbFonts.Items.Count - 1 do
    clbFonts.Checked [i] := not clbFonts.Checked [i];
  frmMain.SetButtons
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.clbFontsClick(Sender: TObject);
var
  i: integer;
  AnyChecked: boolean;
  AnyUnchecked: boolean;
  KeepGoing: boolean;

begin
  AnyChecked := false;
  AnyUnchecked := false;
  KeepGoing := True;

  i := 0;
  while KeepGoing and (i < clbFonts.Items.Count) do
  begin
    if clbFonts.Checked [i] then
      AnyChecked := True
    else
      AnyUnchecked := True;

    if AnyChecked and AnyUnchecked then
      KeepGoing := False;

    Inc (i)
  end;

  DontDoIt := True;
  if AnyChecked and not AnyUnchecked then
    cbAllFonts.State := cbChecked
  else if not AnyChecked and AnyUnchecked then
    cbAllFonts.State := cbUnchecked
  else
    cbAllFonts.State := cbGrayed;
  DontDoIt := False;

  frmMain.SetButtons
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.clbFontsClickCheck(Sender: TObject);
var
  i: integer;
  AnyChecked: boolean;
  AnyUnchecked: boolean;
  KeepGoing: boolean;

begin
  AnyChecked := false;
  AnyUnchecked := false;
  KeepGoing := True;

  i := 0;
  while KeepGoing and (i < clbFonts.Items.Count) do
  begin
    if clbFonts.Checked [i] then
      AnyChecked := True
    else
      AnyUnchecked := True;

    if AnyChecked and AnyUnchecked then
      KeepGoing := False;

    Inc (i)
  end;

  DontDoIt := True;
  if AnyChecked and not AnyUnchecked then
    cbAllFonts.State := cbChecked
  else if not AnyChecked and AnyUnchecked then
    cbAllFonts.State := cbUnchecked
  else
    cbAllFonts.State := cbGrayed;
  DontDoIt := False;

  frmMain.SetButtons
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.rgUnitsClick(Sender: TObject);
const
  Inch_MM_Ratio = 25.4;

var
  f: Single;
  s: String;

begin
  if (oldUnits = 0) and (rgUnits.ItemIndex = 1) then
  begin
    try
      f := (StrToFloat (eTop.Text) / Inch_MM_Ratio);
      fmtStr (s, '%4.2f', [f]);
      eTop.Text := s
    except
    end;
    try
      f := (StrToFloat (eBottom.Text) / Inch_MM_Ratio);
      fmtStr (s, '%4.2f', [f]);
      eBottom.Text := s
    except
    end;
    try
      f := (StrToFloat (eLeft.Text) / Inch_MM_Ratio);
      fmtStr (s, '%4.2f', [f]);
      eLeft.Text := s
    except
    end;
    try
      f := (StrToFloat (eRight.Text) / Inch_MM_Ratio);
      fmtStr (s, '%4.2f', [f]);
      eRight.Text := s
    except
    end;
  end
  else if (oldUnits = 1) and (rgUnits.ItemIndex = 0) then
  begin
    try
      f := (StrToFloat (eTop.Text) * Inch_MM_Ratio);
      fmtStr (s, '%3.1f', [f]);
      eTop.Text := s
    except
    end;
    try
      f := (StrToFloat (eBottom.Text) * Inch_MM_Ratio);
      fmtStr (s, '%3.1f', [f]);
      eBottom.Text := s
    except
    end;
    try
      f := (StrToFloat (eLeft.Text) * Inch_MM_Ratio);
      fmtStr (s, '%3.1f', [f]);
      eLeft.Text := s
    except
    end;
    try
      f := (StrToFloat (eRight.Text) * Inch_MM_Ratio);
      fmtStr (s, '%3.1f', [f]);
      eRight.Text := s
    except
    end;
  end;

  oldUnits := rgUnits.ItemIndex
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.FormCreate(Sender: TObject);
var
  i: integer;

begin
  cbPrinters.Items := Printer.Printers;
  pgFontLister.ActivePage := tsFonts;
  AutoTextCount := 0;

  RemoveList := TStringList.Create;
  RemoveList.Sorted := True;
  RemoveList.Duplicates := dupIgnore;

  RemoveNames := TStringList.Create;
  RemoveNames.Sorted := True;
  RemoveNames.Duplicates := dupIgnore;

  clbFonts.Items.Clear;
  for i := 0 to Screen.Fonts.Count - 1 do
    clbFonts.Items.Add (Screen.Fonts [i]);
  clbFonts.Sorted := True;

  cbRTFontName.Items.Assign (Screen.Fonts);
  cbHFontName.Items.Assign (Screen.Fonts);
  cbFFontName.Items.Assign (Screen.Fonts)
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.clbFontsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  APoint: TPoint;
  Index: integer;

begin
  APoint.X := X;
  APoint.Y := Y;
  Index := clbFonts.ItemAtPos (APoint, True);
  Application.CancelHint;
  if Index > -1 then
  begin
    clbFonts.Hint := clbFonts.Items [Index]
  end
  else
    clbFonts.Hint := '';
  lblFontName.Caption := clbFonts.Hint
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.clbFontsMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  with clbFonts.Canvas do
  begin
    SetStyle (Font, Index);
    Height := TextHeight ('Wg') + 2
  end
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.clbFontsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
(*
var
  teItem: integer;
  s: String;
*)

begin
  with clbFonts.canvas do
  begin
    FillRect (Rect);
    SetStyle (Font, Index);
    TextOut (Rect.Left + 1, Rect.Top + 1, clbFonts.Items [Index] + ' 0123');
(*
    s := clbFonts.Items [Index] + ' - ';
    TextOut (Rect.Left + 1, Rect.Top + 1, s);
    teItem := TextWidth (s);
    SetStyle (Font, Index);
    TextOut (Rect.Left + 5 + teItem, Rect.Top + 1, clbFonts.Items [Index] + ' 0123')
*)
  end
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.SetStyle (aFont: TFont; Index: integer);
begin
  aFont.Name := clbFonts.Items [Index];
  aFont.Size := 0;
  aFont.Style := [];

  if cbBold.Down then
    aFont.Style := [fsBold];
  if cbItalic.Down then
    aFont.Style := aFont.Style + [fsItalic];
  if cbUnderline.Down then
    aFont.Style := aFont.Style + [fsUnderline];
  if cbStrikeout.Down then
    aFont.Style := aFont.Style + [fsStrikeout]
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.bAddClick(Sender: TObject);
var
  StartDir: String;

begin
  SelectFolder.ShowRecurse := True;
  if SelectFolder.Execute then
  begin
    Screen.Cursor := crHourglass;
    StartDir := SelectFolder.Directory;

    if SelectFolder.Recurse then
      ShowMessage ('You have elected to recurse subdirectories; ' +
        'Win32 Font Lister will now look for subdirectories that ' +
        'contain uninstalled fonts. This may take a little while.');
    ProcessDir (StartDir, SelectFolder.Recurse);
    Screen.Cursor := crDefault
  end
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.AddDir (DirName: String);
var
  i: integer;
  FoundIt: boolean;

begin
  i := 0;
  FoundIt := False;

  while not FoundIt and (i < lbFontPath.Items.Count) do
    if lbFontPath.Items [i] = DirName then
      FoundIt := True
    else
      Inc (i);

  if not FoundIt then
  begin
{$IFDEF BETA}
    try
{$ENDIF}
    lbFontPath.Items.Add (DirName);
    lblInfo.Caption := IntToStr (lbFontPath.Items.Count) + ' directories';
    bApply.Enabled := True;
    bNewFonts.Enabled := False;
{$IFDEF BETA}
    except
      ShowMessage ('Cannot add anything more to the font path list - count is ' + IntToStr(lbFontPath.Items.Count))
    end;
{$ENDIF}
    Application.ProcessMessages
  end
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.ProcessDir (Base: String; DoRecurse: boolean);
var
  SearchRec: TSearchRec;

begin
  AddDir (Base);

  if (LastDelimiter ('\', Base) = length (Base)) then
    Base [length (Base)] := ' ';

  if FindFirst (Base + '\*.*', faReadOnly + faHidden + faDirectory, SearchRec) = 0 then
  repeat
    if (SearchRec.Name = '.') or (SearchRec.Name = '..') then
      continue;

    if (DoRecurse and ((SearchRec.Attr and faDirectory) <> 0)) then
      ProcessDir (Base + '\' + SearchRec.Name, DoRecurse)
  until FindNext (SearchRec) <> 0;

  FindClose (SearchRec)
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.bRemoveClick(Sender: TObject);
var
  i: integer;

begin
  for i := lbFontPath.Items.Count - 1 downto 0 do
  begin
    if lbFontPath.Selected [i] then
    begin
      lbFontPath.Items.Delete (i);
      bApply.Enabled := True;
      bNewFonts.Enabled := False
    end
  end;

  lblInfo.Caption := IntToStr (lbFontPath.Items.Count) + ' directories'
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.bApplyClick(Sender: TObject);
var
  i: integer;

begin
  Screen.Cursor := crHourglass;
  RemoveFonts;

  frmWait.pbWait.Max := lbFontPath.Items.Count;
  frmWait.pbWait.Position := 0;
  frmWait.Show;
  for i := 0 to lbFontPath.Items.Count - 1 do
  begin
    AddTheFonts (lbFontPath.Items [i]);
    frmWait.pbWait.Position := i
  end;

  ListUninstalledFonts;

  frmWait.Close;
  bApply.Enabled := False;
  clbFontsClickCheck (Sender);  // To make sure the 'All fonts' box is ok ...
  Screen.Cursor := crDefault;
  if RemoveNames.Count > 0 then
  begin
    bNewFonts.Enabled := True;
    if RemoveNames.Count = 1 then
      ShowMessage ('Found 1 uninstalled font.')
    else
      ShowMessage ('Found ' + IntToStr (RemoveNames.Count) + ' uninstalled fonts.')
  end
  else if lbFontPath.Items.Count > 0 then
    ShowMessage ('No uninstalled fonts found.')
  else
    ShowMessage ('All uninstalled fonts removed.')
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.AddTheFonts (FontDir: String);
var
  SearchRec: TSearchRec;
  FontPath: String;

begin
  if FindFirst (FontDir + '\*.ttf',
        faReadOnly + faHidden + faDirectory, SearchRec) = 0 then
  repeat
    if (SearchRec.Name = '.') or (SearchRec.Name = '..') then
      continue;
    FontPath := FontDir + '\' + SearchRec.Name;
    if AddFontResource (PChar (FontPath)) > 0 then
    begin
      RememberToRemoveFont (FontPath);
{$IFNDEF ENUMFONTS}
      RemoveNames.Add (GetTypefaceName (FontPath));
{$ENDIF}
    end
  until FindNext (SearchRec) <> 0;

  FindClose (SearchRec)
end;

{$IFNDEF ENUMFONTS}
//------------------------------------------------------------------------------
function TfrmAdvanced.GetTypeFaceName (TrueTypeFile: String): String;
var
  FileHandle: Integer;
  TableDirectory: TTableDirectory;
  NamingTable: TNamingTable;
  NameRecord: TNameRecord;
  LongSwap: LongInt;
  Buffer: array [0..255] of Char;
  WideResult: string;
  I: Integer;

begin
  Result := '';
  Buffer := '';
  WideResult := '';

  FileHandle := FileOpen (TrueTypeFile, fmOpenRead);
  if FileHandle < 0 then
    Exit;

  FileSeek (FileHandle, 12, 0);
  repeat
    if FileRead (FileHandle, TableDirectory, SizeOf (TableDirectory)) <
      SizeOf (TableDirectory) then
    begin
      FileClose (FileHandle);
      Exit;
    end;
  until TableDirectory.Tag = $656D616E;

  LongSwap := TableDirectory.Offset shr 16;
  TableDirectory.Offset := Swap (TableDirectory.Offset) shl 16 +
    Swap(LongSwap);
  FileSeek (FileHandle, TableDirectory.Offset, 0);
  FileRead (FileHandle, NamingTable, SizeOf (NamingTable));

  repeat
    if FileRead (FileHandle, NameRecord, SizeOf (NameRecord)) <
      SizeOf (NameRecord) then
    begin
      FileClose (FileHandle);
      Exit;
    end;
  until (Swap (NameRecord.PlatformID) = 3) and (Swap (NameRecord.NameID) = 4);

  FileSeek (FileHandle, Swap (NamingTable.StringOffset) +
    Swap (NameRecord.Offset) + TableDirectory.Offset, 0);
  FileRead (FileHandle, Buffer, Swap (NameRecord.Length));
  NameRecord.Length := Swap (NameRecord.Length);

  I := 1;
  repeat
    WideResult := WideResult + Buffer [I];
    I := I + 2;
  until I > NameRecord.Length;

  Result := WideResult;
  FileClose (FileHandle);
end;
{$ENDIF}

{$IFDEF ENUMFONTS}
//------------------------------------------------------------------------------
function EnumFontsProc (var LogFont: TLogFont; var TextMetric: TTextMetric;
                        FontType: Integer; Data: Pointer): Integer; stdcall;
var
  S: TStrings;
  Temp: String;

begin
  S := TStrings (Data);
  Temp := LogFont.lfFaceName;
  if ((S.Count = 0) or (AnsiCompareText (S [S.Count - 1], Temp) <> 0)) then
    if Screen.Fonts.IndexOf (Temp) = -1 then
      S.Add (Temp);
  Result := 1
end;
{$ENDIF}

//------------------------------------------------------------------------------
procedure TfrmAdvanced.ListUninstalledFonts;
var
  i: integer;
{$IFDEF ENUMFONTS}
  DC: HDC;
  LFont: TLogFont;
  lpVersionInformation: TOSVersionInfo;
{$ENDIF}

begin
{$IFDEF ENUMFONTS}
  DC := GetDC (0);
  try
    RemoveNames.Clear;
    lpVersionInformation.dwOSVersionInfoSize := sizeof (TOSVersionInfo);
    GetVersionEx (lpVersionInformation);
    if lpVersionInformation.dwMajorVersion >= 4 then
    begin
      FillChar (LFont, sizeof (LFont), 0);
      LFont.lfCharset := DEFAULT_CHARSET;
      EnumFontFamiliesEx (DC, LFont, @EnumFontsProc, LongInt (RemoveNames), 0);
    end
    else
      EnumFonts (DC, nil, @EnumFontsProc, Pointer (RemoveNames))
  finally
    ReleaseDC (0, DC);
  end;
{$ENDIF}

  for i := 0 to RemoveNames.Count - 1 do
  begin
{$IFDEF BETA}
    try
{$ENDIF}
    clbFonts.Items.Add (RemoveNames [i]);
    clbFonts.Checked [clbFonts.Items.IndexOf (RemoveNames [i])] := True
{$IFDEF BETA}
    except
      ShowMessage ('List of available fonts is too large - count is ' + IntToStr(clbFonts.Items.Count));
    end;
{$ENDIF}
  end
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.RememberToRemoveFont (FontName: String);
begin
{$IFDEF BETA}
  try
{$ENDIF}
  RemoveList.Add (FontName);
  lblInfo.Caption := IntToStr (RemoveList.Count) + ' new fonts';
{$IFDEF BETA}
  except
    ShowMessage ('Removal list has run out of room - count is ' + IntToStr(RemoveList.Count))
  end;
{$ENDIF}
  SendMessage (HWND_BROADCAST, WM_FONTCHANGE, 0, 0)
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.RemoveFonts;
var
  i: integer;

begin
  for i := RemoveList.Count - 1 downto 0 do
  begin
    RemoveFontResource (PChar (RemoveList [i]));
    SendMessage (HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
    Application.ProcessMessages;
    RemoveList.Delete (i)
  end;

  for i := 0 to RemoveNames.Count - 1 do
    clbFonts.Items.Delete (clbFonts.Items.IndexOf (RemoveNames [i]));
  RemoveNames.Clear
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.bNewFontsClick(Sender: TObject);
var
  i: integer;
  s: String;

begin
  s := 'These fonts were found ... ' + #13 + #13;
  for i := 0 to RemoveNames.Count - 1 do
  begin
    if i = RemoveNames.Count - 1 then
      s := s + RemoveNames [i]
    else
      s := s + RemoveNames [i] + ', ';
    if ((i + 1) mod 5) = 0 then
      s := s + #13
  end;
  ShowMessage (s)
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.FormDestroy(Sender: TObject);
begin
  RemoveList.Free;
  RemoveNames.Free
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.Preview2Click(Sender: TObject);
begin
  frmMain.bPreviewClick (Sender)
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.cbUseInstalledClick(Sender: TObject);
var
  i: integer;

begin
  if not DontDoIt then
  begin
    DontDoIt := True;
    for i := 0 to clbFonts.Items.Count - 1 do
      if Screen.Fonts.IndexOf (clbFonts.Items [i]) > -1 then
        clbFonts.Checked [i] := cbUseInstalled.Checked;
    clbFontsClick (Sender);
    DontDoIt := False
  end
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.bSaveSettingsClick(Sender: TObject);
var
  Reg: TWinRegistry;

begin
  if frmMain.bRegister.Visible then
    ShowMessage ('Sorry, this feature is only available to registered users.')
  else
  begin
    Reg := TWinRegistry.Create ('Software\FontLister');

    with frmAdvanced do
    with Reg do
    begin
      WriteString ('ListingProperties', 'Message', mMessage.Text);
      WriteBool ('ListingProperties', 'FontName', cbFontName.Checked);
      WriteBool ('ListingProperties', 'DisplayTitle', cbTitle.Checked);
      WriteString ('ListingProperties', 'TitleText', eTitleText.Text);
      WriteBool ('ListingProperties', 'DisplayHeader', cbHeader.Checked);
      WriteString ('ListingProperties', 'HeaderText', eHeaderText.Text);
      WriteBool ('ListingProperties', 'ListChars', cbListChars.Checked);
      WriteBool ('ListingProperties', 'SuppressHeader', cbSuppressHeader.Checked);
      WriteBool ('ListingProperties', 'DateTime', cbDateTime.Checked);
      WriteBool ('ListingProperties', 'PageNo', cbPageNo.Checked);
      WriteInteger ('ListingProperties', 'FirstPage', oseFirstPage.AsInteger);
      WriteInteger ('PageLayout', 'PrinterIndex', cbPrinters.ItemIndex);
      WriteInteger ('PageLayout', 'Orientation', rgOrientation.ItemIndex);
      WriteInteger ('PageLayout', 'PointSize', osePointSize.AsInteger);
      WriteBool ('PageLayout', 'Bold', cbBold.Down);
      WriteBool ('PageLayout', 'Italic', cbItalic.Down);
      WriteBool ('PageLayout', 'Underline', cbUnderline.Down);
      WriteBool ('PageLayout', 'Strikeout', cbStrikeout.Down);
      WriteInteger ('PageLayout', 'PaperSize', rgPaperSize.ItemIndex);
      WriteInteger ('PageLayout', 'Units', rgUnits.ItemIndex);
      WriteString ('PageLayout', 'Top', eTop.Text);
      WriteString ('PageLayout', 'Bottom', eBottom.Text);
      WriteString ('PageLayout', 'Left', eLeft.Text);
      WriteString ('PageLayout', 'Right', eRight.Text);
      WriteInteger ('PageLayout', 'Columns', rgColumns.ItemIndex);
      WriteBool ('Options', 'StartMinimised', cbMinimise.Checked);
      WriteBool ('Options', 'UseBorders', cbBorders.Checked);
      WriteInteger ('Options', 'Startup', rgStartup.ItemIndex);
      WriteString ('HeaderFooter', 'RTFontName', cbRTFontName.Items [cbRTFontName.ItemIndex]);
      WriteInteger ('HeaderFooter', 'RTFontSize', oseRTFontSize.AsInteger);
      WriteBool ('HeaderFooter', 'RTBold', sbRTBold.Down);
      WriteBool ('HeaderFooter', 'RTItalic', sbRTItalic.Down);
      WriteBool ('HeaderFooter', 'RTUnderline', sbRTUnderline.Down);
      WriteBool ('HeaderFooter', 'RTStrikeout', sbRTStrikeout.Down);
      WriteString ('HeaderFooter', 'HFontName', cbHFontName.Items [cbHFontName.ItemIndex]);
      WriteInteger ('HeaderFooter', 'HFontSize', oseHFontSize.AsInteger);
      WriteBool ('HeaderFooter', 'HBold', sbHBold.Down);
      WriteBool ('HeaderFooter', 'HItalic', sbHItalic.Down);
      WriteBool ('HeaderFooter', 'HUnderline', sbHUnderline.Down);
      WriteBool ('HeaderFooter', 'HStrikeout', sbHStrikeout.Down);
      WriteString ('HeaderFooter', 'FFontName', cbFFontName.Items [cbFFontName.ItemIndex]);
      WriteInteger ('HeaderFooter', 'FFontSize', oseFFontSize.AsInteger);
      WriteBool ('HeaderFooter', 'FBold', sbFBold.Down);
      WriteBool ('HeaderFooter', 'FItalic', sbFItalic.Down);
      WriteBool ('HeaderFooter', 'FUnderline', sbFUnderline.Down);
      WriteBool ('HeaderFooter', 'FStrikeout', sbFStrikeout.Down)
    end;

    Reg.Free;

    ShowMessage ('Your settings have been saved.')
  end
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.cbBoldClick(Sender: TObject);
begin
  clbFonts.Refresh
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.bAutoTextClick(Sender: TObject);
begin
  case AutoTextCount of
    0: mMessage.Text := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()';
    1: mMessage.Text := 'abcdefghijklmnopqrstuvwxyz0123';
    2: mMessage.Text := 'This is %f - abc 0123';
    3: mMessage.Text := 'THIS IS %F - ABC 0123';
    4: mMessage.Text := 'This is %f'
  end;

  Inc (AutoTextCount);
  if AutoTextCount = 5 then
    AutoTextCount := 0
end;

//------------------------------------------------------------------------------
procedure TfrmAdvanced.Viewcharacterset1Click(Sender: TObject);
begin
  dlgViewCharacterSet.Execute (lblFontName.Caption)
end;

END.
