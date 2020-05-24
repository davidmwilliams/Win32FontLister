UNIT Wizard;

// ============================================================================
INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmWizard = class(TForm)
    pnlWizard: TPanel;
    Image1: TImage;
    pgWizard: TPageControl;
    tsPage1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    tsPage2: TTabSheet;
    Label14: TLabel;
    Label15: TLabel;
    rgWizDisplayMode: TRadioGroup;
    cbWizPrinters: TComboBox;
    tsPage3: TTabSheet;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    tsPage4: TTabSheet;
    Label16: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    rgWizColumns: TRadioGroup;
    cbWizFontName: TCheckBox;
    tsPage5: TTabSheet;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    cbWizTitle: TCheckBox;
    eWizTitleText: TEdit;
    cbWizDateTime: TCheckBox;
    cbWizPageNo: TCheckBox;
    tsPage6: TTabSheet;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    bPrev: TButton;
    bNext: TButton;
    bFinish: TButton;
    mWizMessage: TMemo;
    procedure bNextClick(Sender: TObject);
    procedure bPrevClick(Sender: TObject);
    procedure bFinishClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbWizTitleClick(Sender: TObject);
    procedure rgWizDisplayModeClick(Sender: TObject);

  private
    procedure ProcessWizPage;

  public

  end;

// ============================================================================
IMPLEMENTATION

USES
  Main;

{$R *.DFM}

//------------------------------------------------------------------------------
procedure TfrmWizard.bNextClick(Sender: TObject);
begin
  ProcessWizPage;

  if pgWizard.ActivePage = tsPage1 then
  begin
    bPrev.Enabled := True;
    pgWizard.ActivePage := tsPage2
  end
  else if pgWizard.ActivePage = tsPage2 then
    pgWizard.ActivePage := tsPage3
  else if pgWizard.ActivePage = tsPage3 then
    pgWizard.ActivePage := tsPage4
  else if pgWizard.ActivePage = tsPage4 then
    pgWizard.ActivePage := tsPage5
  else if pgWizard.ActivePage = tsPage5 then
  begin
    bNext.Enabled := False;
    pgWizard.ActivePage := tsPage6
  end
end;

//------------------------------------------------------------------------------
procedure TfrmWizard.ProcessWizPage;
begin
  if pgWizard.ActivePage = tsPage2 then
  begin
    if rgWizDisplayMode.ItemIndex = 1 then
      frmAdvanced.cbPrinters.ItemIndex := cbWizPrinters.ItemIndex
  end
  else if pgWizard.ActivePage = tsPage3 then
  begin
    frmAdvanced.mMessage.Text := mWizMessage.Text
  end
  else if pgWizard.ActivePage = tsPage4 then
  begin
    frmAdvanced.rgColumns.ItemIndex := rgWizColumns.ItemIndex;
    frmAdvanced.cbFontName.Checked := cbWizFontName.Checked
  end
  else if pgWizard.ActivePage = tsPage5 then
  begin
    frmAdvanced.cbTitle.Checked := cbWizTitle.Checked;
    frmAdvanced.eTitleText.Text := eWizTitleText.Text;
    frmAdvanced.cbDateTime.Checked := cbWizDateTime.Checked;
    frmAdvanced.cbPageNo.Checked := cbWizPageNo.Checked
  end
end;

//------------------------------------------------------------------------------
procedure TfrmWizard.bPrevClick(Sender: TObject);
begin
  ProcessWizPage;

  if pgWizard.ActivePage = tsPage2 then
  begin
    bPrev.Enabled := False;
    pgWizard.ActivePage := tsPage1
  end
  else if pgWizard.ActivePage = tsPage3 then
    pgWizard.ActivePage := tsPage2
  else if pgWizard.ActivePage = tsPage4 then
    pgWizard.ActivePage := tsPage3
  else if pgWizard.ActivePage = tsPage5 then
    pgWizard.ActivePage := tsPage4
  else if pgWizard.ActivePage = tsPage6 then
  begin
    bNext.Enabled := True;
    pgWizard.ActivePage := tsPage5
  end
end;

//------------------------------------------------------------------------------
procedure TfrmWizard.bFinishClick(Sender: TObject);
begin
  ProcessWizPage;

  if rgWizDisplayMode.ItemIndex = 0 then
    frmMain.bPreviewClick (Sender)
  else
    frmMain.bPrintClick (Sender)
end;

//------------------------------------------------------------------------------
procedure TfrmWizard.FormCreate(Sender: TObject);
var
  i: integer;
  tmpTab: TTabSheet;

begin
  for i := 0 to pgWizard.PageCount - 1 do
    if (pgWizard.Pages [i] is TTabSheet) then
    begin
      tmpTab := pgWizard.Pages [i] as TTabSheet;
      tmpTab.TabVisible := False
    end
end;

//------------------------------------------------------------------------------
procedure TfrmWizard.cbWizTitleClick(Sender: TObject);
begin
  eWizTitleText.Enabled := cbWizTitle.Checked
end;

//------------------------------------------------------------------------------
procedure TfrmWizard.rgWizDisplayModeClick(Sender: TObject);
begin
  if rgWizDisplayMode.ItemIndex = 0 then
    cbWizPrinters.Enabled := False
  else
    cbWizPrinters.Enabled := True
end;

END.
