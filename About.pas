UNIT About;

// ============================================================================
INTERFACE

USES
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, jpeg;

type
  TfrmAbout = class(TForm)
    Image1: TImage;
    Bevel1: TBevel;
    okBtn: TBitBtn;
    lblCaption: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    lblEmail: TLabel;
    lblReg1: TLabel;
    lblReg2: TLabel;
    lblURL: TLabel;
    procedure lblURLClick(Sender: TObject);
    procedure lblEmailClick(Sender: TObject);

  private

  public

  end;

var
  frmAbout: TfrmAbout;

// ============================================================================
IMPLEMENTATION

USES
  ShellAPI;

{$R *.DFM}

// ----------------------------------------------------------------------------
procedure TfrmAbout.lblURLClick(Sender: TObject);
begin
  ShellExecute (Handle, nil,
    'http://www.geocities.com/rankinlibs', nil, nil, SW_SHOWNORMAL)
end;

// ----------------------------------------------------------------------------
procedure TfrmAbout.lblEmailClick(Sender: TObject);
begin
  ShellExecute (Handle, nil,
    'mailto:ap_dmw@bigpond.com', nil, nil, SW_SHOWNORMAL)
end;

END.
