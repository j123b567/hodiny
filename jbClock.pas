unit jbClock;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls, Graphics, Messages, Math,
  ezLines;

type
  TJBLine = class(TPen)
  private
    fLength: integer;
    procedure SetLength(Value: Integer);

  public
    property Mode;
    constructor Create;
    destructor Destroy; override;
  published
    property Length: Integer read fLength write SetLength;
  end;

  TJBMover = class(TObject)
  private
    fSize: integer;
    fMove: boolean;
    fOffx, fOffy: integer;
    fDirx, fDiry: integer;
    fWidth, fHeight: integer;
    fRandomMove: boolean;
    fCtrl: TControl;
    fTop, fLeft: integer;

    function RandomVal(range: integer): integer;
    procedure SetSize(value: integer);
    procedure SetWidth(value: integer);
    procedure SetHeight(value: integer);
    procedure Resize();
  public
    constructor Create(Ctrl: TControl);
    destructor Destroy; override;
    procedure MoveWithMe(Sender: TObject);
    procedure InitPlace;
  published
    property Move: boolean read fMove write fMove;
    property RandomMove: boolean read fRandomMove write fRandomMove;
    property Size: Integer read fSize write SetSize;
    property Width: integer read fWidth write SetWidth;
    property Height: integer read fHeight write SetHeight;
    property Top: integer read fTop write fTop;
    property Left: integer read fLeft write fLeft;
  end;

  TJBClock = class(TCustomControl)
  private
    { Private declarations }
    fTimer: TTimer;
    procedure SetGo(Active: Boolean);
    function GetGo: Boolean;
    procedure SetOclock(Active: TTime);

    procedure SetHour(Active: TJBLine);
    procedure SetMinute(Active: TJBLine);
    procedure SetSecond(Active: TJBLine);

    procedure SetHoPo(Active: TJBLine);

    procedure SetMiPo(Active: TJBLine);

    procedure SetColor(Active: TColor);
    procedure TimeTick(Sender: TObject);
  protected
    { Protected declarations }
    fTime: TTime;
    fHour: TJBLine;
    fMinute: TJBLine;
    fSecond: TJBLine;
    fHoPo: TJBLine;
    fMiPo: TJBLine;

    fColor: TColor;
    fFace: TBitmap;
    fHands: TBitmap;
    fDrawing: TBitmap;

    fEZLine: TEZLine;

    fAntialiasing: boolean;

    FOnTick: TNotifyEvent;
    procedure Paint; override;
    procedure PaintBackground;
    procedure PaintTime;
    procedure LineChanged(Sender: TObject);
    procedure SetAntialiasing(value: boolean);
    procedure DoTick;
    procedure DrawAALine(ATarget: TBitmap; AWidth: double; x1, y1, x2, y2 :integer);
    procedure DrawAAElipse(ATarget: TBitmap; x1, y1, x2, y2 :integer);

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Invalidate; override;
  published
    { Published declarations }
    property Go: Boolean read GetGo write SetGo;
    property Oclock: TTime read fTime write SetOclock;
    property Hour: TJBLine read fHour write SetHour;
    property Minute: TJBLine read fMinute write SetMinute;
    property Second: TJBLine read fSecond write SetSecond;
    property HoPo: TJBLine read fHoPO write SetHoPo;
    property MiPo: TJBLine read fMiPO write SetMiPo;
    property Color: TColor read fColor write SetColor;

    property OnTick: TNotifyEvent read fOnTick write fOnTick;

    property Antialiasing:boolean read fAntialiasing write setAntialiasing;

    property Hint;
    property ParentShowHint;
    property ShowHint;
    property Visible;
    property PopupMenu;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property TabStop;
    property TabOrder;
  end;

implementation

constructor TJBMover.Create(ctrl: TControl);
begin
  inherited create;
  fDirx := 1;
  fDiry := 1;
  fOffx := 2;
  fOffy := 2;
  fCtrl := ctrl;
  Randomize;
end;

destructor TJBMover.Destroy;
begin
  inherited destroy;
end;

procedure TJBMover.SetSize(value: integer);
begin
  if value <> fSize then
    begin
      fSize := value;
      Resize;
    end;
end;

procedure TJBMover.SetWidth(value: integer);
begin
  if value <> fWidth then
    begin
      fWidth := value;
      Resize;
    end;
end;

procedure TJBMover.SetHeight(value: integer);
begin
  if value <> fHeight then
    begin
      fHeight := value;
      Resize;
    end;
end;

procedure TJBMover.Resize();
begin
  if nil = fCtrl then exit;
  fCtrl.Height := Min(fWidth, fHeight) * (fSize + 5) div 15;
  fCtrl.Width := fCtrl.Height;
end;

function TJBMover.RandomVal(range: integer): integer;
begin
  if fRandomMove then
    begin
      result := random(range);
    end
  else
    begin
      if 1 = range then
        result := 1
      else
        result := range div 2;
    end;
end;

procedure TJBMover.InitPlace;
var
  oldRandomMove: boolean;
begin
  if nil = fCtrl then exit;
  Resize();

  oldRandomMove := fRandomMove;
  if not fMove then
    fRandomMove := false;

  fCtrl.Left := RandomVal(fWidth - fCtrl.Width) + fLeft;
  fCtrl.Top := RandomVal(fHeight - fCtrl.Height) + fTop;

  fRandomMove := oldRandomMove;
end;

procedure TJBMover.MoveWithMe(Sender: TObject);
begin
  if nil = fCtrl then exit;
  if fMove then
    begin
      fCtrl.Left := fCtrl.Left + RandomVal(fOffx) * fDirx;
      fCtrl.Top := fCtrl.Top + RandomVal(fOffy) * fDiry;
      if (fCtrl.Top - fTop + fCtrl.Height > fHeight) then
        begin
          fDirY := -1;
          fCtrl.Top := fHeight - fCtrl.Height + fTop;
        end;
      if (fCtrl.Top - fTop < 0) then
        begin
          fDirY := 1;
          fCtrl.Top := fTop;
        end;
      if (fCtrl.Left - fLeft + fCtrl.Width > fWidth) then
        begin
          fDirX := -1;
          fCtrl.Left := fWidth - fCtrl.Width + fLeft;
        end;
      if (fCtrl.Left - fLeft < 0) then
        begin
          fDirX := 1;
          fCtrl.Left := fLeft;
        end;
    end
  else
    begin
      InitPlace;

    end;
end;

constructor TJBLine.Create;
begin
  inherited create;
end;

destructor TJBLine.Destroy;
begin
  inherited destroy;
end;

procedure TJBLine.SetLength(Value: integer);
begin
  fLength := value;
  Changed;
end;

constructor TJBClock.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  fFace := TBitmap.Create;
  fFace.PixelFormat := pf24bit;

  fDrawing := TBitmap.Create;
  fDrawing.PixelFormat := pf24bit;

  fHands := TBitmap.Create;
  fHands.PixelFormat := pf24bit;

  fEZLine := TEZLine.Create;
  fEZLine.AntiAlias := true;
  fEZLine.PenStyle := psSolid;
  fEZLine.PenMode := pmCopy;
  fEZLine.PenTransparency := 1.0;
  fEZLine.StartDistance := 0;
  fEZLine.UseCutoff := true;


  fHour := TJBLine.Create;
  fMinute := TJBLine.Create;
  fSecond := TJBLine.Create;
  fHoPo := TJBLine.Create;
  fMiPo := TJBLine.Create;

  fHoPo.OnChange := LineChanged;
  fMiPo.OnChange := LineChanged;

  fColor := ClBlack;

  fHoPo.Color := clWhite;
  fMiPo.Color := clWhite;

  fHoPo.Width := 20;
  fHoPo.Length := 60;

  fMiPo.Width := 5;
  fMiPo.Length := 30;

  fSecond.Color := ClRed;
  fSecond.Width := 10;
  fSecond.Length := 90;

  fHour.Color := ClWhite;
  fHour.Width := 25;
  fHour.Length := 60;

  fMinute.Color := ClWhite;
  fMinute.Width := 16;
  fMinute.Length := 90;

  Height := 400;
  Width := 400;

  fTimer := TTimer.Create(self);
  fTimer.Interval := 100;
  fTimer.OnTimer := TimeTick;
  fTimer.Enabled := True;
  PaintBackground;
end;

destructor TJBClock.Destroy;
begin
  fTimer.Free;
  fFace.Free;
  fHands.Free;
  fDrawing.Free;
  fEZLine.Free;
  fHour.Free;
  fMinute.Free;
  fSecond.Free;
  fHoPo.Free;
  fMiPo.Free;
  inherited Destroy;
end;

procedure TJBClock.LineChanged(Sender: TObject);
begin
  PaintBackground;
end;

procedure TJBClock.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if AWidth <> Width then
    AHeight := AWidth
  else if AHeight <> Height then
    AWidth := AHeight;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  PaintBackground;
end;

procedure TJBClock.SetGo(Active: Boolean);
begin
  fTimer.Enabled := Active;
end;

function TJBClock.GetGo: Boolean;
begin
  Result := fTimer.Enabled;
end;

procedure TJBClock.Invalidate;
begin
  PaintBackground;
  Paint;
  DoTick;
end;

procedure TJBClock.SetOclock(Active: TTime);
begin
  fTime := Active;
  Invalidate;
end;

procedure TJBClock.SetHour(Active: TJBLine);
begin
  fHour := Active;
  Invalidate;
end;

procedure TJBClock.SetMinute(Active: TJBLine);
begin
  fMinute := Active;
  Invalidate;
end;

procedure TJBClock.SetSecond(Active: TJBLine);
begin
  fSecond := Active;
  Invalidate;
end;

procedure TJBClock.SetHoPo(Active: TJBLine);
begin
  fHoPo := Active;
  Invalidate;
end;

procedure TJBClock.SetMiPo(Active: TJBLine);
begin
  fMiPo := Active;
  Invalidate;
end;

procedure TJBClock.SetColor(Active: TColor);
begin
  fColor := Active;
  Invalidate;
end;

procedure TJBClock.SetAntialiasing(value: boolean);
begin
  if value <> fAntialiasing then
    begin
      fAntialiasing := value;
      fEZLine.AntiAlias := value;
      Invalidate;
    end;
end;

procedure TJBClock.DrawAALine(ATarget: TBitmap; AWidth: double; x1, y1, x2, y2 :integer);
begin
  fEZLine.LineColor := ATarget.Canvas.Pen.Color;
  fEZLine.LineWidth := AWidth;

  fEZLine.Line(x1, y1, x2, y2, ATarget);
end;

procedure TJBClock.DrawAAElipse(ATarget: TBitmap; x1, y1, x2, y2 :integer);
var
  a1, b1, a2, b2: integer;
begin
  fEZLine.LineColor := ATarget.Canvas.Pen.Color;
  fEZLine.LineWidth := ATarget.Canvas.Pen.Width;

  a1 := (x1 + x2) div 2;
  b1 := (y1 + y2) div 2;
  a2 := x2;
  b2 := y2;

  fEZLine.Ellips(a1, b1, a2, b2, ATarget);
end;

procedure TJBClock.PaintBackground;
var
  radius: integer;
  xrel, yrel: real;
  x1, y1: integer;
  x2, y2: integer;
  lineWidth: real;

  procedure drawTicks(aPen: TJBLine; module: integer);
  var
    width: integer;
    i: integer;
  begin
    fDrawing.Canvas.Pen.Assign(aPen);
    width := fDrawing.Canvas.Pen.Width;
    fDrawing.Canvas.Pen.Width := width * fDrawing.Width div 1000;
    for i := 0 to module - 1 do
      begin
        xrel := Cos(i / module * Pi * 2);
        yrel := Sin(i / module * Pi * 2);

        x1 := round(xrel * (radius - aPen.Length * fDrawing.Width div 1000) + radius);
        y1 := round(yrel * (radius - aPen.Length * fDrawing.Width div 1000) + radius);

        x2 := round((xrel + 1) * radius);
        y2 := round((yrel + 1) * radius);

        DrawAALine(fDrawing, width * fDrawing.Width / 1000, x1, y1, x2, y2);

      end;
    fDrawing.Canvas.Pen.Width := width;
  end;

begin
  fFace.Height := Max(Height, Width);
  fFace.Width := Max(Height, Width);

  fDrawing.Height := fFace.Height;
  fDrawing.Width := fFace.Width;

  fDrawing.Canvas.Brush.Color := fColor;
  fDrawing.Canvas.Pen.Color := fColor;
  fDrawing.Canvas.Rectangle(0, 0, fDrawing.Width, fDrawing.Height);

  radius := max(fDrawing.Height, fDrawing.Width) div 2;

  drawTicks(fHoPo, 12);
  drawTicks(fMiPo, 60);

  x1 := fDrawing.Width * 8 div 500  + fDrawing.Canvas.Pen.Width div 2;
  fDrawing.Canvas.Pen.Color := Color;
  fDrawing.Canvas.Pen.Width := fDrawing.Width * 13 div 500;
  fDrawing.Canvas.Brush.Style := bsClear;
  DrawAAElipse(fDrawing, -x1, -x1, fDrawing.Width + x1, fDrawing.Height + x1);
  DrawAAElipse(fDrawing, x1 + fHoPo.Length * fDrawing.Width div 1000,
    x1 + fHoPo.Length * fDrawing.Width div 1000,
    fDrawing.Width - x1 - fHoPo.Length * fDrawing.Width div 1000,
    fDrawing.Height - x1 - fHoPo.Length * fDrawing.Width div 1000);

  fFace.Assign(fDrawing);
end;

procedure TJBClock.Paint;
begin
  PaintTime;
end;

procedure TJBClock.DoTick;
begin
  if Assigned(FOnTick) then FOnTick(Self);
end;

procedure TJBClock.TimeTick(Sender: TObject);
begin
  if round(fTime * 24 * 60 * 60) = round(Time * 24 * 60 * 60) then
    Exit;
  fTime := Time;
  PaintTime;
  DoTick;
end;

procedure TJBClock.PaintTime;
var
  H, M, S, MS: Word;
  x, y, radius: Integer;
  xrel, yrel: real;

  procedure DrawLine(aPen: TJBLine; position: real; modulo: integer; middle: integer);
  var
    lwidth: integer;
    middlew: integer;
  begin
    radius := fDrawing.Width div 2;
    fDrawing.Canvas.Pen.Assign(aPen);
    fDrawing.Canvas.Brush.Color := fDrawing.Canvas.Pen.Color;
    lwidth := fDrawing.Canvas.Pen.Width;

    fDrawing.Canvas.Pen.Width := fDrawing.Width * lwidth div 1000;
    xrel := Sin((position) / modulo * Pi * 2);
    yrel := -Cos((position) / modulo * Pi * 2);
    x := round(xrel * aPen.Length * radius / 100 + radius);
    y := round(yrel * aPen.Length * radius / 100 + radius);

    DrawAALine(fDrawing, lwidth * fDrawing.Width / 1000, radius, radius, x, y);

    fDrawing.Canvas.Pen.Width := fDrawing.Width * lwidth div 500;
    middlew := middle * fDrawing.Width div 1000;
    DrawAAElipse(fDrawing, radius + middlew, radius + middlew, radius - middlew, radius - middlew);

    fDrawing.Canvas.Pen.Width := lwidth;
  end;

begin
  DecodeTime(fTime, H, M, S, MS);

  fHands.Height := fFace.Height;
  fHands.Width := fFace.Width;

  fDrawing.Height := fFace.Height;
  fDrawing.Width := fFace.Width;

  fDrawing.Canvas.Brush.Color := fColor;
  fDrawing.Canvas.Pen.Color := fColor;
  fDrawing.Canvas.Rectangle(0, 0, fDrawing.Width, fDrawing.Height);

  DrawLine(fHour, H mod 12 + M / 60, 12, 8);
  DrawLine(fMinute, M + S / 60, 60, 18);
  DrawLine(fSecond, S, 60, 15);

  fHands.Assign(fDrawing);
  fDrawing.Assign(fFace);
  fHands.Transparent := true;
  fHands.TransparentColor := fColor;
  fDrawing.Canvas.Draw(0, 0, fHands);
  fHands.Transparent := false;

  Canvas.Draw(0, 0, fDrawing);
end;

end.

