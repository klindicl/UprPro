object MainForm: TMainForm
  Caption = 'Upravljanje proizvodnjom - operativni centar'
  ClientHeight = 720
  ClientWidth = 1180
  Position = poScreenCenter
  OnCreate = FormCreate
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1180
    Height = 670
    Align = alClient
    ActivePage = tsDashboard
    TabOrder = 0
    OnChange = PageControl1Change
    object tsDashboard: TTabSheet
      Caption = 'Pregled'
      object lblDashboardTitle: TLabel
        Left = 25
        Top = 20
        Width = 500
        Height = 24
        Caption = 'OPERATIVNI CENTAR PROIZVODNJE'
        Font.Style = [fsBold]
        Font.Size = 14
      end
      object lblDashboardHint: TLabel
        Left = 25
        Top = 55
        Width = 700
        Height = 30
        Caption = 'Tok procesa: narudžbina -> planiranje -> proizvodnja -> resursi -> isporuka'
      end
      object pnlKPI1: TPanel
        Left = 25
        Top = 105
        Width = 250
        Height = 100
        TabOrder = 0
        object lblKPI1: TLabel
          Left = 15
          Top = 25
          Width = 220
          Height = 50
          Caption = 'OTVORENE NARUDŽBINE'#13#10'0'
          Font.Style = [fsBold]
          WordWrap = True
        end
      end
      object pnlKPI2: TPanel
        Left = 295
        Top = 105
        Width = 250
        Height = 100
        TabOrder = 1
        object lblKPI2: TLabel
          Left = 15
          Top = 25
          Width = 220
          Height = 50
          Caption = 'AKTIVNA PROIZVODNJA'#13#10'0'
          Font.Style = [fsBold]
          WordWrap = True
        end
      end
      object pnlKPI3: TPanel
        Left = 565
        Top = 105
        Width = 250
        Height = 100
        TabOrder = 2
        object lblKPI3: TLabel
          Left = 15
          Top = 25
          Width = 220
          Height = 50
          Caption = 'NISKO STANJE ZALIHA'#13#10'0'
          Font.Style = [fsBold]
          WordWrap = True
        end
      end
      object pnlKPI4: TPanel
        Left = 835
        Top = 105
        Width = 250
        Height = 100
        TabOrder = 3
        object lblKPI4: TLabel
          Left = 15
          Top = 25
          Width = 220
          Height = 50
          Caption = 'DOSTUPNI RESURSI'#13#10'0'
          Font.Style = [fsBold]
          WordWrap = True
        end
      end
      object lblLowStock: TLabel
        Left = 25
        Top = 240
        Width = 800
        Height = 24
        Caption = 'Kontrola zaliha'
      end
    end
    object tsOrders: TTabSheet
      Caption = 'Narudžbine'
      object sgOrders: TStringGrid
        Left = 15
        Top = 15
        Width = 1125
        Height = 520
        ColCount = 7
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
      end
      object btnNewOrder: TButton
        Left = 15
        Top = 550
        Width = 145
        Height = 35
        Caption = 'Nova narudžbina'
        OnClick = btnNewOrderClick
        TabOrder = 1
      end
      object btnOrderStatus: TButton
        Left = 170
        Top = 550
        Width = 145
        Height = 35
        Caption = 'Promeni status'
        OnClick = btnOrderStatusClick
        TabOrder = 2
      end
      object btnRefreshOrders: TButton
        Left = 325
        Top = 550
        Width = 100
        Height = 35
        Caption = 'Osveži'
        OnClick = btnRefreshOrdersClick
        TabOrder = 3
      end
    end
    object tsProduction: TTabSheet
      Caption = 'Proizvodni nalozi'
      object sgProduction: TStringGrid
        Left = 15
        Top = 15
        Width = 1125
        Height = 500
        ColCount = 7
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
      end
      object btnNewJob: TButton
        Left = 15
        Top = 530
        Width = 145
        Height = 35
        Caption = 'Novi nalog'
        OnClick = btnNewJobClick
        TabOrder = 1
      end
      object btnProduction: TButton
        Left = 170
        Top = 530
        Width = 175
        Height = 35
        Caption = 'Evidentiraj proizvodnju'
        OnClick = btnProductionClick
        TabOrder = 2
      end
      object btnJobStatus: TButton
        Left = 355
        Top = 530
        Width = 135
        Height = 35
        Caption = 'Status naloga'
        OnClick = btnJobStatusClick
        TabOrder = 3
      end
      object btnAssignResource: TButton
        Left = 500
        Top = 530
        Width = 145
        Height = 35
        Caption = 'Dodeli resurs'
        OnClick = btnAssignResourceClick
        TabOrder = 4
      end
      object btnRefreshJobs: TButton
        Left = 655
        Top = 530
        Width = 100
        Height = 35
        Caption = 'Osveži'
        OnClick = btnRefreshJobsClick
        TabOrder = 5
      end
    end
    object tsProducts: TTabSheet
      Caption = 'Proizvodi / zalihe'
      object sgProducts: TStringGrid
        Left = 15
        Top = 15
        Width = 1125
        Height = 500
        ColCount = 6
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
      end
      object btnNewProduct: TButton
        Left = 15
        Top = 530
        Width = 145
        Height = 35
        Caption = 'Novi proizvod'
        OnClick = btnNewProductClick
        TabOrder = 1
      end
      object btnStockIn: TButton
        Left = 170
        Top = 530
        Width = 145
        Height = 35
        Caption = 'Prijem na lager'
        OnClick = btnStockInClick
        TabOrder = 2
      end
      object btnRefreshProducts: TButton
        Left = 325
        Top = 530
        Width = 100
        Height = 35
        Caption = 'Osveži'
        OnClick = btnRefreshProductsClick
        TabOrder = 3
      end
    end
    object tsResources: TTabSheet
      Caption = 'Resursi'
      object sgResources: TStringGrid
        Left = 15
        Top = 15
        Width = 1125
        Height = 500
        ColCount = 4
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
      end
      object btnNewResource: TButton
        Left = 15
        Top = 530
        Width = 145
        Height = 35
        Caption = 'Novi resurs'
        OnClick = btnNewResourceClick
        TabOrder = 1
      end
      object btnResourceStatus: TButton
        Left = 170
        Top = 530
        Width = 145
        Height = 35
        Caption = 'Promeni status'
        OnClick = btnResourceStatusClick
        TabOrder = 2
      end
      object btnRefreshResources: TButton
        Left = 325
        Top = 530
        Width = 100
        Height = 35
        Caption = 'Osveži'
        OnClick = btnRefreshResourcesClick
        TabOrder = 3
      end
    end
    object tsReports: TTabSheet
      Caption = 'Izveštaji / KPI'
      object sgReports: TStringGrid
        Left = 15
        Top = 15
        Width = 1125
        Height = 500
        ColCount = 3
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
        TabOrder = 0
      end
      object btnRefreshReports: TButton
        Left = 15
        Top = 530
        Width = 125
        Height = 35
        Caption = 'Osveži KPI'
        OnClick = btnRefreshReportsClick
        TabOrder = 1
      end
    end
  end
  object btnBack: TButton
    Left = 10
    Top = 680
    Width = 100
    Height = 30
    Align = alBottom
    Caption = 'Nazad'
    OnClick = btnBackClick
    TabOrder = 1
  end
end
