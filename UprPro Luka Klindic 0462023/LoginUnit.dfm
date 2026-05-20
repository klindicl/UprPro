object LoginForm: TLoginForm
  Caption = 'Login'
  ClientHeight = 300
  ClientWidth = 400
  object edtUsername: TEdit
    Left = 120
    Top = 50
    Width = 150
    Height = 24
    TabOrder = 0
  end
  object edtPassword: TEdit
    Left = 120
    Top = 90
    Width = 150
    Height = 24
    PasswordChar = '*'
    TabOrder = 1
  end
  object btnLogin: TButton
    Left = 120
    Top = 130
    Width = 150
    Height = 30
    Caption = 'Login'
    OnClick = btnLoginClick
    TabOrder = 2
  end
  object btnRegister: TButton
    Left = 120
    Top = 170
    Width = 150
    Height = 30
    Caption = 'Register'
    OnClick = btnRegisterClick
    TabOrder = 3
  end
  object btnForgot: TButton
    Left = 120
    Top = 210
    Width = 150
    Height = 30
    Caption = 'Forgot'
    OnClick = btnForgotClick
    TabOrder = 4
  end
end