program a_priori_risks;

{$MODE Delphi}

{$APPTYPE CONSOLE}
uses
  SysUtils;

var
  T21, T13, T18     : array[1..26, 1..11] of integer;
  switch             : integer;
  t21_risk, t18_risk, T13_risk, gestation, mat_age: extended;
  invoer   : text;
  endline : boolean;
function lees_tab: string;
var
  kar: char;
  res: string;
begin
  res := '';
  repeat
    read(invoer, kar);
    endline := (kar = #10);
//    if (kar <> #9) and not eoln(invoer) and not eof(invoer) then
    if not (kar in [chr(9), chr(10), chr(13), chr(32), ',']) then
      res := res + kar;
  until (kar = #32) or (kar = #9) or (kar = ',') or endline or eof(invoer);
  lees_tab := res;
  if eof(invoer) then endline := true;
end;
procedure read_data;
var
start,i,j : integer;
begin
  assignfile(invoer, 'T21risk.txt');
  reset(invoer);
  readln(invoer);
  readln(invoer);
  lees_tab; //skip table entry description
  T21[1, 1] := 0;
  for i := 1 to 26 do
  begin
    if i = 1 then
      start := 2
    else
      start := 1;
    for j := start to 9 do
      T21[i, j] := strtoint(lees_tab);
  end;
  closefile(invoer);
  assignfile(invoer, 'T18risk.txt');
  reset(invoer);
  readln(invoer);
  readln(invoer);
  lees_tab; //skip table entry description
  T18[1, 1] := 0;
  for i := 1 to 26 do
  begin
    if i = 1 then
      start := 2
    else
      start := 1;
    for j := start to 11 do
      T18[i, j] := strtoint(lees_tab);
  end;
  closefile(invoer);
  assignfile(invoer, 'T13risk.txt');
  reset(invoer);
  readln(invoer);
  readln(invoer);
  lees_tab; //skip table entry description
  T13[1, 1] := 0;
  for i := 1 to 18 do
  begin
    if i = 1 then
      start := 2
    else
      start := 1;
    for j := start to 7 do
      T13[i, j] := strtoint(lees_tab);
  end;

end;

procedure t21_prior;
// purpose : interpolate table to find risk of trisomy 21 and put result
// in field for prior frequency

var
  i, j              : integer;
  estimate1, estimate2, f1, f2: extended;
  found1, found2    : boolean;
begin
  // find entry for gestation
  i := 1;
  repeat
    inc(i);
    found1 := (t21[1, i] <= gestation) and (t21[1, i + 1] >= gestation);
  until (i = 8) or found1;
  // find entry for maternal age
  j := 1;
  repeat
    inc(j);
    found2 := (t21[j, 1] <= mat_age) and (t21[j + 1, 1] >= mat_age);
  until (j = 25) or found2;
  if found1 and found2 then
  begin
  // linear bivariate interpolation
  // the table has the shape of number when 1/number is the probability
  // the number is approximated by linear interpolation

    f1 := (gestation - T21[1, i]) / (T21[1, i + 1] - T21[1, i]);
    f2 := (mat_age - T21[j, 1]) / (T21[j + 1, 1] - T21[j, 1]);
    estimate1 := (1 - f1) * T21[j, i] + f1 * t21[j, i + 1];
    estimate2 := (1 - f1) * T21[j + 1, i] + f1 * t21[j + 1, i + 1];
    t21_risk := (1 - f2) * estimate1 + f2 * estimate2;
  end
  else
    write('no extrapolation possible, data outside table');
end;

procedure T18_prior;
// purpose : interpolate table to find risk of trisomy 21 and put result
// in field for prior frequency

var
  i, j              : integer;
  estimate1, estimate2, f1, f2: extended;
  found1, found2    : boolean;
begin
  // find entry for maternal age
  i := 1;
  repeat
    inc(i);
    found1 := (t18[1, i] <= gestation) and (t18[1, i + 1] >= gestation);
  until (i = 10) or found1;
  // find entry for maternal age
  j := 1;
  repeat
    inc(j);
    found2 := (t18[j, 1] <= mat_age) and (t18[j + 1, 1] >= mat_age);
  until (j = 25) or found2;
  if found1 and found2 then
  begin
  // linear bivariate interpolation
  // the table has the shape of number when 1/number is the probability
  // the number is approximated by linear interpolation

    f1 := (gestation - T18[1, i]) / (T18[1, i + 1] - T18[1, i]);
    f2 := (mat_age - T18[j, 1]) / (T18[j + 1, 1] - T18[j, 1]);
    estimate1 := (1 - f1) * T18[j, i] + f1 * t18[j, i + 1];
    estimate2 := (1 - f1) * T18[j + 1, i] + f1 * t18[j + 1, i + 1];
    t18_risk := (1 - f2) * estimate1 + f2 * estimate2;
  end
  else
    write('no extrapolation possible, data outside table');

end;

procedure T13_prior;
// purpose : interpolate table to find risk of trisomy 21 and put result
// in field for prior frequency

var
  i, j              : integer;
  estimate1, estimate2, f1, f2: extended;
  found1, found2    : boolean;
begin
  // find entry for maternal age
  i := 1;
  repeat
    inc(i);
    found1 := (T13[1, i] <= gestation) and (T13[1, i + 1] >= gestation);
  until (i = 6) or found1;
  // find entry for maternal age
  j := 1;
  repeat
    inc(j);
    found2 := (T13[j, 1] <= mat_age) and (T13[j + 1, 1] >= mat_age);
  until (j = 17) or found2;
  if found1 and found2 then
  begin
  // linear bivariate interpolation
  // the table has the shape of number when 1/number is the probability
  // the number is approximated by linear interpolation

    f1 := (gestation - T13[1, i]) / (T13[1, i + 1] - T13[1, i]);
    f2 := (mat_age - T13[j, 1]) / (T13[j + 1, 1] - T13[j, 1]);
    estimate1 := (1 - f1) * T13[j, i] + f1 * T13[j, i + 1];
    estimate2 := (1 - f1) * T13[j + 1, i] + f1 * T13[j + 1, i + 1];
    T13_risk := (1 - f2) * estimate1 + f2 * estimate2;
  end
  else
    write('no extrapolation possible, data outside table');

end;

begin

  read_data;
  gestation := strtofloat(paramstr(1));
  mat_age := strtofloat(paramstr(2));
  switch := strtoint(paramstr(3));
  case switch of
    0: writeln('error invalid switch');
    13:
      begin
        t13_prior;
        writeln(T13_risk: 6: 0);
      end;
    18:
      begin
        t18_prior;
        writeln(T18_risk: 6: 0);
      end;
    21:
      begin
        t21_prior;
        writeln(T21_risk: 6: 0);
      end;
  end;
  end.