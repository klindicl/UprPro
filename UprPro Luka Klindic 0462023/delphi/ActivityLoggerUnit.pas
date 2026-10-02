unit ActivityLoggerUnit;

interface

uses
  System.SysUtils, System.Classes, DatabaseUnit;

type
  TActivityType = (atLogin, atLogout, atCreate, atUpdate, atDelete, atView, atExport, atOther);

  TActivityLogger = class
  private
    FUserId: Integer;
    FUsername: string;
  public
    constructor Create(AUserId: Integer; AUsername: string);
    procedure LogActivity(AActivityType: TActivityType; ADescription: string; ATableName: string = '');
    procedure LogLogin(AUsername: string);
    procedure LogLogout(AUsername: string);
    procedure LogDataChange(AAction: string; ATableName: string; ARecordId: Integer; ADescription: string);
  end;

var
  ActivityLogger: TActivityLogger;

implementation

constructor TActivityLogger.Create(AUserId: Integer; AUsername: string);
begin
  inherited Create;
  FUserId := AUserId;
  FUsername := AUsername;
end;

procedure TActivityLogger.LogActivity(AActivityType: TActivityType; ADescription: string; ATableName: string = '');
var
  Query: string;
  ActivityTypeStr: string;
  Timestamp: string;
begin
  if not DatabaseManager.IsConnected then
    Exit;

  Timestamp := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now);
  
  case AActivityType of
    atLogin: ActivityTypeStr := 'LOGIN';
    atLogout: ActivityTypeStr := 'LOGOUT';
    atCreate: ActivityTypeStr := 'CREATE';
    atUpdate: ActivityTypeStr := 'UPDATE';
    atDelete: ActivityTypeStr := 'DELETE';
    atView: ActivityTypeStr := 'VIEW';
    atExport: ActivityTypeStr := 'EXPORT';
    atOther: ActivityTypeStr := 'OTHER';
  end;

  Query := Format(
    'INSERT INTO ActivityLog (UserId, Username, ActivityType, Description, TableName, ActivityDate) ' +
    'VALUES (%d, ''%s'', ''%s'', ''%s'', ''%s'', ''%s'')',
    [FUserId, FUsername, ActivityTypeStr, ADescription, ATableName, Timestamp]
  );

  DatabaseManager.ExecuteNonQuery(Query);
end;

procedure TActivityLogger.LogLogin(AUsername: string);
var
  Query: string;
  Timestamp: string;
begin
  if not DatabaseManager.IsConnected then
    Exit;

  Timestamp := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now);
  
  Query := Format(
    'INSERT INTO ActivityLog (Username, ActivityType, Description, ActivityDate) ' +
    'VALUES (''%s'', ''LOGIN'', ''Korisnik se prijavio'', ''%s'')',
    [AUsername, Timestamp]
  );

  DatabaseManager.ExecuteNonQuery(Query);
end;

procedure TActivityLogger.LogLogout(AUsername: string);
var
  Query: string;
  Timestamp: string;
begin
  if not DatabaseManager.IsConnected then
    Exit;

  Timestamp := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now);
  
  Query := Format(
    'INSERT INTO ActivityLog (Username, ActivityType, Description, ActivityDate) ' +
    'VALUES (''%s'', ''LOGOUT'', ''Korisnik se odjavio'', ''%s'')',
    [AUsername, Timestamp]
  );

  DatabaseManager.ExecuteNonQuery(Query);
end;

procedure TActivityLogger.LogDataChange(AAction: string; ATableName: string; ARecordId: Integer; ADescription: string);
var
  Query: string;
  Timestamp: string;
begin
  if not DatabaseManager.IsConnected then
    Exit;

  Timestamp := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now);
  
  Query := Format(
    'INSERT INTO ActivityLog (UserId, Username, ActivityType, Description, TableName, RecordId, ActivityDate) ' +
    'VALUES (%d, ''%s'', ''%s'', ''%s'', ''%s'', %d, ''%s'')',
    [FUserId, FUsername, AAction, ADescription, ATableName, ARecordId, Timestamp]
  );

  DatabaseManager.ExecuteNonQuery(Query);
end;

end.
