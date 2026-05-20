
unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids;

type
  TMainForm = class(TForm)
    StringGrid1: TStringGrid;
    btnBack: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

uses HomeUnit;

{$R *.dfm}

procedure TMainForm.btnBackClick(Sender: TObject);
begin
  HomeForm.Show;
  Hide;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  StringGrid1.Cells[0,0] := 'ID';
  StringGrid1.Cells[1,0] := 'Proizvod';
  StringGrid1.Cells[2,0] := 'Kolicina';
  StringGrid1.Cells[3,0] := 'Status';
end;

end.
