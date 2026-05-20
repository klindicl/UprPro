object RegisterForm: TRegisterForm
  Caption = 'Register'
  ClientHeight = 250
  ClientWidth = 400
  object edtPassword: TEdit
    Left = 120
    Top = 60
    Width = 150
    Height = 24
    PasswordChar = '*'
    TabOrder = 0
  end
  object edtConfirm: TEdit
    Left = 120
    Top = 100
    Width = 150
    Height = 24
    PasswordChar = '*'
    TabOrder = 1
  end
  object btnRegister: TButton
    Left = 120
    Top = 140
    Width = 150
    Height = 30
    Caption = 'Register'
    OnClick = btnRegisterClick
    TabOrder = 2
  end
  object btnBack: TButton
    Left = 120
    Top = 180
    Width = 150
    Height = 30
    Caption = 'Back'
    OnClick = btnBackClick
    TabOrder = 3
  end
end