{$D SCRNSAVE kclock.kss}
program kclock;

uses
  Forms,
  SysUtils,
  dialogs,
  windows,
  classes,
  graphics,
  uClock in 'uClock.pas' {frmClock},
  fConf in 'fConf.pas' {frmConf},
  fAbout in 'fAbout.pas' {AboutBox},
  jbClock in 'jbClock.pas',
  uMultisampling in 'uMultisampling.pas';

type
  TSSMode = (ssSetPwd, ssPreview, ssConfig, ssRun);

{$E scr}

{$R *.res}

var
  Arg1, Arg2: string;
  SSMode: TSSMode = ssRun;
  OnlyOneInstance: THandle = INVALID_HANDLE_VALUE;

procedure SaverSetPwd(Arg: string);
var
  SysDir: string;
  NewLen: integer;
  PwdLib: THandle;
  PwdFunc: function(a: PChar; ParentHandle: THandle; b, c: Integer): Integer; stdcall;
begin
  SetLength(SysDir, MAX_PATH);
  NewLen := GetSystemDirectory(PChar(SysDir), MAX_PATH);
  SetLength(SysDir, NewLen);
  if (Length(SysDir) > 0) and (SysDir[Length(SysDir)] <> '\') then
    SysDir := SysDir + '\';
  PwdLib := LoadLibrary(PChar(SysDir + 'MPR.DLL'));
  if PwdLib <> 0 then
    begin
      PwdFunc := GetProcAddress(PwdLib, 'PwdChangePasswordA');
      if Assigned(PwdFunc) then
        PwdFunc('SCRSAVE', StrToInt(Arg), 0, 0);
      FreeLibrary(PwdLib);
    end;
  Halt;
end;

function DecodeMode(Arg: string): TSSMode;
begin
  result := ssRun;

  if (Copy(Arg1, 1, 2) = '/A') or (Copy(Arg1, 1, 2) = '-A') or
     (Copy(Arg1, 1, 1) = 'A') then
    result := ssSetPwd;

  if (Copy(Arg1, 1, 2) = '/P') or (Copy(Arg1, 1, 2) = '-P') or
     (Copy(Arg1, 1, 1) = 'P') then
    result := ssPreview;

  if (Copy(Arg1, 1, 2) = '/C') or (Copy(Arg1, 1, 2) = '-C') or
     (Copy(Arg1, 1, 1) = 'C') or (Arg1 = '') then
    result := ssConfig;
end;

procedure CheckOneInstance;
begin
  OnlyOneInstance := CreateSemaphore(nil, 0, 1, 'JBkClockSemaphore');
  if ((OnlyOneInstance <> 0) and (GetLastError = ERROR_ALREADY_EXISTS)) then
    begin
      CloseHandle(OnlyOneInstance);
      Halt;
    end;
end;

procedure CleanupOneInstance;
begin
  if OnlyOneInstance <> INVALID_HANDLE_VALUE then
    CloseHandle(OnlyOneInstance);
end;


procedure SaverPreview(Arg: string);
var
  DemoWnd: hwnd;
  DemoWndRect: TRect;
  ScrWidth, ScrHeight: Integer;
  Clock: TJBClock;
  Mover: TJBMover;
  MyCanvas: TCanvas;

begin
  Application.Initialize;
  DemoWnd := StrToInt(Arg);
  if not IsWindow(DemoWnd) then
    exit;

  while not IsWindowVisible(DemoWnd) do
    Application.ProcessMessages;
  GetWindowRect(DemoWnd, DemoWndRect);
  ScrWidth := DemoWndRect.Right - DemoWndRect.Left + 1;
  ScrHeight := DemoWndRect.Bottom - DemoWndRect.Top + 1;
  DemoWndRect := Rect(0, 0, ScrWidth - 1, ScrHeight - 1);

  Clock := TJBClock.Create(nil);
  Clock.Parent := nil;
  Clock.ParentWindow := DemoWnd;
  Clock.Oclock := time;
  Clock.MultisamplingType := x16;
  Mover := TJBMover.Create(Clock);
  Clock.OnTick := Mover.MoveWithMe;
  Clock.height := ScrHeight;
  Mover.Width := ScrWidth;
  Mover.Height := ScrHeight;
  Mover.InitPlace;
  LoadIniFile(configIniFile, Clock, Mover);

  MyCanvas := TCanvas.Create;
  MyCanvas.Handle := GetDC(DemoWnd);
  MyCanvas.Pen.Color := Clock.Color;
  MyCanvas.Brush.Color := Clock.Color;
  MyCanvas.Rectangle(DemoWndRect);

  while IsWindowVisible(DemoWnd) do
    begin
      Sleep(10);
      MyCanvas.Rectangle(DemoWndRect);  // urcite by to slo lip, ale ted nevim, jak
      Application.ProcessMessages;
    end;
  MyCanvas.Free;
  Clock.Free;
end;

procedure SaverConfig;
begin
  Application.Initialize;
  Application.CreateForm(TfrmConf, frmConf);
  Application.Run;
end;

procedure SaverRun;
begin
  Application.Initialize;
  Application.CreateForm(TfrmClock, frmClock);
  Application.Run;
end;

begin
  try
    Arg1 := UpperCase(ParamStr(1));
    Arg2 := UpperCase(ParamStr(2));

    SSMode := DecodeMode(Arg1);

    CheckOneInstance;

    case SSMode of
      ssSetPwd: SaverSetPwd(Arg2);
      ssPreview: SaverPreview(Arg2);
      ssConfig: SaverConfig;
      ssRun: SaverRun;
    end;

  except
  end;
  CleanupOneInstance;
end.

