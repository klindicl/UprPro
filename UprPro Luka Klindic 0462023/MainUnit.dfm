object MainForm: TMainForm
  Caption = 'Main'
  ClientHeight = 400
  ClientWidth = 700
  OnCreate = FormCreate
  object StringGrid1: TStringGrid
    Left = 20
    Top = 20
    Width = 650
    Height = 280
    ColCount = 4
    RowCount = 5
    TabOrder = 0
  end
  object btnBack: TButton
    Left = 20
    Top = 320
    Width = 120
    Height = 35
    Caption = 'Back'
    OnClick = btnBackClick
    TabOrder = 1
  end
end