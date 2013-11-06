object frmConf: TfrmConf
  Left = 361
  Top = 220
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Nastaven'#237' spo'#345'i'#269'e Hodiny'
  ClientHeight = 402
  ClientWidth = 432
  Color = clBtnFace
  Constraints.MinHeight = 348
  Constraints.MinWidth = 440
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    432
    402)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupColors: TGroupBox
    Left = 8
    Top = 8
    Width = 209
    Height = 153
    Caption = 'Barvy'
    TabOrder = 0
    object lblColorHour: TLabel
      Left = 8
      Top = 24
      Width = 87
      Height = 13
      Caption = 'Hodinov'#225' ru'#269'i'#269'ka:'
    end
    object lblColorMinute: TLabel
      Left = 8
      Top = 48
      Width = 85
      Height = 13
      Caption = 'Minutov'#225' ru'#269'i'#269'ka:'
    end
    object lblColorSecond: TLabel
      Left = 8
      Top = 72
      Width = 96
      Height = 13
      Caption = 'Sekundov'#225' ru'#269'i'#269'ka:'
    end
    object lblColorTicks: TLabel
      Left = 8
      Top = 96
      Width = 40
      Height = 13
      Caption = 'M'#283#345#237'tko:'
    end
    object lblColorBackground: TLabel
      Left = 8
      Top = 120
      Width = 36
      Height = 13
      Caption = 'Pozad'#237':'
    end
    object colorHour: TPanel
      Left = 108
      Top = 13
      Width = 89
      Height = 23
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      OnClick = colorClick
    end
    object colorMinute: TPanel
      Left = 108
      Top = 40
      Width = 89
      Height = 22
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      OnClick = colorClick
    end
    object colorSecond: TPanel
      Left = 108
      Top = 66
      Width = 89
      Height = 22
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clRed
      ParentBackground = False
      TabOrder = 2
      OnClick = colorClick
    end
    object colorTicks: TPanel
      Left = 108
      Top = 92
      Width = 89
      Height = 22
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWhite
      ParentBackground = False
      TabOrder = 3
      OnClick = colorClick
    end
    object colorBackground: TPanel
      Left = 108
      Top = 118
      Width = 89
      Height = 22
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clBlack
      Ctl3D = True
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 4
      OnClick = colorClick
    end
  end
  object Panel1: TPanel
    Left = 8
    Top = 366
    Width = 419
    Height = 3
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvLowered
    TabOrder = 1
  end
  object btnInfo: TButton
    Left = 8
    Top = 374
    Width = 121
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Informace o aplikaci'
    TabOrder = 2
    OnClick = btnInfoClick
  end
  object btnOK: TButton
    Left = 266
    Top = 374
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    Default = True
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 352
    Top = 374
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Z&ru'#353'it'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object pnlScreen: TPanel
    Left = 224
    Top = 8
    Width = 201
    Height = 153
    BevelOuter = bvNone
    Color = clBlack
    ParentBackground = False
    TabOrder = 5
  end
  object grpSize: TGroupBox
    Left = 8
    Top = 168
    Width = 417
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Velikost'
    TabOrder = 6
    DesignSize = (
      417
      65)
    object lblSmall: TLabel
      Left = 8
      Top = 47
      Width = 23
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Mal'#225
    end
    object lblMiddle: TLabel
      Left = 152
      Top = 48
      Width = 35
      Height = 13
      Alignment = taCenter
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'St'#345'edn'#237
    end
    object lblLarge: TLabel
      Left = 382
      Top = 48
      Width = 27
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = 'Velk'#225
    end
    object edtSize: TTrackBar
      Left = 6
      Top = 16
      Width = 403
      Height = 33
      Anchors = [akLeft, akTop, akRight]
      Position = 4
      TabOrder = 0
      OnChange = edtSizeChange
    end
  end
  object boxMovement: TGroupBox
    Left = 8
    Top = 240
    Width = 417
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Pohyb'
    TabOrder = 7
    DesignSize = (
      417
      65)
    object boxCenter: TCheckBox
      Left = 8
      Top = 16
      Width = 398
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Udr'#382'ovat hodiny vycentrovan'#233
      TabOrder = 0
      OnClick = boxCenterClick
    end
    object boxRandom: TCheckBox
      Left = 8
      Top = 40
      Width = 398
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Pohybovat n'#225'hodn'#283
      TabOrder = 1
      OnClick = boxRandomClick
    end
  end
  object boxDrawing: TGroupBox
    Left = 8
    Top = 312
    Width = 417
    Height = 49
    Caption = 'Vykreslov'#225'n'#237
    TabOrder = 8
    object btnAntialiasing: TCheckBox
      Left = 8
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Antialiasing'
      TabOrder = 0
      OnClick = btnAntialiasingClick
    end
  end
  object dlgColor: TColorDialog
    Left = 88
  end
  object XPManifest1: TXPManifest
    Left = 120
  end
end
