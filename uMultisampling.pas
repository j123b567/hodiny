unit uMultisampling;

interface
uses SysUtils, Graphics;

type
  TJBMultisamplingType = (x00, x08, x16);

procedure Multisampling(aSource, aDest: TBitmap; aType: TJBMultisamplingType);

implementation

procedure MultisamplingNone(aSource, aDest: TBitmap);
begin
  aDest.Assign(aSource);
end;

procedure MultisamplingX8(aSource, aDest: TBitmap);
var
  P1, P2, P3: PByteArray;
  x, y: integer;
begin
  for y := 0 to aDest.Height - 1 do
    begin
      P1 := aSource.ScanLine[2 * y];
      P2 := aSource.ScanLine[2 * y + 1];
      P3 := aDest.ScanLine[y];
      for x := 0 to aDest.Width - 1 do
        begin
          P3[x * 3] := (P1[2 * 3 * x] + P1[2 * 3 * x + 3] + P2[2 * 3 * x] + P2[2 * 3 * x + 3]) div 4;
          P3[x * 3 + 1] := (P1[2 * 3 * x + 1] + P1[2 * 3 * x + 4] + P2[2 * 3 * x + 1] + P2[2 * 3 * x + 4]) div 4;
          P3[x * 3 + 2] := (P1[2 * 3 * x + 2] + P1[2 * 3 * x + 5] + P2[2 * 3 * x + 2] + P2[2 * 3 * x + 5]) div 4;
        end;
    end;
end;

procedure MultisamplingX16(aSource, aDest: TBitmap);
var
  P1, P2, P3, P4, P5: PByteArray;
  x, y: integer;
begin
  for y := 0 to aDest.Height - 1 do
    begin
      P1 := aSource.ScanLine[4 * y];
      P2 := aSource.ScanLine[4 * y + 1];
      P3 := aSource.ScanLine[4 * y + 2];
      P4 := aSource.ScanLine[4 * y + 3];
      P5 := aDest.ScanLine[y];
      for x := 0 to aDest.Width - 1 do
        begin
          P5[x * 3] := (P1[4 * 3 * x] + P1[4 * 3 * x + 3] + P1[4 * 3 * x + 6] + P1[4 * 3 * x + 9] +
            P2[4 * 3 * x] + P2[4 * 3 * x + 3] + P2[4 * 3 * x + 6] + P2[4 * 3 * x + 9] +
            P3[4 * 3 * x] + P3[4 * 3 * x + 3] + P3[4 * 3 * x + 6] + P3[4 * 3 * x + 9] +
            P4[4 * 3 * x] + P4[4 * 3 * x + 3] + P4[4 * 3 * x + 6] + P4[4 * 3 * x + 9]) div 16;
          P5[x * 3 + 1] := (P1[4 * 3 * x + 1] + P1[4 * 3 * x + 4] + P1[4 * 3 * x + 7] + P1[4 * 3 * x + 10] +
            P2[4 * 3 * x + 1] + P2[4 * 3 * x + 4] + P2[4 * 3 * x + 7] + P2[4 * 3 * x + 10] +
            P3[4 * 3 * x + 1] + P3[4 * 3 * x + 4] + P3[4 * 3 * x + 7] + P3[4 * 3 * x + 10] +
            P4[4 * 3 * x + 1] + P4[4 * 3 * x + 4] + P4[4 * 3 * x + 7] + P4[4 * 3 * x + 10]) div 16;
          P5[x * 3 + 2] := (P1[4 * 3 * x + 2] + P1[4 * 3 * x + 5] + P1[4 * 3 * x + 8] + P1[4 * 3 * x + 11] +
            P2[4 * 3 * x + 2] + P2[4 * 3 * x + 5] + P2[4 * 3 * x + 8] + P2[4 * 3 * x + 11] +
            P3[4 * 3 * x + 2] + P3[4 * 3 * x + 5] + P3[4 * 3 * x + 8] + P3[4 * 3 * x + 11] +
            P4[4 * 3 * x + 2] + P4[4 * 3 * x + 5] + P4[4 * 3 * x + 8] + P4[4 * 3 * x + 11]) div 16;
        end;
    end;
end;

procedure Multisampling(aSource, aDest: TBitmap; aType: TJBMultisamplingType);
begin
  case aType of
    x00: MultisamplingNone(aSource, aDest);
    x08: MultisamplingX8(aSource, aDest);
    x16: MultisamplingX16(aSource, aDest);
  end;
end;

end.
