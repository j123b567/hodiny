unit fConf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, XPMan, jbClock;

const
  configIniFile: string = 'jbClock.ini';

type
  TfrmConf = class(TForm)
    GroupColors: TGroupBox;
    lblColorHour: TLabel;
    lblColorMinute: TLabel;
    lblColorSecond: TLabel;
    lblColorTicks: TLabel;
    lblColorBackground: TLabel;
    Panel1: TPanel;
    btnInfo: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    colorHour: TPanel;
    colorMinute: TPanel;
    colorSecond: TPanel;
    colorTicks: TPanel;
    colorBackground: TPanel;
    dlgColor: TColorDialog;
    XPManifest1: TXPManifest;
    pnlScreen: TPanel;
    grpSize: TGroupBox;
    edtSize: TTrackBar;
    lblSmall: TLabel;
    lblMiddle: TLabel;
    lblLarge: TLabel;
    boxMovement: TGroupBox;
    boxCenter: TCheckBox;
    boxRandom: TCheckBox;
    boxDrawing: TGroupBox;
    btnAntialiasing: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnInfoClick(Sender: TObject);
    procedure edtSizeChange(Sender: TObject);
    procedure boxCenterClick(Sender: TObject);
    procedure colorClick(Sender: TObject);
    procedure boxRandomClick(Sender: TObject);
    procedure btnAntialiasingClick(Sender: TObject);
  private
    fMover: TJBMover;
    fClock: TJBClock;
    procedure ClockInit(fClock: TJBClock);
  public
    { Public declarations }

  end;

var
  frmConf: TfrmConf;

procedure LoadIniFile(FileName: string; aClock: TJBClock; aMover: TJBMover);
procedure SaveIniFile(FileName: string; aClock: TJBClock; aMover: TJBMover);

implementation

{$R *.dfm}

uses IniFiles, fAbout;

procedure TfrmConf.btnOKClick(Sender: TObject);
begin
  SaveIniFile(configIniFile, fClock, fMover);
  Close;
end;

procedure TfrmConf.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmConf.ClockInit(fClock: TJBClock);
begin
  with fClock do
  begin
      Left := 56;
      Top := 24;
      Width := 105;
      Height := 105;
      Go := True;
      Oclock := Time;
      Antialiasing := True;
  end;
end;

procedure TfrmConf.FormCreate(Sender: TObject);
begin
  fClock := TJBClock.Create(pnlScreen);
  fClock.Parent := pnlScreen;
  ClockInit(fClock);

  fMover := TJBMover.Create(fClock);
  fMover.Width := pnlScreen.Width;
  fMover.Height := pnlScreen.Height;

  fClock.OnTick := fMover.MoveWithMe;

  fMover.InitPlace;

  LoadIniFile(configIniFile, fClock, fMover);
  edtSize.Position := fMover.Size;
  boxCenter.Checked := not fMover.Move;
  boxRandom.Checked := fMover.RandomMove;
  boxRandom.Enabled := fMover.Move;

//  colorHour.Color := fClock.Hour.Color;
  colorHour.color := fClock.Hour.Color;
  colorMinute.Color := fClock.Minute.Color;
  colorSecond.Color := fClock.Second.Color;
  colorTicks.Color := fClock.HoPo.Color;
  colorBackground.Color := fClock.Color;
  pnlScreen.Color := fClock.Color;

  btnAntialiasing.checked := fClock.Antialiasing;
end;

procedure TfrmConf.btnInfoClick(Sender: TObject);
begin
  AboutBox := TAboutBox.create(self);
  AboutBox.ShowModal;
  AboutBox.Free;
end;

procedure TfrmConf.edtSizeChange(Sender: TObject);
begin
  fMover.Size := edtSize.Position;
end;

procedure LoadIniFile(FileName: string; aClock: TJBClock; aMover: TJBMover);
const
  section: string = 'jbClock';
var
  inif: TIniFile;
begin
  inif := TIniFile.Create(configIniFile);
  aClock.Hour.Color := inif.ReadInteger(section, 'HourColor', clWhite);
  aClock.Minute.Color := inif.ReadInteger(section, 'MinuteColor', clWhite);
  aClock.Second.Color := inif.ReadInteger(section, 'SecondColor', clRed);
  aClock.HoPo.Color := inif.ReadInteger(section, 'HoPoColor', clWhite);
  aClock.MiPo.Color := inif.ReadInteger(section, 'MiPoColor', clWhite);
  aClock.Color := inif.ReadInteger(section, 'BgColor', clBlack);
  aClock.Antialiasing := inif.ReadBool(section, 'Antialiasing', True);
  aMover.Size := inif.ReadInteger(section, 'Size', 4);
  aMover.Move := inif.ReadBool(section, 'Move', true);
  aMover.RandomMove := inif.ReadBool(section, 'RandomMove', false);
  inif.Free;
end;

procedure SaveIniFile(FileName: string; aClock: TJBClock; aMover: TJBMover);
const
  section: string = 'jbClock';
var
  inif: TIniFile;
begin
  inif := TIniFile.Create(configIniFile);
  inif.WriteInteger(section, 'HourColor', aClock.Hour.Color);
  inif.WriteInteger(section, 'MinuteColor', aClock.Minute.Color);
  inif.WriteInteger(section, 'SecondColor', aClock.Second.Color);
  inif.WriteInteger(section, 'HoPoColor', aClock.HoPo.Color);
  inif.WriteInteger(section, 'MiPoColor', aClock.MiPo.Color);
  inif.WriteInteger(section, 'BgColor', aClock.Color);
  inif.WriteBool(section, 'Antialiasing', aClock.Antialiasing);
  inif.WriteInteger(section, 'Size', aMover.Size);
  inif.WriteBool(section, 'Move', aMover.Move);
  inif.WriteBool(section, 'RandomMove', aMover.RandomMove);
  inif.Free;
end;

procedure TfrmConf.boxCenterClick(Sender: TObject);
begin
  fMover.Move := not (Sender as TCheckBox).Checked;
  boxRandom.Enabled := fMover.Move;
end;

procedure TfrmConf.colorClick(Sender: TObject);
var
  pnl: TPanel;
begin
  pnl := (Sender as TPanel);
  dlgColor.Color := pnl.Color;
  if dlgColor.Execute then pnl.Color := dlgColor.color;
  if pnl = colorHour then
    begin
      fClock.Hour.Color := pnl.Color;
    end
  else if pnl = colorMinute then
    begin
      fClock.Minute.Color := pnl.Color;
    end
  else if pnl = colorSecond then
    begin
      fClock.Second.Color := pnl.Color;
    end
  else if pnl = colorTicks then
    begin
      fClock.HoPo.Color := pnl.Color;
      fClock.MiPo.Color := pnl.Color;
    end
  else if pnl = colorBackground then
    begin
      fClock.Color := pnl.Color;
      pnlScreen.Color := pnl.Color;
    end
  else
    begin
      //ShowMessage('nene');
    end;
end;

procedure TfrmConf.boxRandomClick(Sender: TObject);
begin
  fMover.RandomMove := (Sender as TCheckBox).Checked;
end;

procedure TfrmConf.btnAntialiasingClick(Sender: TObject);
begin
  fClock.Antialiasing := (Sender as TCheckBox).Checked;
end;

end.

