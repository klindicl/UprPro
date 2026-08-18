unit AdminUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls,
  DatabaseUnit, ActivityLoggerUnit, Data.DB, Data.Win.ADODB;

type
  TAdminForm = class(TForm)
    PageControl1: TPageControl;
    tsUsers: TTabSheet;
    tsRoles: TTabSheet;
    tsActivityLog: TTabSheet;
    tsSettings: TTabSheet;
    
    // Users Tab
    sgUsers: TStringGrid;
    btnAddUser: TButton;
    btnEditUser: TButton;
    btnDeleteUser: TButton;
    btnRefreshUsers: TButton;
    
    // Roles Tab
    sgRoles: TStringGrid;
    btnAddRole: TButton;
    btnEditRole: TButton;
    btnDeleteRole: TButton;
    
    // Activity Log Tab
    sgActivityLog: TStringGrid;
    btnRefreshLog: TButton;
    dtpFrom: TDateTimePicker;
    dtpTo: TDateTimePicker;
    
    // Settings Tab
    lblVersion: TLabel;
    btnBackup: TButton;
    btnLogout: TButton;
    
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshUsersClick(Sender: TObject);
    procedure btnAddUserClick(Sender: TObject);
    procedure btnEditUserClick(Sender: TObject);
    procedure btnDeleteUserClick(Sender: TObject);
    procedure btnRefreshLogClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  AdminForm: TAdminForm;

implementation

uses LoginUnit, HomeUnit;

{$R *.dfm}

procedure TAdminForm.FormCreate(Sender: TObject);
begin
  // Inicijalizacija Users grida
  sgUsers.ColCount := 5;
  sgUsers.RowCount := 2;
  sgUsers.Cells[0,0] := 'ID';
  sgUsers.Cells[1,0] := 'Korisničko ime';
  sgUsers.Cells[2,0] := 'Email';
  sgUsers.Cells[3,0] := 'Uloga';
  sgUsers.Cells[4,0] := 'Aktivna';
  
  // Inicijalizacija Roles grida
  sgRoles.ColCount := 3;
  sgRoles.RowCount := 2;
  sgRoles.Cells[0,0] := 'ID';
  sgRoles.Cells[1,0] := 'Naziv uloge';
  sgRoles.Cells[2,0] := 'Dozvole';
  
  // Inicijalizacija Activity Log grida
  sgActivityLog.ColCount := 6;
  sgActivityLog.RowCount := 2;
  sgActivityLog.Cells[0,0] := 'ID';
  sgActivityLog.Cells[1,0] := 'Korisnik';
  sgActivityLog.Cells[2,0] := 'Aktivnost';
  sgActivityLog.Cells[3,0] := 'Opis';
  sgActivityLog.Cells[4,0] := 'Tabela';
  sgActivityLog.Cells[5,0] := 'Vreme';
  
  // Učitaj podatke
  btnRefreshUsersClick(nil);
  btnRefreshLogClick(nil);
  
  lblVersion.Caption := 'Verzija: 1.0.0';
  dtpFrom.DateTime := Now - 30;
  dtpTo.DateTime := Now;
end;

procedure TAdminForm.btnRefreshUsersClick(Sender: TObject);
var
  Query: TADOQuery;
  Row: Integer;
begin
  try
    if not DatabaseManager.IsConnected then
    begin
      ShowMessage('Nema konekcije sa bazom!');
      Exit;
    end;
    
    Query := DatabaseManager.ExecuteQuery('SELECT Id, Username, Email, Role, IsActive FROM Users ORDER BY Id');
    try
      Row := 1;
      while not Query.Eof do
      begin
        if Row >= sgUsers.RowCount then
          sgUsers.RowCount := sgUsers.RowCount + 1;
        
        sgUsers.Cells[0, Row] := Query.FieldByName('Id').AsString;
        sgUsers.Cells[1, Row] := Query.FieldByName('Username').AsString;
        sgUsers.Cells[2, Row] := Query.FieldByName('Email').AsString;
        sgUsers.Cells[3, Row] := Query.FieldByName('Role').AsString;
        sgUsers.Cells[4, Row] := Query.FieldByName('IsActive').AsString;
        
        Query.Next;
        Inc(Row);
      end;
    finally
      Query.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Greška pri učitavanju korisnika: ' + E.Message);
  end;
end;

procedure TAdminForm.btnAddUserClick(Sender: TObject);
var
  Username, Password, Email, Role: string;
  Query: string;
begin
  Username := InputBox('Dodaj korisnika', 'Unesite korisničko ime:', '');
  if Username = '' then Exit;
  
  Password := InputBox('Dodaj korisnika', 'Unesite lozinku:', '');
  if Password = '' then Exit;
  
  Email := InputBox('Dodaj korisnika', 'Unesite email:', '');
  Role := InputBox('Dodaj korisnika', 'Unesite ulogu (ADMIN, USER, VIEWER):', 'USER');
  
  Query := Format(
    'INSERT INTO Users (Username, Password, Email, Role, IsActive, CreatedDate) ' +
    'VALUES (''%s'', ''%s'', ''%s'', ''%s'', 1, GETDATE())',
    [Username, Password, Email, Role]
  );
  
  if DatabaseManager.ExecuteNonQuery(Query) then
  begin
    ShowMessage('Korisnik uspešno dodan!');
    btnRefreshUsersClick(nil);
  end
  else
    ShowMessage('Greška pri dodavanju korisnika!');
end;

procedure TAdminForm.btnEditUserClick(Sender: TObject);
begin
  ShowMessage('Funkcija za ažuriranje korisnika će biti implementirana');
end;

procedure TAdminForm.btnDeleteUserClick(Sender: TObject);
var
  UserId: string;
  Query: string;
begin
  if sgUsers.Row <= 0 then
  begin
    ShowMessage('Izaberite korisnika!');
    Exit;
  end;
  
  UserId := sgUsers.Cells[0, sgUsers.Row];
  
  if MessageDlg('Obrisati korisnika?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Query := Format('DELETE FROM Users WHERE Id = %s', [UserId]);
    if DatabaseManager.ExecuteNonQuery(Query) then
    begin
      ShowMessage('Korisnik obrisan!');
      btnRefreshUsersClick(nil);
    end;
  end;
end;

procedure TAdminForm.btnRefreshLogClick(Sender: TObject);
var
  Query: TADOQuery;
  Row: Integer;
  DateFrom, DateTo: string;
begin
  try
    if not DatabaseManager.IsConnected then
    begin
      ShowMessage('Nema konekcije sa bazom!');
      Exit;
    end;
    
    DateFrom := FormatDateTime('yyyy-mm-dd', dtpFrom.DateTime);
    DateTo := FormatDateTime('yyyy-mm-dd', dtpTo.DateTime);
    
    Query := DatabaseManager.ExecuteQuery(
      Format('SELECT Id, Username, ActivityType, Description, TableName, ActivityDate ' +
             'FROM ActivityLog WHERE ActivityDate BETWEEN ''%s'' AND ''%s'' ' +
             'ORDER BY ActivityDate DESC', [DateFrom, DateTo])
    );
    
    try
      Row := 1;
      while not Query.Eof do
      begin
        if Row >= sgActivityLog.RowCount then
          sgActivityLog.RowCount := sgActivityLog.RowCount + 1;
        
        sgActivityLog.Cells[0, Row] := Query.FieldByName('Id').AsString;
        sgActivityLog.Cells[1, Row] := Query.FieldByName('Username').AsString;
        sgActivityLog.Cells[2, Row] := Query.FieldByName('ActivityType').AsString;
        sgActivityLog.Cells[3, Row] := Query.FieldByName('Description').AsString;
        sgActivityLog.Cells[4, Row] := Query.FieldByName('TableName').AsString;
        sgActivityLog.Cells[5, Row] := Query.FieldByName('ActivityDate').AsString;
        
        Query.Next;
        Inc(Row);
      end;
    finally
      Query.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Greška pri učitavanju loga: ' + E.Message);
  end;
end;

procedure TAdminForm.btnBackupClick(Sender: TObject);
begin
  ShowMessage('Backup baze podataka će biti sačuvan...');
  // Implementacija backup logike
end;

procedure TAdminForm.btnLogoutClick(Sender: TObject);
begin
  LoginForm.Show;
  Hide;
end;

procedure TAdminForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

end.
