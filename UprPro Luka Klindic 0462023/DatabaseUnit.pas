unit DatabaseUnit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDatabaseManager = class
  private
    FConnection: TADOConnection;
    FConnected: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function Connect(AServer, ADatabase, AUsername, APassword: string): Boolean;
    function Disconnect: Boolean;
    function IsConnected: Boolean;
    function ExecuteQuery(AQuery: string): TADOQuery;
    function ExecuteNonQuery(AQuery: string): Boolean;
    property Connection: TADOConnection read FConnection;
  end;

var
  DatabaseManager: TDatabaseManager;

implementation

constructor TDatabaseManager.Create;
begin
  inherited;
  FConnection := TADOConnection.Create(nil);
  FConnected := False;
end;

destructor TDatabaseManager.Destroy;
begin
  Disconnect;
  FConnection.Free;
  inherited;
end;

function TDatabaseManager.Connect(AServer, ADatabase, AUsername, APassword: string): Boolean;
var
  ConnectionString: string;
begin
  try
    // Format za SQL Server
    ConnectionString := Format(
      'Provider=SQLOLEDB.1;Integrated Security=false;Persist Security Info=True;' +
      'User ID=%s;Password=%s;Initial Catalog=%s;Data Source=%s',
      [AUsername, APassword, ADatabase, AServer]
    );
    
    FConnection.ConnectionString := ConnectionString;
    FConnection.Connected := True;
    FConnected := True;
    Result := True;
  except
    on E: Exception do
    begin
      ShowMessage('Greška pri konekciji: ' + E.Message);
      FConnected := False;
      Result := False;
    end;
  end;
end;

function TDatabaseManager.Disconnect: Boolean;
begin
  try
    if FConnection.Connected then
      FConnection.Connected := False;
    FConnected := False;
    Result := True;
  except
    Result := False;
  end;
end;

function TDatabaseManager.IsConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

function TDatabaseManager.ExecuteQuery(AQuery: string): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  Result.Connection := FConnection;
  Result.SQL.Text := AQuery;
  Result.Open;
end;

function TDatabaseManager.ExecuteNonQuery(AQuery: string): Boolean;
begin
  try
    FConnection.Execute(AQuery);
    Result := True;
  except
    Result := False;
  end;
end;

end.
