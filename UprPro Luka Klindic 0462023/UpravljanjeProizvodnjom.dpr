
program UpravljanjeProizvodnjom;

uses
  Vcl.Forms,
  LoginUnit in 'LoginUnit.pas' {LoginForm},
  RegisterUnit in 'RegisterUnit.pas' {RegisterForm},
  ForgotUnit in 'ForgotUnit.pas' {ForgotForm},
  HomeUnit in 'HomeUnit.pas' {HomeForm},
  MainUnit in 'MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TRegisterForm, RegisterForm);
  Application.CreateForm(TForgotForm, ForgotForm);
  Application.CreateForm(THomeForm, HomeForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
