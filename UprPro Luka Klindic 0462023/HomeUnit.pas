
unit HomeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls;

type
  THomeForm = class(TForm)
    btnMain: TButton;
    btnLogout: TButton;
    procedure btnMainClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
  end;

var
  HomeForm: THomeForm;

implementation

uses MainUnit, LoginUnit;

{$R *.dfm}

procedure THomeForm.btnLogoutClick(Sender: TObject);
begin
  LoginForm.Show;
  Hide;
end;

procedure THomeForm.btnMainClick(Sender: TObject);
begin
  MainForm.Show;
  Hide;
end;

end.
