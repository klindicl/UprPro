unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.ExtCtrls,
  DatabaseUnit, ActivityLoggerUnit, Data.DB, FireDAC.Comp.Client;

type
  TMainForm = class(TForm)
    PageControl1: TPageControl;
    tsDashboard: TTabSheet;
    tsOrders: TTabSheet;
    tsProduction: TTabSheet;
    tsProducts: TTabSheet;
    tsResources: TTabSheet;
    tsReports: TTabSheet;
    pnlKPI1: TPanel;
    pnlKPI2: TPanel;
    pnlKPI3: TPanel;
    pnlKPI4: TPanel;
    lblKPI1: TLabel;
    lblKPI2: TLabel;
    lblKPI3: TLabel;
    lblKPI4: TLabel;
    lblDashboardTitle: TLabel;
    lblLowStock: TLabel;
    lblDashboardHint: TLabel;
    sgOrders: TStringGrid;
    btnNewOrder: TButton;
    btnOrderStatus: TButton;
    btnRefreshOrders: TButton;
    btnBackOrders: TButton;
    sgProduction: TStringGrid;
    btnNewJob: TButton;
    btnProduction: TButton;
    btnJobStatus: TButton;
    btnAssignResource: TButton;
    btnRefreshJobs: TButton;
    sgProducts: TStringGrid;
    btnNewProduct: TButton;
    btnStockIn: TButton;
    btnRefreshProducts: TButton;
    sgResources: TStringGrid;
    btnNewResource: TButton;
    btnResourceStatus: TButton;
    btnRefreshResources: TButton;
    sgReports: TStringGrid;
    btnRefreshReports: TButton;
    btnBack: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshOrdersClick(Sender: TObject);
    procedure btnNewOrderClick(Sender: TObject);
    procedure btnOrderStatusClick(Sender: TObject);
    procedure btnRefreshJobsClick(Sender: TObject);
    procedure btnNewJobClick(Sender: TObject);
    procedure btnProductionClick(Sender: TObject);
    procedure btnJobStatusClick(Sender: TObject);
    procedure btnAssignResourceClick(Sender: TObject);
    procedure btnRefreshProductsClick(Sender: TObject);
    procedure btnNewProductClick(Sender: TObject);
    procedure btnStockInClick(Sender: TObject);
    procedure btnRefreshResourcesClick(Sender: TObject);
    procedure btnNewResourceClick(Sender: TObject);
    procedure btnResourceStatusClick(Sender: TObject);
    procedure btnRefreshReportsClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    function SqlQuote(const S: string): string;
    function SelectedId(Grid: TStringGrid): Integer;
    function AskStatus(const ATitle, ACurrent: string): string;
    function SqlNullableInt(const S: string): string;
    procedure SetupGrid(Grid: TStringGrid; const Headers: array of string);
    procedure RefreshDashboard;
  end;

var
  MainForm: TMainForm;

implementation

uses HomeUnit, LoginUnit;

{$R *.dfm}

function TMainForm.SqlQuote(const S: string): string;
begin
  Result := StringReplace(S, '''', '''''', [rfReplaceAll]);
end;

procedure TMainForm.SetupGrid(Grid: TStringGrid; const Headers: array of string);
var
  I: Integer;
begin
  Grid.ColCount := Length(Headers);
  // Mora postojati najmanje jedan red za zaglavlje pre FixedRows := 1.
  Grid.RowCount := 2;
  Grid.FixedRows := 1;
  for I := 0 to High(Headers) do
    Grid.Cells[I, 0] := Headers[I];
  Grid.Options := Grid.Options + [goRowSelect, goColSizing];
end;

function TMainForm.SelectedId(Grid: TStringGrid): Integer;
begin
  Result := 0;
  if Grid.Row > 0 then
    Result := StrToIntDef(Grid.Cells[0, Grid.Row], 0);
end;

function TMainForm.SqlNullableInt(const S: string): string;
begin
  if Trim(S) = '' then Result := 'NULL' else Result := S;
end;

function TMainForm.AskStatus(const ATitle, ACurrent: string): string;
begin
  Result := InputBox(ATitle,
    'Unesite status (NEW, IN_PROGRESS, COMPLETED, CANCELLED):', ACurrent);
  Result := UpperCase(Trim(Result));
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption := 'Upravljanje proizvodnjom - operativni centar';
  SetupGrid(sgOrders, ['ID','Broj naloga','Kupac','Datum','Rok','Status','Vrednost']);
  SetupGrid(sgProduction, ['ID','Proizvodni nalog','Proizvod','Planirano','Proizvedeno','Status','Rok']);
  SetupGrid(sgProducts, ['ID','Proizvod','SKU','Cena','Stanje','Minimum']);
  SetupGrid(sgResources, ['ID','Resurs','Tip','Status']);
  SetupGrid(sgReports, ['Pokazatelj','Vrednost','Opis']);

  RefreshDashboard;
  btnRefreshOrdersClick(nil);
  btnRefreshJobsClick(nil);
  btnRefreshProductsClick(nil);
  btnRefreshResourcesClick(nil);
  btnRefreshReportsClick(nil);
end;

procedure TMainForm.RefreshDashboard;
var
  Q: TFDQuery;
begin
  if not DatabaseManager.IsConnected then
  begin
    lblKPI1.Caption := 'NEMA BAZE';
    lblKPI2.Caption := '-';
    lblKPI3.Caption := '-';
    lblKPI4.Caption := '-';
    Exit;
  end;

  Q := DatabaseManager.ExecuteQuery(
    'SELECT ' +
    '(SELECT COUNT(*) FROM Orders WHERE Status <> ''COMPLETED'' AND Status <> ''CANCELLED'') AS OpenOrders, ' +
    '(SELECT COUNT(*) FROM ProductionJobs WHERE Status IN (''PLANNING'',''IN_PROGRESS'')) AS ActiveJobs, ' +
    '(SELECT COUNT(*) FROM Products WHERE Quantity <= COALESCE(ReorderLevel,0)) AS LowStock, ' +
    '(SELECT COUNT(*) FROM Resources WHERE Status = ''AVAILABLE'') AS AvailableResources');
  try
    lblKPI1.Caption := 'OTVORENE NARUDŽBINE' + #13#10 + Q.FieldByName('OpenOrders').AsString;
    lblKPI2.Caption := 'AKTIVNA PROIZVODNJA' + #13#10 + Q.FieldByName('ActiveJobs').AsString;
    lblKPI3.Caption := 'NISKO STANJE ZALIHA' + #13#10 + Q.FieldByName('LowStock').AsString;
    lblKPI4.Caption := 'DOSTUPNI RESURSI' + #13#10 + Q.FieldByName('AvailableResources').AsString;
    lblLowStock.Caption := 'Kontrola zaliha: ' + Q.FieldByName('LowStock').AsString +
      ' artikala je na ili ispod minimalnog nivoa.';
  finally
    Q.Free;
  end;
end;

procedure TMainForm.btnRefreshOrdersClick(Sender: TObject);
var Q: TFDQuery; R: Integer;
begin
  if not DatabaseManager.IsConnected then Exit;
  sgOrders.RowCount := 2;
  Q := DatabaseManager.ExecuteQuery(
    'SELECT Id, COALESCE(OrderNumber,''-'') OrderNumber, COALESCE(CustomerId,0) CustomerId, ' +
    'strftime(''%d.%m.%Y'',OrderDate) OrderDate, strftime(''%d.%m.%Y'',DueDate) DueDate, ' +
    'Status, COALESCE(TotalAmount,0) TotalAmount FROM Orders ORDER BY DueDate, Id DESC');
  try
    R := 1;
    while not Q.Eof do begin
      sgOrders.RowCount := R + 1;
      sgOrders.Cells[0,R] := Q.FieldByName('Id').AsString;
      sgOrders.Cells[1,R] := Q.FieldByName('OrderNumber').AsString;
      sgOrders.Cells[2,R] := Q.FieldByName('CustomerId').AsString;
      sgOrders.Cells[3,R] := Q.FieldByName('OrderDate').AsString;
      sgOrders.Cells[4,R] := Q.FieldByName('DueDate').AsString;
      sgOrders.Cells[5,R] := Q.FieldByName('Status').AsString;
      sgOrders.Cells[6,R] := FormatFloat('0.00', Q.FieldByName('TotalAmount').AsFloat);
      Inc(R); Q.Next;
    end;
  finally Q.Free end;
end;

procedure TMainForm.btnNewOrderClick(Sender: TObject);
var Num, Customer, Due, Total: string; D: TDateTime;
begin
  Num := InputBox('Nova narudžbina','Broj narudžbine:','ORD-'+FormatDateTime('yyyymmdd-hhnnss',Now));
  if Num='' then Exit;
  Customer := InputBox('Nova narudžbina','ID kupca (opciono):','');
  Due := InputBox('Nova narudžbina','Rok isporuke (dd.mm.yyyy):',FormatDateTime('dd.mm.yyyy',Now+7));
  if not TryStrToDate(Due,D) then D := Now+7;
  Total := InputBox('Nova narudžbina','Ukupna vrednost:','0');
  Total := StringReplace(Total,',','.',[rfReplaceAll]);
  if DatabaseManager.ExecuteNonQuery(Format(
    'INSERT INTO Orders (OrderNumber,OrderDate,CustomerId,Status,TotalAmount,DueDate,CreatedBy) '+
    'VALUES (''%s'',CURRENT_TIMESTAMP,%s,''NEW'',%s,''%s'',%d)',
    [SqlQuote(Num), SqlNullableInt(Customer), StringReplace(Total,'''','',[rfReplaceAll]),
     FormatDateTime('yyyy-mm-dd',D), CurrentUserId])) then
  begin
    if Assigned(ActivityLogger) then ActivityLogger.LogActivity(atCreate,'Kreirana narudžbina '+Num,'Orders');
    btnRefreshOrdersClick(nil); RefreshDashboard;
  end;
end;

procedure TMainForm.btnOrderStatusClick(Sender: TObject);
var ID: Integer; S: string;
begin
  ID := SelectedId(sgOrders); if ID=0 then begin ShowMessage('Izaberite narudžbinu.'); Exit end;
  S := AskStatus('Status narudžbine',sgOrders.Cells[5,sgOrders.Row]);
  if S='' then Exit;
  if DatabaseManager.ExecuteNonQuery(Format('UPDATE Orders SET Status=''%s'', ModifiedDate=CURRENT_TIMESTAMP WHERE Id=%d',[SqlQuote(S),ID])) then
  begin
    if Assigned(ActivityLogger) then ActivityLogger.LogDataChange('UPDATE','Orders',ID,'Promenjen status narudžbine');
    btnRefreshOrdersClick(nil); RefreshDashboard;
  end;
end;

procedure TMainForm.btnRefreshJobsClick(Sender: TObject);
var Q: TFDQuery; R: Integer;
begin
  if not DatabaseManager.IsConnected then Exit;
  sgProduction.RowCount := 2;
  Q := DatabaseManager.ExecuteQuery(
    'SELECT pj.Id,pj.JobNumber,COALESCE(p.ProductName,''-'') ProductName,pj.Quantity,pj.QuantityProduced,'+
    'pj.Status,strftime(''%d.%m.%Y'',pj.EstimatedDate) EstimatedDate '+
    'FROM ProductionJobs pj LEFT JOIN Products p ON p.Id=pj.ProductId ORDER BY pj.EstimatedDate,pj.Id DESC');
  try
    R:=1;
    while not Q.Eof do begin
      sgProduction.RowCount:=R+1;
      sgProduction.Cells[0,R]:=Q.FieldByName('Id').AsString;
      sgProduction.Cells[1,R]:=Q.FieldByName('JobNumber').AsString;
      sgProduction.Cells[2,R]:=Q.FieldByName('ProductName').AsString;
      sgProduction.Cells[3,R]:=Q.FieldByName('Quantity').AsString;
      sgProduction.Cells[4,R]:=Q.FieldByName('QuantityProduced').AsString;
      sgProduction.Cells[5,R]:=Q.FieldByName('Status').AsString;
      sgProduction.Cells[6,R]:=Q.FieldByName('EstimatedDate').AsString;
      Inc(R); Q.Next;
    end;
  finally Q.Free end;
end;

procedure TMainForm.btnNewJobClick(Sender: TObject);
var OrderId, ProductId, Qty, Job, Est: string; D: TDateTime;
begin
  Job:=InputBox('Novi proizvodni nalog','Broj naloga:','PROD-'+FormatDateTime('yyyymmdd-hhnnss',Now));
  if Job='' then Exit;
  OrderId:=InputBox('Novi proizvodni nalog','ID narudžbine (opciono):','');
  ProductId:=InputBox('Novi proizvodni nalog','ID proizvoda:','');
  Qty:=InputBox('Novi proizvodni nalog','Planirana količina:','1');
  Est:=InputBox('Novi proizvodni nalog','Planirani završetak (dd.mm.yyyy):',FormatDateTime('dd.mm.yyyy',Now+3));
  if not TryStrToDate(Est,D) then D:=Now+3;
  if ProductId='' then begin ShowMessage('ID proizvoda je obavezan.'); Exit end;
  if DatabaseManager.ExecuteNonQuery(Format(
    'INSERT INTO ProductionJobs(JobNumber,OrderId,ProductId,Quantity,Status,EstimatedDate,CreatedDate) '+
    'VALUES(''%s'',%s,%s,%s,''PLANNING'',''%s'',CURRENT_TIMESTAMP)',
    [SqlQuote(Job),SqlNullableInt(OrderId),ProductId,Qty,FormatDateTime('yyyy-mm-dd',D)])) then
  begin
    if Assigned(ActivityLogger) then ActivityLogger.LogActivity(atCreate,'Kreiran proizvodni nalog '+Job,'ProductionJobs');
    btnRefreshJobsClick(nil); RefreshDashboard;
  end;
end;

procedure TMainForm.btnProductionClick(Sender: TObject);
var ID, Qty, Produced: Integer;
begin
  ID:=SelectedId(sgProduction); if ID=0 then begin ShowMessage('Izaberite proizvodni nalog.'); Exit end;
  Qty:=StrToIntDef(InputBox('Evidencija proizvodnje','Koliko komada je upravo proizvedeno?','1'),0);
  if Qty<=0 then Exit;
  Produced:=StrToIntDef(sgProduction.Cells[4,sgProduction.Row],0)+Qty;
  if DatabaseManager.ExecuteNonQuery(Format(
    'UPDATE ProductionJobs SET QuantityProduced=%d, Status=CASE WHEN %d>=Quantity THEN ''COMPLETED'' ELSE ''IN_PROGRESS'' END, '+
    'StartDate=COALESCE(StartDate,CURRENT_TIMESTAMP), EndDate=CASE WHEN %d>=Quantity THEN CURRENT_TIMESTAMP ELSE EndDate END, ModifiedDate=CURRENT_TIMESTAMP WHERE Id=%d',
    [Produced,Produced,Produced,ID])) then
  begin
    DatabaseManager.ExecuteNonQuery(Format(
      'UPDATE Products SET Quantity=Quantity+%d, ModifiedDate=CURRENT_TIMESTAMP WHERE Id=%s',
      [Qty, sgProduction.Cells[0,sgProduction.Row]]));
    if Assigned(ActivityLogger) then ActivityLogger.LogDataChange('UPDATE','ProductionJobs',ID,'Evidentirana proizvodnja: '+IntToStr(Qty));
    btnRefreshJobsClick(nil);
    btnRefreshProductsClick(nil);
    RefreshDashboard;
  end;
end;

procedure TMainForm.btnJobStatusClick(Sender: TObject);
var ID: Integer; S: string;
begin
  ID:=SelectedId(sgProduction); if ID=0 then begin ShowMessage('Izaberite nalog.'); Exit end;
  S:=AskStatus('Status proizvodnog naloga',sgProduction.Cells[5,sgProduction.Row]); if S='' then Exit;
  if DatabaseManager.ExecuteNonQuery(Format('UPDATE ProductionJobs SET Status=''%s'',ModifiedDate=CURRENT_TIMESTAMP WHERE Id=%d',[SqlQuote(S),ID])) then
  begin
    btnRefreshJobsClick(nil); RefreshDashboard;
  end;
end;

procedure TMainForm.btnAssignResourceClick(Sender: TObject);
var JobId, ResourceId: string;
begin
  JobId:=InputBox('Dodela resursa','ID proizvodnog naloga:','');
  ResourceId:=InputBox('Dodela resursa','ID resursa:','');
  if (JobId='') or (ResourceId='') then Exit;
  if DatabaseManager.ExecuteNonQuery(Format('INSERT INTO JobResources(JobId,ResourceId) VALUES(%s,%s)',[JobId,ResourceId])) then
  begin
    DatabaseManager.ExecuteNonQuery(Format('UPDATE Resources SET Status=''IN_USE'',ModifiedDate=CURRENT_TIMESTAMP WHERE Id=%s',[ResourceId]));
    if Assigned(ActivityLogger) then ActivityLogger.LogActivity(atUpdate,'Dodeljen resurs '+ResourceId+' nalogu '+JobId,'JobResources');
    ShowMessage('Resurs je dodeljen proizvodnom nalogu.');
    btnRefreshResourcesClick(nil); RefreshDashboard;
  end;
end;

procedure TMainForm.btnRefreshProductsClick(Sender: TObject);
var Q:TFDQuery; R:Integer;
begin
  if not DatabaseManager.IsConnected then Exit;
  sgProducts.RowCount:=2;
  Q:=DatabaseManager.ExecuteQuery('SELECT Id,ProductName,COALESCE(SKU,''-'') SKU,COALESCE(Price,0) Price,Quantity,COALESCE(ReorderLevel,0) ReorderLevel FROM Products ORDER BY ProductName');
  try
    R:=1; while not Q.Eof do begin
      sgProducts.RowCount:=R+1;
      sgProducts.Cells[0,R]:=Q.FieldByName('Id').AsString;
      sgProducts.Cells[1,R]:=Q.FieldByName('ProductName').AsString;
      sgProducts.Cells[2,R]:=Q.FieldByName('SKU').AsString;
      sgProducts.Cells[3,R]:=FormatFloat('0.00',Q.FieldByName('Price').AsFloat);
      sgProducts.Cells[4,R]:=Q.FieldByName('Quantity').AsString;
      sgProducts.Cells[5,R]:=Q.FieldByName('ReorderLevel').AsString;
      Inc(R); Q.Next;
    end;
  finally Q.Free end;
end;

procedure TMainForm.btnNewProductClick(Sender: TObject);
var N,SKU,Price,Qty,Min: string;
begin
  N:=InputBox('Novi proizvod','Naziv:',''); if N='' then Exit;
  SKU:=InputBox('Novi proizvod','SKU:','');
  Price:=StringReplace(InputBox('Novi proizvod','Cena:','0'),',','.',[rfReplaceAll]);
  Qty:=InputBox('Novi proizvod','Početno stanje:','0');
  Min:=InputBox('Novi proizvod','Minimalno stanje:','0');
  if DatabaseManager.ExecuteNonQuery(Format(
    'INSERT INTO Products(ProductName,SKU,Price,Quantity,ReorderLevel,CreatedDate) VALUES(''%s'',''%s'',%s,%s,%s,CURRENT_TIMESTAMP)',
    [SqlQuote(N),SqlQuote(SKU),Price,Qty,Min])) then begin
    btnRefreshProductsClick(nil); RefreshDashboard;
  end;
end;

procedure TMainForm.btnStockInClick(Sender: TObject);
var ID,Qty: Integer;
begin
  ID:=SelectedId(sgProducts); if ID=0 then begin ShowMessage('Izaberite proizvod.'); Exit end;
  Qty:=StrToIntDef(InputBox('Prijem na lager','Količina za prijem:','1'),0); if Qty<=0 then Exit;
  if DatabaseManager.ExecuteNonQuery(Format('UPDATE Products SET Quantity=Quantity+%d,ModifiedDate=CURRENT_TIMESTAMP WHERE Id=%d',[Qty,ID])) then begin
    if Assigned(ActivityLogger) then ActivityLogger.LogDataChange('UPDATE','Products',ID,'Prijem na lager: '+IntToStr(Qty));
    btnRefreshProductsClick(nil); RefreshDashboard;
  end;
end;

procedure TMainForm.btnRefreshResourcesClick(Sender: TObject);
var Q:TFDQuery; R:Integer;
begin
  if not DatabaseManager.IsConnected then Exit;
  sgResources.RowCount:=2;
  Q:=DatabaseManager.ExecuteQuery('SELECT Id,ResourceName,ResourceType,Status FROM Resources ORDER BY ResourceType,ResourceName');
  try
    R:=1; while not Q.Eof do begin
      sgResources.RowCount:=R+1;
      sgResources.Cells[0,R]:=Q.FieldByName('Id').AsString;
      sgResources.Cells[1,R]:=Q.FieldByName('ResourceName').AsString;
      sgResources.Cells[2,R]:=Q.FieldByName('ResourceType').AsString;
      sgResources.Cells[3,R]:=Q.FieldByName('Status').AsString;
      Inc(R); Q.Next;
    end;
  finally Q.Free end;
end;

procedure TMainForm.btnNewResourceClick(Sender: TObject);
var N,T:string;
begin
  N:=InputBox('Novi resurs','Naziv resursa:',''); if N='' then Exit;
  T:=UpperCase(InputBox('Novi resurs','Tip (MACHINE, WORKER, MATERIAL):','MACHINE'));
  if DatabaseManager.ExecuteNonQuery(Format('INSERT INTO Resources(ResourceName,ResourceType,Status) VALUES(''%s'',''%s'',''AVAILABLE'')',[SqlQuote(N),SqlQuote(T)])) then begin
    btnRefreshResourcesClick(nil); RefreshDashboard;
  end;
end;

procedure TMainForm.btnResourceStatusClick(Sender: TObject);
var ID:Integer; S:string;
begin
  ID:=SelectedId(sgResources); if ID=0 then begin ShowMessage('Izaberite resurs.'); Exit end;
  S:=UpperCase(InputBox('Status resursa','AVAILABLE, IN_USE, MAINTENANCE, UNAVAILABLE:',sgResources.Cells[3,sgResources.Row]));
  if S='' then Exit;
  if DatabaseManager.ExecuteNonQuery(Format('UPDATE Resources SET Status=''%s'',ModifiedDate=CURRENT_TIMESTAMP WHERE Id=%d',[SqlQuote(S),ID])) then begin
    btnRefreshResourcesClick(nil); RefreshDashboard;
  end;
end;

procedure TMainForm.btnRefreshReportsClick(Sender: TObject);
var Q:TFDQuery; R:Integer;
begin
  if not DatabaseManager.IsConnected then Exit;
  sgReports.RowCount:=2;
  Q:=DatabaseManager.ExecuteQuery(
    'SELECT ''Ukupno proizvoda'' M, CAST(COUNT(*) AS TEXT) V, ''Broj artikala u šifarniku'' D FROM Products '+
    'UNION ALL SELECT ''Ukupna zaliha'',CAST(COALESCE(SUM(Quantity),0) AS varchar),''Ukupna količina na lageru'' FROM Products '+
    'UNION ALL SELECT ''Završeni nalozi'',CAST(COUNT(*) AS TEXT),''Proizvodni nalozi sa statusom COMPLETED'' FROM ProductionJobs WHERE Status=''COMPLETED'' '+
    'UNION ALL SELECT ''Otvorene narudžbine'',CAST(COUNT(*) AS TEXT),''Narudžbine koje još nisu završene'' FROM Orders WHERE Status NOT IN (''COMPLETED'',''CANCELLED'') '+
    'UNION ALL SELECT ''Iskorišćenost resursa'',CAST(COUNT(*) AS TEXT),''Trenutno zauzeti resursi'' FROM Resources WHERE Status=''IN_USE''');
  try
    R:=1; while not Q.Eof do begin
      sgReports.RowCount:=R+1;
      sgReports.Cells[0,R]:=Q.FieldByName('M').AsString;
      sgReports.Cells[1,R]:=Q.FieldByName('V').AsString;
      sgReports.Cells[2,R]:=Q.FieldByName('D').AsString;
      Inc(R); Q.Next;
    end;
  finally Q.Free end;
end;

procedure TMainForm.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: RefreshDashboard;
    1: btnRefreshOrdersClick(nil);
    2: btnRefreshJobsClick(nil);
    3: btnRefreshProductsClick(nil);
    4: btnRefreshResourcesClick(nil);
    5: btnRefreshReportsClick(nil);
  end;
end;

procedure TMainForm.btnBackClick(Sender: TObject);
begin
  HomeForm.Show;
  Hide;
end;

end.
