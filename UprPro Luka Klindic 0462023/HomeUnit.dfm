object HomeForm: THomeForm
  Caption = 'Home'
  ClientHeight = 220
  ClientWidth = 350
  object btnMain: TButton
    Left = 100
    Top = 60
    Width = 150
    Height = 40
    Caption = 'Main'
    OnClick = btnMainClick
    TabOrder = 0
  end
  object btnLogout: TButton
    Left = 100
    Top = 120
    Width = 150
    Height = 40
    Caption = 'Logout'
    OnClick = btnLogoutClick
    TabOrder = 1
  end
end