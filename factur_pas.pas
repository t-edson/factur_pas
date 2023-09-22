{Librería para realizar las funciones de autenticación .
                             Creado por Tito Hinostroza: 20/09/2021
}
unit factur_pas;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, opensslsockets, fphttpclient, jsonparser, fpjson;

function GetToken(token_uri, client_id, username, password: String;
                  out tok_response: string): boolean;
function SendFile(send_uri, authToken, jsonFilePath: String;
                  out tik_response: string): boolean;
function GetCDR(CDR_uri, authToken, ticket: string;
                  out response: string): boolean;

implementation

function GetToken(token_uri, client_id, username, password: String;
                  out tok_response: string): boolean;
{Hace la petición POST al URI del proveedor para solicitar un token de seguridad.
Si no hubo error, se devuelve el token en "tok_response". De otra forma se devuelve
el mensaje de error en "tok_response".}
var
  HTTPClient: TFPHTTPClient;
  tmp: TStringList;
  resultado: Boolean = false;
  jData: TJSONData;
begin
    try
      HTTPClient := TFPHTTPClient.Create(nil);
      tmp:= TStringList.Create;
      try
        HTTPClient.AllowRedirect := True;
        HTTPClient.AddHeader('Authorization', 'Basic ' + client_id);
        HTTPClient.Post(token_uri + '?username='+username+'&password='+password+'&grant_type=password', tmp);
        //Obtiene el token de la respuesta
        jData:=GetJSON(tmp.Text);
        tok_response := jData.FindPath('access_token').AsString;
        resultado := True;
        jData.Free;
      except
        on e: Exception do begin
          tok_response := e.Message;
          resultado := False;
        end;
      end;
    finally
      tmp.Destroy;
      HTTPClient.Free;
    end;
    exit(resultado);
end;

function SendFile(send_uri, authToken, jsonFilePath: String;
                  out tik_response: string): boolean;
{Hace el envío del archivo JSON del comprobante al URI del proveedor.
Si no hubo error, se devuelve el ticket en "tik_response". De otra forma se devuelve
el mensaje de error en "tik_response".}
var
  HTTPClient: TFPHTTPClient;
  tmp: TStringStream;
  resultado: Boolean = false;
  jData: TJSONData;
begin
    try
      HTTPClient := TFPHTTPClient.Create(nil);
      tmp:= TStringStream.Create;
      try
        HTTPClient.AllowRedirect := True;
        //Prepara encabezado
        //HTTPClient.AddHeader('Content-Type','multipart/form-data; boundary='+ boundary);
        HTTPClient.AddHeader('Authorization', 'Bearer ' + authToken);
        HTTPClient.FileFormPost(send_uri, 'file', jsonFilePath, tmp);
        tik_response := tmp.DataString;

        jData:=GetJSON(tmp.DataString);
        if jData.FindPath('code').AsString = '0' then begin
          //Todo bien
          tik_response := jData.FindPath('description').AsString;
          resultado := True;
        end else begin
          //Hay código de error
          tik_response := tmp.DataString;
          resultado := false;
        end;
      except
        on e: Exception do begin
          tik_response := e.Message;
          resultado := False;
        end;
      end;
    finally
      tmp.Destroy;
      HTTPClient.Free;
    end;
    exit(resultado);
end;

function GetCDR(CDR_uri, authToken, ticket: string;
                  out response: string): boolean;
var
  HTTPClient: TFPHTTPClient;
  tmp: TStringStream;
  resultado: Boolean = false;
begin
    try
      HTTPClient := TFPHTTPClient.Create(nil);
      tmp:= TStringStream.Create;
      try
        HTTPClient.AllowRedirect := True;
        //Prepara encabezado
        HTTPClient.AddHeader('Authorization', 'Bearer ' + authToken);
        //Prepara datos
        if CDR_uri[Length(CDR_uri)] <> '/' then CDR_uri += '/';
        HTTPClient.Get(CDR_uri + ticket, tmp);
        response := tmp.DataString;
        resultado := True;
      except
        on e: Exception do begin
          response := e.Message;
          resultado := False;
        end;
      end;
    finally
      tmp.Destroy;
      HTTPClient.Free;
    end;
    exit(resultado);
end;

end.

