unit LoginUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Data.Win.ADODB,
  DatabaseUnit, ActivityLoggerUnit;

type
  TLoginForm = class(TForm)
    btnLogin: TButton;
    btnRegister: TButton;
    btnForgot: TButton;
    edtUsername: TEdit;
    edtPassword: TEdit;
    lblUsername: TLabel;
    lblPassword: TLabel;
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
  edtUsername.SetFocus;
end;

procedure TLoginForm.btnLoginClick(Sender: TObject);
var
  Query: TADOQuery;
  Username, Password: string;
  UserId: Integer;
  UserRole: string;
begin
  Username := edtUsername.Text;
  Password := edtPassword.Text;

  if Username = '' then
  begin
    ShowMessage('Molim unesite korisničko ime!');
    edtUsername.SetFocus;
    Exit;
  end;

  if Password = '' then
  begin
    ShowMessage('Molim unesite lozinku!');
    edtPassword.SetFocus;
    Exit;
  end;

  try
    if not DatabaseManager.IsConnected then
    begin
      ShowMessage('Nema konekcije sa bazom podataka!');
      Exit;
    end;

    // Pretraži korisnika u bazi
    Query := DatabaseManager.ExecuteQuery(
      Format('SELECT Id, Username, Role, IsActive FROM Users WHERE Username = ''%s'' AND Password = ''%s''',
      [Username, Password])
    );

    try
      if not Query.Eof then
      begin
        // Korisnik pronađen
        UserId := Query.FieldByName('Id').AsInteger;
        UserRole := Query.FieldByName('Role').AsString;
        
        if not Query.FieldByName('IsActive').AsBoolean then
        begin
          ShowMessage('Vaš nalog je deaktiviran! Kontaktirajte administratora.');
          Exit;
        end;

        // Sačuva podatke o korisniku
        CurrentUserId := UserId;
        CurrentUsername := Username;
        CurrentUserRole := UserRole;

        // Logiraj prijavu
        ActivityLogger := TActivityLogger.Create(UserId, Username);
        ActivityLogger.LogLogin(Username);

        // Ažuriraj LastLogin
        DatabaseManager.ExecuteNonQuery(
          Format('UPDATE Users SET LastLogin = GETDATE() WHERE Id = %d', [UserId])
        );

        // Otvori odgovarajuću formu po ulozi
        if UserRole = 'ADMIN' then
        begin
          AdminForm.Show;
        end
        else
        begin
          HomeForm.Show;
        end;

        // Sakrij login formu
        Hide;

        // Očisti polja
        edtUsername.Text := '';
        edtPassword.Text := '';
      end
      else
      begin
        ShowMessage('Pogrešno korisničko ime ili lozinka!');
        edtPassword.Text := '';
        edtUsername.SetFocus;
      end;
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
