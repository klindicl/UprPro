object AdminForm: TAdminForm
  Caption = 'Admin Panel'
  ClientHeight = 600
  ClientWidth = 900
  OnCreate = FormCreate
  OnClose = FormClose
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 900
    Height = 550
    ActivePage = tsUsers
    Align = alClient
    object tsUsers: TTabSheet
      Caption = 'Korisnici'
      object sgUsers: TStringGrid
        Left = 10
        Top = 10
        Width = 870
        Height = 350
        ColCount = 5
        RowCount = 2
        TabOrder = 0
      end
      object btnAddUser: TButton
        Left = 10
        Top = 370
        Width = 100
        Height = 30
        Caption = 'Dodaj korisnika'
        OnClick = btnAddUserClick
        TabOrder = 1
      end
      object btnEditUser: TButton
        Left = 120
        Top = 370
        Width = 100
        Height = 30
        Caption = 'Ažuriraj'
        OnClick = btnEditUserClick
        TabOrder = 2
      end
      object btnDeleteUser: TButton
        Left = 230
        Top = 370
        Width = 100
        Height = 30
        Caption = 'Obriši'
        OnClick = btnDeleteUserClick
        TabOrder = 3
      end
      object btnRefreshUsers: TButton
        Left = 340
        Top = 370
        Width = 100
        Height = 30
        Caption = 'Osveži'
        OnClick = btnRefreshUsersClick
        TabOrder = 4
      end
    end
    object tsRoles: TTabSheet
      Caption = 'Uloge'
      ImageIndex = 1
      object sgRoles: TStringGrid
        Left = 10
        Top = 10
        Width = 870
        Height = 350
        ColCount = 3
        RowCount = 2
        TabOrder = 0
      end
      object btnAddRole: TButton
        Left = 10
        Top = 370
        Width = 100
        Height = 30
        Caption = 'Dodaj ulogu'
        TabOrder = 1
      end
      object btnEditRole: TButton
        Left = 120
        Top = 370
        Width = 100
        Height = 30
        Caption = 'Ažuriraj'
        TabOrder = 2
      end
      object btnDeleteRole: TButton
        Left = 230
        Top = 370
        Width = 100
        Height = 30
        Caption = 'Obriši'
        TabOrder = 3
      end
    end
    object tsActivityLog: TTabSheet
      Caption = 'Log aktivnosti'
      ImageIndex = 2
      object lblFrom: TLabel
        Left = 10
        Top = 10
        Width = 30
        Height = 13
        Caption = 'Od:'
      end
      object lblTo: TLabel
        Left = 200
        Top = 10
        Width = 20
        Height = 13
        Caption = 'Do:'
      end
      object dtpFrom: TDateTimePicker
        Left = 50
        Top = 10
        Width = 130
        Height = 21
        Date = 45541.000000000000000000
        Time = 0.000000000000000000
        TabOrder = 0
      end
      object dtpTo: TDateTimePicker
        Left = 230
        Top = 10
        Width = 130
        Height = 21
        Date = 45541.000000000000000000
        Time = 0.000000000000000000
        TabOrder = 1
      end
      object btnRefreshLog: TButton
        Left = 380
        Top = 10
        Width = 100
        Height = 21
        Caption = 'Osveži log'
        OnClick = btnRefreshLogClick
        TabOrder = 2
      end
      object sgActivityLog: TStringGrid
        Left = 10
        Top = 40
        Width = 870
        Height = 350
        ColCount = 6
        RowCount = 2
        TabOrder = 3
      end
    end
    object tsSettings: TTabSheet
      Caption = 'Postavke'
      ImageIndex = 3
      object lblVersion: TLabel
        Left = 20
        Top = 20
        Width = 100
        Height = 13
        Caption = 'Verzija: 1.0.0'
      end
      object btnBackup: TButton
        Left = 20
        Top = 50
        Width = 150
        Height = 30
        Caption = 'Backup baze'
        OnClick = btnBackupClick
        TabOrder = 0
      end
      object btnLogout: TButton
        Left = 20
        Top = 90
        Width = 150
        Height = 30
        Caption = 'Odjava'
        OnClick = btnLogoutClick
        TabOrder = 1
      end
    end
  end
end
