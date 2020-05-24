PROGRAM ListFonts;

{%ToDo 'ListFonts.todo'}

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  Report in 'Report.pas' {frmReport},
  About in 'About.pas' {frmAbout},
  QRPreview in '..\Common\QRPreview.pas' {RptPreviewFrm},
  WinReg in '..\Common\Winreg.pas',
  UCrypt in '..\Common\UCrypt.pas',
  SelectFolderDialog in '..\Common\SelectFolderDialog.pas' {SelectFolder},
  uPrevInstance in '..\Common\uPrevInstance.pas',
  Export in 'Export.pas' {dlgJPEGExport},
  Wait in '..\Common\Wait.pas' {frmWait},
  Wizard in 'Wizard.pas' {frmWizard},
  Advanced in 'Advanced.pas' {frmAdvanced},
  uRegister in 'uRegister.pas' {RegisterDlg},
  ViewCharSet in 'ViewCharSet.pas' {dlgViewCharacterSet};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Win32 font lister';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmWait, frmWait);
  frmMain.Update;
//  Application.CreateForm(TfrmReport, frmReport);
//  Application.CreateForm(TfrmWizard, frmWizard);
//  Application.CreateForm(TfrmAdvanced, frmAdvanced);
  Application.CreateForm(TRptPreviewFrm, RptPreviewFrm);
  Application.CreateForm(TdlgJPEGExport, dlgJPEGExport);
  Application.CreateForm(TdlgViewCharacterSet, dlgViewCharacterSet);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TRegisterDlg, RegisterDlg);
  Application.CreateForm(TSelectFolder, SelectFolder);
  Application.Run;
END.
