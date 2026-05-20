
unit ForgotUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls;

type
  TForgotForm = class(TForm)
    btnReset: TButton;
    btnBack: TButton;
    procedure btnResetClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  end;

var
  ForgotForm: TForgotForm;

implementation

uses LoginUnit;

{$R *.dfm}

procedure TForgotForm.btnBackClick(Sender: TObject);
begin
  LoginForm.Show;
  Hide;
end;

procedure TForgotForm.btnResetClick(Sender: TObject);
begin
  ShowMessage('Lozinka resetovana!');
end;

end.
