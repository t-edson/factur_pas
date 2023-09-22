unit Unit1;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  factur_pas;
type
  { TForm1 }
  TForm1 = class(TForm)
    butPedirTok: TButton;
    butEnvArc: TButton;
    butSolCDR: TButton;
    Memo1: TMemo;
    procedure butEnvArcClick(Sender: TObject);
    procedure butPedirTokClick(Sender: TObject);
    procedure butSolCDRClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public

  end;

var
  Form1: TForm1;

var
  TOKEN_URI: string = 'https://url_proveedor/token';
  ID_CLIENT: string = 'ID_CLIENTE==';
  NOM_USU  : string = 'NOMBRE_USUARIO';
  PAS_USU  : string = '1234567890';
  ENVIO_URI: string = 'https://url_proveedor/document/';
  ARCH_JSON: string = 'D:\20999999991-01-F001-190.json';
  CDR_URI  : string = 'https://url_proveedor/cdr/';

var
  token: string;
  ticket: string;

implementation
{$R *.lfm}

{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
begin
//  {$Include 'credenciales.txt'}
end;

procedure TForm1.butPedirTokClick(Sender: TObject);
begin
  Memo1.Lines.Add('>>Solicitando Token ...');
  if GetToken(TOKEN_URI, ID_CLIENT, NOM_USU, PAS_USU, token) then begin
    Memo1.Lines.Add('  ' + copy(token,2, 25) + '...');
    Memo1.Lines.Add('  Token recibido.');
  end else begin  //Error
    Memo1.Lines.Add('!!!Error: ' + token);
  end;
end;

procedure TForm1.butEnvArcClick(Sender: TObject);
begin
  Memo1.Lines.Add('>>Enviando JSON ...');
  if SendFile(ENVIO_URI, token, ARCH_JSON, ticket) then begin
    Memo1.Lines.Add('  ' + copy(ticket, 1, 15) + '...');
    Memo1.Lines.Add('  Ticket recibido.');
  end else begin  //Error
    Memo1.Lines.Add('!!!Error: ' + ticket);
  end;
end;

procedure TForm1.butSolCDRClick(Sender: TObject);
var
  response: string;
begin
  Memo1.Lines.Add('>>Pidiendo CDR ...');
  if GetCDR(CDR_URI, token, ticket, response) then begin
//    Memo1.Lines.Add('  ' + copy(response, 1, 15) + '...');
    Memo1.Lines.Add('  ' + response);
    Memo1.Lines.Add('  CDR recibido.');
  end else begin  //Error
    Memo1.Lines.Add('!!!Error: ' + response);
  end;
end;

end.

