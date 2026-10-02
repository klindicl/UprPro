object HomeForm: THomeForm
  Caption = 'Upravljanje proizvodnjom'
  ClientHeight = 360
  ClientWidth = 620
  Position = poScreenCenter
  OnShow = FormShow
  object lblTitle: TLabel
    Left = 35
    Top = 30
    Width = 500
    Height = 30
    Caption = 'UPRAVLJANJE PROIZVODNJOM'
    Font.Style = [fsBold]
    Font.Size = 16
  end
  object lblWelcome: TLabel
    Left = 35
    Top = 80
    Width = 540
    Height = 25
    Caption = 'Prijavljeni korisnik:'
  end
  object lblProcess: TLabel
    Left = 35
    Top = 125
    Width = 540
    Height = 50
    Caption = 'Poslovni tok: narudžbine -> planiranje -> proizvodnja -> resursi -> zalihe -> KPI'
    WordWrap = True
  end
  object btnMain: TButton
    Left = 35
    Top = 205
    Width = 250
    Height = 50
    Caption = 'Otvori operativni centar'
    OnClick = btnMainClick
    TabOrder = 0
  end
  object btnLogout: TButton
    Left = 305
    Top = 205
    Width = 180
    Height = 50
    Caption = 'Odjava'
    OnClick = btnLogoutClick
    TabOrder = 1
  end
end
