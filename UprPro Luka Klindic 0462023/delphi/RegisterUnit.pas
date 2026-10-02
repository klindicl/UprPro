
unit RegisterUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls;

type
  TRegisterForm = class(TForm)
    btnRegister: TButton;
    btnBack: TButton;
    edtPassword: TEdit;
    edtConfirm: TEdit;
    procedure btnRegisterClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  end;

var
  RegisterForm: TRegisterForm;

implementation

uses LoginUnit;

{$R *.dfm}

procedure TRegisterForm.btnBackClick(Sender: TObject);
begin
  LoginForm.Show;
  Hide;
end;

procedure TRegisterForm.btnRegisterClick(Sender: TObject);
begin
  if edtPassword.Text <> edtConfirm.Text then
    ShowMessage('Lozinke se ne poklapaju!')
  else
  begin
    ShowMessage('Registracija uspesna!');
    LoginForm.Show;
    Hide;
  end;
end;

end.
