
unit LoginUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls;

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
  end;

var
  LoginForm: TLoginForm;

implementation

uses HomeUnit, RegisterUnit, ForgotUnit;

{$R *.dfm}

procedure TLoginForm.btnForgotClick(Sender: TObject);
begin
  ForgotForm.Show;
  Hide;
end;

procedure TLoginForm.btnLoginClick(Sender: TObject);
begin
  if (edtUsername.Text = 'admin') and (edtPassword.Text = '1234') then
  begin
    HomeForm.Show;
    Hide;
  end
  else
    ShowMessage('Pogresni podaci!');
end;

procedure TLoginForm.btnRegisterClick(Sender: TObject);
begin
  RegisterForm.Show;
  Hide;
end;

end.
