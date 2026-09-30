program UpravljanjeProizvodnjom;

uses
  Vcl.Forms,
  Vcl.Dialogs,
  FireDAC.VCLUI.Wait,
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

  DatabaseManager := TDatabaseManager.Create;
  try
    if not DatabaseManager.Connect('', '', '', '') then
    begin
      ShowMessage('Lokalna baza nije mogla da se inicijalizuje.' + sLineBreak +
        'Proverite da li Delphi instalacija sadrži FireDAC SQLite podršku.');
      Exit;
    end;

    Application.CreateForm(TLoginForm, LoginForm);
    Application.CreateForm(TRegisterForm, RegisterForm);
    Application.CreateForm(TForgotForm, ForgotForm);
    Application.CreateForm(THomeForm, HomeForm);
    Application.CreateForm(TMainForm, MainForm);
    Application.CreateForm(TAdminForm, AdminForm);

    Application.Run;
  finally
    DatabaseManager.Free;
    DatabaseManager := nil;
  end;
end.
