object dlgViewCharacterSet: TdlgViewCharacterSet
  Left = 308
  Top = 157
  Width = 330
  Height = 311
  Caption = 'View Character Set'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    322
    277)
  PixelsPerInch = 96
  TextHeight = 13
  object lblFontName: TLabel
    Left = 8
    Top = 8
    Width = 137
    Height = 13
    AutoSize = False
  end
  object cbItalic: TSpeedButton
    Left = 241
    Top = 2
    Width = 25
    Height = 25
    Hint = 'Italic'
    AllowAllUp = True
    GroupIndex = 2
    Caption = 'I'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsItalic]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = cbItalicClick
  end
  object cbBold: TSpeedButton
    Left = 216
    Top = 2
    Width = 25
    Height = 25
    Hint = 'Bold'
    AllowAllUp = True
    GroupIndex = 1
    Caption = 'B'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = cbBoldClick
  end
  object cbUnderline: TSpeedButton
    Left = 266
    Top = 2
    Width = 25
    Height = 25
    Hint = 'Underline'
    AllowAllUp = True
    GroupIndex = 3
    Caption = 'U'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = cbUnderlineClick
  end
  object cbStrikeout: TSpeedButton
    Left = 291
    Top = 2
    Width = 25
    Height = 25
    Hint = 'Strikeout'
    AllowAllUp = True
    GroupIndex = 4
    Caption = 'ABC'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsStrikeOut]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = cbStrikeoutClick
  end
  object bClose: TButton
    Left = 242
    Top = 256
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 0
  end
  object eSample: TMemo
    Left = 8
    Top = 32
    Width = 305
    Height = 217
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    Visible = False
  end
  object cbASCIIcodes: TCheckBox
    Left = 8
    Top = 256
    Width = 113
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Show ASCII codes'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = cbASCIIcodesClick
  end
  object dgSample: TDrawGrid
    Left = 8
    Top = 32
    Width = 305
    Height = 217
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    ColCount = 8
    DefaultColWidth = 32
    FixedCols = 0
    RowCount = 64
    FixedRows = 0
    ScrollBars = ssVertical
    TabOrder = 2
    OnDrawCell = dgSampleDrawCell
  end
  object osePointSize: TOvcSliderEdit
    Left = 156
    Top = 2
    Width = 57
    Height = 21
    AllowIncDec = True
    ButtonGlyph.Data = {
      4A010000424D4A0100000000000042000000280000000B0000000B0000000100
      1000030000000801000000000000000000000000000000000000007C0000E003
      00001F0000000042004200420042004200420042004200420042004200000042
      0042004200420042004200420042004200420042000000420042004200000000
      0042004200420042004200420000004200420042000000000000004200420042
      0042004200000042004200420000000000000000004200420042004200000042
      0042004200000000000000000000004200420042000000420042004200000000
      0000000000420042004200420000004200420042000000000000004200420042
      0042004200000042004200420000000000420042004200420042004200000042
      0042004200420042004200420042004200420042000000420042004200420042
      0042004200420042004200420000}
    PopupMax = 72.000000000000000000
    PopupStep = 1.000000000000000000
    TabOrder = 4
  end
end
