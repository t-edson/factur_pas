# factur_pas

Librería en Pascal para implementar facturación electrónica.

Esta librería está desarrollada sobre Free Pascal y Lazarus.

Por el momento, la  librería solo incluye las funciones de autenticación ante un proveedor OSE. Estas funciones son:

* Solicitud de un token.
* Envío de un archivo JSON del comprobante.
* Solicitud del CDR del archivo.

![Autenticación](https://github.com/t-edson/factur_pas/blob/main/screen1.png "Autenticación")

Para ver el modo de uso, abrir el proyecto "/demo_autenticar". Se debe reemplazar primero las credenciales de acceso y comentar la la línea:

```
{$Include 'credenciales.txt'}
```
