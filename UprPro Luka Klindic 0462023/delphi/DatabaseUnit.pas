unit DatabaseUnit;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.DApt,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLiteWrapper.Stat;

type
  TDatabaseManager = class
  private
    FConnection: TFDConnection;
    FSQLiteLink: TFDPhysSQLiteDriverLink;
    FConnected: Boolean;
    FDatabaseFile: string;
    procedure CreateSchema;
    procedure SeedData;
  public
    constructor Create;
    destructor Destroy; override;
    function Connect(AServer, ADatabase, AUsername, APassword: string): Boolean;
    function Disconnect: Boolean;
    function IsConnected: Boolean;
    function ExecuteQuery(AQuery: string): TFDQuery;
    function ExecuteNonQuery(AQuery: string): Boolean;
    property Connection: TFDConnection read FConnection;
    property DatabaseFile: string read FDatabaseFile;
  end;

var
  DatabaseManager: TDatabaseManager;

implementation

constructor TDatabaseManager.Create;
begin
  inherited Create;
  FConnected := False;
  FConnection := TFDConnection.Create(nil);
  FSQLiteLink := TFDPhysSQLiteDriverLink.Create(nil);
  FSQLiteLink.DriverID := 'SQLite';
  FConnection.LoginPrompt := False;
end;

destructor TDatabaseManager.Destroy;
begin
  Disconnect;
  FSQLiteLink.Free;
  FConnection.Free;
  inherited;
end;

function TDatabaseManager.Connect(AServer, ADatabase, AUsername, APassword: string): Boolean;
var
  DataDir: string;
begin
  Result := False;
  try
    { Lokalna SQLite baza: nema SQL Servera, korisnika sa, OLE DB-a ni instalacije servera. }
    DataDir := GetEnvironmentVariable('LOCALAPPDATA');
    if DataDir = '' then DataDir := ExtractFilePath(ParamStr(0));
    DataDir := TPath.Combine(DataDir, 'UprPro');
    ForceDirectories(DataDir);
    FDatabaseFile := TPath.Combine(DataDir, 'UprPro.db');
    FConnection.Connected := False;
    FConnection.Params.Clear;
    FConnection.Params.DriverID := 'SQLite';
    FConnection.Params.Database := FDatabaseFile;
    FConnection.Params.Add('LockingMode=Normal');
    FConnection.Params.Add('Synchronous=Normal');
    FConnection.Params.Add('ForeignKeys=ON');
    FConnection.Connected := True;
    FConnected := True;
    CreateSchema;
    SeedData;
    Result := True;
  except
    on E: Exception do
    begin
      FConnected := False;
      Result := False;
    end;
  end;
end;

procedure TDatabaseManager.CreateSchema;
const
  Statements: array[0..17] of string = (
    'CREATE TABLE IF NOT EXISTS Users (Id INTEGER PRIMARY KEY AUTOINCREMENT, Username TEXT NOT NULL UNIQUE, Password TEXT NOT NULL, Email TEXT, Role TEXT NOT NULL DEFAULT ''USER'', IsActive INTEGER NOT NULL DEFAULT 1, CreatedDate TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, LastLogin TEXT, ModifiedDate TEXT)',
    'CREATE TABLE IF NOT EXISTS Roles (Id INTEGER PRIMARY KEY AUTOINCREMENT, RoleName TEXT NOT NULL UNIQUE, Description TEXT, Permissions TEXT, CreatedDate TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP)',
    'CREATE TABLE IF NOT EXISTS ActivityLog (Id INTEGER PRIMARY KEY AUTOINCREMENT, UserId INTEGER, Username TEXT, ActivityType TEXT NOT NULL, Description TEXT, TableName TEXT, RecordId INTEGER, ActivityDate TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, IPAddress TEXT, FOREIGN KEY(UserId) REFERENCES Users(Id))',
    'CREATE TABLE IF NOT EXISTS Products (Id INTEGER PRIMARY KEY AUTOINCREMENT, ProductName TEXT NOT NULL, Description TEXT, SKU TEXT UNIQUE, Price REAL, Quantity INTEGER NOT NULL DEFAULT 0, ReorderLevel INTEGER, CreatedDate TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, ModifiedDate TEXT)',
    'CREATE TABLE IF NOT EXISTS Orders (Id INTEGER PRIMARY KEY AUTOINCREMENT, OrderNumber TEXT UNIQUE, OrderDate TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, CustomerId INTEGER, Status TEXT NOT NULL DEFAULT ''NEW'', TotalAmount REAL, Description TEXT, DueDate TEXT, CreatedBy INTEGER, ModifiedDate TEXT, FOREIGN KEY(CreatedBy) REFERENCES Users(Id))',
    'CREATE TABLE IF NOT EXISTS OrderItems (Id INTEGER PRIMARY KEY AUTOINCREMENT, OrderId INTEGER NOT NULL, ProductId INTEGER NOT NULL, Quantity INTEGER NOT NULL, UnitPrice REAL NOT NULL, TotalPrice REAL, FOREIGN KEY(OrderId) REFERENCES Orders(Id), FOREIGN KEY(ProductId) REFERENCES Products(Id))',
    'CREATE TABLE IF NOT EXISTS ProductionJobs (Id INTEGER PRIMARY KEY AUTOINCREMENT, JobNumber TEXT UNIQUE, OrderId INTEGER, ProductId INTEGER, Quantity INTEGER NOT NULL, QuantityProduced INTEGER NOT NULL DEFAULT 0, Status TEXT NOT NULL DEFAULT ''PLANNING'', StartDate TEXT, EndDate TEXT, EstimatedDate TEXT, Notes TEXT, CreatedDate TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, ModifiedDate TEXT, FOREIGN KEY(OrderId) REFERENCES Orders(Id), FOREIGN KEY(ProductId) REFERENCES Products(Id))',
    'CREATE TABLE IF NOT EXISTS Resources (Id INTEGER PRIMARY KEY AUTOINCREMENT, ResourceName TEXT NOT NULL, ResourceType TEXT NOT NULL, Status TEXT NOT NULL DEFAULT ''AVAILABLE'', CreatedDate TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, ModifiedDate TEXT)',
    'CREATE TABLE IF NOT EXISTS JobResources (Id INTEGER PRIMARY KEY AUTOINCREMENT, JobId INTEGER NOT NULL, ResourceId INTEGER NOT NULL, AllocatedDate TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, ReleaseDate TEXT, FOREIGN KEY(JobId) REFERENCES ProductionJobs(Id), FOREIGN KEY(ResourceId) REFERENCES Resources(Id))',
    'CREATE TABLE IF NOT EXISTS Reports (Id INTEGER PRIMARY KEY AUTOINCREMENT, ReportName TEXT NOT NULL, ReportType TEXT, CreatedBy INTEGER, CreatedDate TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, LastRun TEXT, GeneratedFile TEXT, FOREIGN KEY(CreatedBy) REFERENCES Users(Id))',
    'CREATE INDEX IF NOT EXISTS idx_Users_Username ON Users(Username)',
    'CREATE INDEX IF NOT EXISTS idx_Users_Role ON Users(Role)',
    'CREATE INDEX IF NOT EXISTS idx_ActivityLog_UserId ON ActivityLog(UserId)',
    'CREATE INDEX IF NOT EXISTS idx_ActivityLog_ActivityDate ON ActivityLog(ActivityDate)',
    'CREATE INDEX IF NOT EXISTS idx_Orders_Status ON Orders(Status)',
    'CREATE INDEX IF NOT EXISTS idx_Orders_OrderDate ON Orders(OrderDate)',
    'CREATE INDEX IF NOT EXISTS idx_ProductionJobs_Status ON ProductionJobs(Status)',
    'CREATE INDEX IF NOT EXISTS idx_ProductionJobs_OrderId ON ProductionJobs(OrderId)'
  );
var I: Integer;
begin
  for I := Low(Statements) to High(Statements) do
    FConnection.ExecSQL(Statements[I]);
end;

procedure TDatabaseManager.SeedData;
begin
  FConnection.ExecSQL('INSERT OR IGNORE INTO Roles(RoleName,Description,Permissions) VALUES (''ADMIN'',''Administrator sa svim dozvolama'',''ALL'')');
  FConnection.ExecSQL('INSERT OR IGNORE INTO Roles(RoleName,Description,Permissions) VALUES (''MANAGER'',''Menadžer proizvodnje'',''PRODUCTION,ORDERS,REPORTS'')');
  FConnection.ExecSQL('INSERT OR IGNORE INTO Roles(RoleName,Description,Permissions) VALUES (''OPERATOR'',''Radnik na proizvodnji'',''PRODUCTION,VIEW'')');
  FConnection.ExecSQL('INSERT OR IGNORE INTO Roles(RoleName,Description,Permissions) VALUES (''VIEWER'',''Samo pregled podataka'',''VIEW'')');
  FConnection.ExecSQL('INSERT OR IGNORE INTO Users(Username,Password,Email,Role,IsActive) VALUES (''admin'',''1234'',''admin@example.com'',''ADMIN'',1)');
end;

function TDatabaseManager.Disconnect: Boolean;
begin
  try
    if FConnection.Connected then FConnection.Connected := False;
    FConnected := False;
    Result := True;
  except
    Result := False;
  end;
end;

function TDatabaseManager.IsConnected: Boolean;
begin
  Result := FConnected and FConnection.Connected;
end;

function TDatabaseManager.ExecuteQuery(AQuery: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  try
    Result.Connection := FConnection;
    Result.SQL.Text := AQuery;
    Result.Open;
  except
    Result.Free;
    raise;
  end;
end;

function TDatabaseManager.ExecuteNonQuery(AQuery: string): Boolean;
begin
  try
    FConnection.ExecSQL(AQuery);
    Result := True;
  except
    Result := False;
  end;
end;

end.
