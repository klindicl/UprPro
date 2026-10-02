unit HomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  THomeForm = class(TForm)
    lblTitle: TLabel;
    lblWelcome: TLabel;
    lblProcess: TLabel;
    btnMain: TButton;
    btnLogout: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnMainClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
  end;

var
  HomeForm: THomeForm;

implementation

uses MainUnit, LoginUnit, ActivityLoggerUnit;

{$R *.dfm}

procedure THomeForm.FormShow(Sender: TObject);
begin
  lblWelcome.Caption := 'Prijavljeni korisnik: ' + CurrentUsername +
    '    |    Uloga: ' + CurrentUserRole;
end;

procedure THomeForm.btnLogoutClick(Sender: TObject);
begin
  if Assigned(ActivityLogger) then
    ActivityLogger.LogLogout(CurrentUsername);
  LoginForm.Show;
  Hide;
end;

procedure THomeForm.btnMainClick(Sender: TObject);
begin
  MainForm.Show;
  Hide;
end;

end.
