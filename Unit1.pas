unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Tlhelp32, PsAPI, ShellApi, Vcl.StdCtrls;

type
  TfrmPrincipal = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function KillTask(ExeFileName: string): Integer;
    function VerficarSeAplicaticoEstarRodando(Nome:String):Boolean;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  cProcesso : String ;

implementation

{$R *.dfm}

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin

   cProcesso := InputBox('Matar processo','Nome','');
   if trim(cProcesso) = '' then Exit;
   If KillTask(Trim(cProcesso)) > 0 Then
      Begin
         Sleep(500);
         ShowMessage('Programa Desativado');
      End
   Else
      ShowMessage('Programa Não Estava Aberto');
end;

function TfrmPrincipal.KillTask(ExeFileName: string): Integer;
Const
   PROCESS_TERMINATE = $0001;

var
  FProcessEntry32: TProcessEntry32;
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;

begin

   Result := 0;

   FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
   FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
   ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

   While Integer(ContinueLoop) <> 0 Do
     Begin

        If ( (UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) Or
             (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName)) ) Then

           Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
                                              FProcessEntry32.th32ProcessID), 0));

       ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);

     End;

   CloseHandle(FSnapshotHandle);

end;

function TfrmPrincipal.VerficarSeAplicaticoEstarRodando(Nome: String): Boolean;
const
   PROCESS_TERMINATE = $0001;

var
   ContinueLoop: BOOL;
   FSnapshotHandle: THandle;
   FProcessEntry32: TProcessEntry32;

Begin

   Result := False;

   FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
   FProcessEntry32.dwSize := sizeof(FProcessEntry32);
   ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

   While Integer(ContinueLoop) <> 0 Do
      Begin

         If ( FProcessEntry32.szExeFile = Nome ) Then
            Result := True;

         ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);

      End;

   CloseHandle(FSnapshotHandle);

end;

end.
