program UpravljanjeProizvodnjom;

uses
  Vcl.Forms,
  LoginUnit in 'LoginUnit.pas' {LoginForm},
  RegisterUnit in 'RegisterUnit.pas' {RegisterForm},
  ForgotUnit in 'ForgotUnit.pas' {ForgotForm},
  HomeUnit in 'HomeUnit.pas' {HomeForm},
  MainUnit in 'MainUnit.pas' {MainForm},
  DatabaseUnit in 'DatabaseUnit.pas',
  ActivityLoggerUnit in 'ActivityLoggerUnit.pas',
  AdminUnit in 'AdminUnit.pas' {AdminForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  
  // Inicijalizuj DatabaseManager
  DatabaseManager := TDatabaseManager.Create;
  
  // Pokušaj konekciju sa bazom podataka
  if not DatabaseManager.Connect(
    'localhost\SQLEXPRESS',           // Server
    'UpravljanjeProizvodnjom',         // Baza
    'sa',                              // Korisnik (promenite po potrebi)
    'password'                         // Lozinka (promenite po potrebi)
  ) then
  begin
    ShowMessage('Greška: Nema konekcije sa bazom podataka. Proverite konfiguraciju.');
  end;
  
  // Kreiraj forme
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TRegisterForm, RegisterForm);
  Application.CreateForm(TForgotForm, ForgotForm);
  Application.CreateForm(THomeForm, HomeForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAdminForm, AdminForm);
  
  Application.Run;
  
  // Oslobodi resurse
  if DatabaseManager <> nil then
    DatabaseManager.Free;
end.
