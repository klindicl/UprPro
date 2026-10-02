unit LoginUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Data.DB, FireDAC.Comp.Client, DatabaseUnit, ActivityLoggerUnit;

type
  TLoginForm = class(TForm)
    btnLogin: TButton;
    btnRegister: TButton;
    btnForgot: TButton;
    edtUsername: TEdit;
    edtPassword: TEdit;
    procedure btnLoginClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure btnForgotClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  LoginForm: TLoginForm;
  CurrentUserId: Integer;
  CurrentUsername: string;
  CurrentUserRole: string;

implementation

uses HomeUnit, RegisterUnit, ForgotUnit, AdminUnit;

{$R *.dfm}

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  edtUsername.Text := '';
  edtPassword.Text := '';
  if edtUsername.CanFocus then edtUsername.SetFocus;
end;

procedure TLoginForm.btnLoginClick(Sender: TObject);
var
  Query: TFDQuery;
  Username, Password: string;
begin
  Username := Trim(edtUsername.Text);
  Password := edtPassword.Text;

  if Username = '' then begin
    ShowMessage('Unesite korisničko ime.');
    if edtUsername.CanFocus then edtUsername.SetFocus;
    Exit;
  end;
  if Password = '' then begin
    ShowMessage('Unesite lozinku.');
    if edtPassword.CanFocus then edtPassword.SetFocus;
    Exit;
  end;

  try
    if not DatabaseManager.IsConnected then begin
      ShowMessage('Nema konekcije sa bazom podataka. Proverite SQL Server i podešavanja.');
      Exit;
    end;

    Query := DatabaseManager.ExecuteQuery(Format(
      'SELECT Id, Username, Role, IsActive FROM Users WHERE Username=''%s'' AND Password=''%s''',
      [StringReplace(Username,'''','''''',[rfReplaceAll]),
       StringReplace(Password,'''','''''',[rfReplaceAll])]));
    try
      if Query.Eof then begin
        ShowMessage('Pogrešno korisničko ime ili lozinka.');
        edtPassword.Clear;
        Exit;
      end;

      if (Trim(UpperCase(Query.FieldByName('IsActive').AsString)) = '0') or
           (Trim(UpperCase(Query.FieldByName('IsActive').AsString)) = 'FALSE') then begin
        ShowMessage('Korisnički nalog je deaktiviran.');
        Exit;
      end;

      CurrentUserId := Query.FieldByName('Id').AsInteger;
      CurrentUsername := Query.FieldByName('Username').AsString;
      CurrentUserRole := UpperCase(Query.FieldByName('Role').AsString);

      ActivityLogger := TActivityLogger.Create(CurrentUserId, CurrentUsername);
      ActivityLogger.LogLogin(CurrentUsername);
      DatabaseManager.ExecuteNonQuery(
        Format('UPDATE Users SET LastLogin=CURRENT_TIMESTAMP WHERE Id=%d',[CurrentUserId]));

      if CurrentUserRole = 'ADMIN' then
        AdminForm.Show
      else
        HomeForm.Show;

      Hide;
      edtUsername.Clear;
      edtPassword.Clear;
    finally
      Query.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Greška pri prijavi: ' + E.Message);
  end;
end;

procedure TLoginForm.btnForgotClick(Sender: TObject);
begin
  ForgotForm.Show;
  Hide;
end;

procedure TLoginForm.btnRegisterClick(Sender: TObject);
begin
  RegisterForm.Show;
  Hide;
end;

end.
