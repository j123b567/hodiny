unit uClock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jbClock;

type

  TJBClockScreen = class
    fMover: TJBMover;
    fClock: TJBClock;
    fOwner: TWinControl;
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
    procedure Activate(AMonitor: TMonitor);
  end;

  TfrmClock = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure DeactivateScrnSaver(var Msg: TMsg; var Handled: boolean);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fClockScreens: Array of TJBClockScreen;
    fCursorPosition: TPoint;
  public
    { Public declarations }
  end;

var
  frmClock: TfrmClock;

implementation

{$R *.dfm}
uses fConf;

{ TJBClockScreen }
constructor TJBClockScreen.Create(AOwner: TWinControl);
begin
  fOwner := AOwner;

  fClock := TJBClock.Create(AOwner);
  fClock.Parent := AOwner;
  fClock.Left := 136;
  fClock.Top := 56;
  fClock.Antialiasing := True;
  fClock.Go := True;

  fMover := TJBMover.Create(fClock);
  fMover.Size := 4;
  fMover.Move := true;
  fMover.RandomMove := false;

  fClock.OnTick := fMover.MoveWithMe;
  fClock.Oclock := time;

  LoadIniFile('jbClock.ini', fClock, fMover);
end;

destructor TJBClockScreen.Destroy;
begin
  fMover.Free;
  fClock.Free;
end;

procedure TJBClockScreen.Activate(AMonitor: TMonitor);
var
  currentLeftTop: TPoint;

begin
  fMover.Width := AMonitor.Width;
  fMover.Height := AMonitor.Height;
  currentLeftTop := fOwner.ScreenToClient(Point(AMonitor.Left, AMonitor.Top));
  fMover.Left := currentLeftTop.X;
  fMover.Top := currentLeftTop.Y;
  fMover.InitPlace;
end;

{ TfrmClock }
procedure TfrmClock.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Randomize;
  SetLength(fClockScreens, Screen.MonitorCount);
  for i:= 0 to Screen.MonitorCount - 1 do
    begin
      fClockScreens[i] := TJBClockScreen.Create(self);
    end;
end;

procedure TfrmClock.DeactivateScrnSaver(var Msg: TMsg; var Handled: boolean);
var
  done: boolean;
  crsnew: TPoint;
begin
  if Msg.message = WM_MOUSEMOVE then
    begin
      GetCursorPos(crsnew);
      done := (Abs(crsnew.x - fCursorPosition.x) > 5) or
        (Abs(crsnew.y - fCursorPosition.y) > 5)
//      done := (Abs(LOWORD(Msg.lParam) - fCursorPosition.x) > 5) or
//        (Abs(HIWORD(Msg.lParam) - fCursorPosition.y) > 5)
    end
  else
    done := (Msg.message = WM_KEYDOWN) or (Msg.message = WM_ACTIVATE) or
      (Msg.message = WM_ACTIVATEAPP) or (Msg.message = WM_NCACTIVATE);
  if done then
    Close;
end; {TScrnFrm.DeactivateScrnSaver}

procedure TfrmClock.FormShow(Sender: TObject);
begin
  color := fClockScreens[0].fClock.Color;

  GetCursorPos(fCursorPosition);
  Application.OnMessage := DeactivateScrnSaver;
  ShowCursor(false);
end;

procedure TfrmClock.FormHide(Sender: TObject);
begin
  Application.OnMessage := nil;
  ShowCursor(true);
end;

procedure TfrmClock.FormActivate(Sender: TObject);
var
  viewOn: integer;
begin
  with Screen do
    begin
      Self.Top := DesktopTop;
      Self.Left := DesktopLeft;
      Self.Width := DesktopWidth;
      Self.Height := DesktopHeight;
      for viewOn := 0 to Screen.MonitorCount - 1 do
        begin
          fClockScreens[viewOn].Activate(Monitors[viewOn]);
        end;
    end;
end;

procedure TfrmClock.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i:= 0 to Screen.MonitorCount - 1 do
    begin
      fClockScreens[i].Free;
    end;
  SetLength(fClockScreens, 0);
end;

end.

