UNIT uRegister;

{==============================================================================}
INTERFACE

USES
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, ComCtrls;

const
  Secret_Key = 'Software\Microsoft\Application\Data\TNEF\Shared';

type
  TRegisterDlg = class(TForm)
    bClose: TButton;
    gbRegistered: TGroupBox;
    lDevRegCode: TLabel;
    ebProdCode: TEdit;
    bSaveReg: TButton;
    gbUnregistered: TGroupBox;
    mRegInfo: TMemo;
    pcRegister: TPageControl;
    tsCredit: TTabSheet;
    Label1: TLabel;
    lblRegNow: TLabel;
    lblPayPal: TLabel;
    tsCheque: TTabSheet;
    Memo1: TMemo;
    tsDirect: TTabSheet;
    Memo2: TMemo;
    Label2: TLabel;
    procedure bSaveRegClick(Sender: TObject);
    procedure ebProdCodeChange(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblRegNowClick(Sender: TObject);
    procedure lblPayPalClick(Sender: TObject);

  private
    Prog: String;
    SubKey: String;

  public
    function isRegistered (AppName: String; SecretName: String; var RegName: String): boolean;
    function Execute (AppName: String; SecretName: String; var RegName: String): boolean;

  end;

var
  RegisterDlg: TRegisterDlg;

{==============================================================================}
IMPLEMENTATION

{$R *.DFM}

USES
  uCrypt, WinReg, ShellAPI;

//------------------------------------------------------------------------------
function TRegisterDlg.isRegistered (AppName: String; SecretName: String;
    var RegName: String): boolean;
var
  Reg: TWinRegistry;
  CipherText, PlainText: String;
  GoodCRC: boolean;
  RNIndex: integer;

begin
  Reg := TWinRegistry.Create (Secret_Key);
  CipherText := Reg.ReadString (SecretName, SecretName, '');
  Reg.Free;

  GoodCRC := Decrypt (CipherText, PlainText);

  if GoodCRC then
  begin
    RNIndex := pos (AppName, PlainText);
    if RNIndex > 0 then
      RegName := copy (PlainText, length (AppName) + 1, length (PlainText) - length (AppName))
    else
      GoodCRC := False
  end;

  isRegistered := GoodCRC
end;

//------------------------------------------------------------------------------
function TRegisterDlg.Execute (AppName: String; SecretName: String;
    var RegName: String): boolean;
begin
  Prog := AppName;
  SubKey := SecretName;
  ShowModal;
  Execute := isRegistered (AppName, SecretName, RegName)
end;

//------------------------------------------------------------------------------
procedure TRegisterDlg.bSaveRegClick(Sender: TObject);
var
  PlainText: String;
  GoodCRC: Boolean;
  Reg: TWinRegistry;

begin
  GoodCRC := Decrypt (ebProdCode.Text, PlainText);

  if not GoodCRC then
    ShowMessage ('Sorry, that registration code is invalid.')
  else
  begin
    Reg := TWinRegistry.Create (Secret_Key);
    Reg.WriteString (SubKey, SubKey, ebProdCode.Text);
    Reg.Free;
    ShowMessage ('You have successfully registered Win32 Font Lister!')
  end;
  
  bSaveReg.Enabled := False
end;

//------------------------------------------------------------------------------
procedure TRegisterDlg.ebProdCodeChange(Sender: TObject);
begin
  if ebProdCode.text <> '' then
    bSaveReg.Enabled := True
  else
    bSaveReg.Enabled := False
end;

//------------------------------------------------------------------------------
procedure TRegisterDlg.bCloseClick(Sender: TObject);
begin
  if bSaveReg.Enabled then
    if MessageDlg ('Would you like to save the registration number?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      bSaveRegClick (Sender);
  Close
end;

//------------------------------------------------------------------------------
procedure TRegisterDlg.FormShow(Sender: TObject);
begin
  ebProdCode.Text := '';
  bSaveReg.Enabled := False;
end;

//------------------------------------------------------------------------------
procedure TRegisterDlg.lblRegNowClick(Sender: TObject);
begin
  ShellExecute (Handle, nil,
    'https://www.regnow.com/softsell/nph-softsell.cgi?item=3260-1', nil,
    nil, SW_SHOWNORMAL)
end;

//------------------------------------------------------------------------------
procedure TRegisterDlg.lblPayPalClick(Sender: TObject);
begin
  ShellExecute (Handle, nil,
    'https://www.paypal.com/xclick/business=ap_dmw%40bigpond.com&item_name=Win32+Font+Lister&amount=10.00', nil,
    nil, SW_SHOWNORMAL)
end;

END.
