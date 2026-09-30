object ForgotForm: TForgotForm
  Caption = 'Forgot'
  ClientHeight = 200
  ClientWidth = 350
  object btnReset: TButton
    Left = 100
    Top = 70
    Width = 150
    Height = 30
    Caption = 'Reset'
    OnClick = btnResetClick
    TabOrder = 0
  end
  object btnBack: TButton
    Left = 100
    Top = 120
    Width = 150
    Height = 30
    Caption = 'Back'
    OnClick = btnBackClick
    TabOrder = 1
  end
end