program commandline_risk_nipt_augustus;
{$APPTYPE CONSOLE}
uses
  SysUtils;



var
  Threshold,gestation, mat_age : extended;
  glit: integer;
  invoer, uitvoer: text;
  file_open, field_error, outtofile: boolean;
  t21, t18, t13: array[1..26, 1..11] of integer;
  endline: boolean;
  t21_risk,T18_risk,T13_risk : string;
  
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

function Cumnor(x: extended): extended;
// this is a variant for the probability that x > X is X  is normally distributed
// with variance 1 and mean 0. It is derived from an article by graeme west
// and should be correct in double precision. I checked its concordance with
// the approximation in Abramowitz and Stegun. The relative difference for large
// values of the argument is small, for small arguments it is larger
var
  Exponential, build, temp, xabs: extended;

begin
  if x > 0.0 then
    XAbs := x
  else
    Xabs := -x;
  if XAbs > 37 then
    temp := 0.0
  else
  begin
    Exponential := Exp(-0.5 * XAbs * Xabs);
    if XAbs < 7.07106781186547 then
    begin
      build := 3.52624965998911E-02 * XAbs + 0.700383064443688;
      build := build * XAbs + 6.37396220353165;
      build := build * XAbs + 33.912866078383;
      build := build * XAbs + 112.079291497871;
      build := build * XAbs + 221.213596169931;
      build := build * XAbs + 220.206867912376;
      temp := Exponential * build;
      build := 8.83883476483184E-02 * XAbs + 1.75566716318264;
      build := build * XAbs + 16.064177579207;
      build := build * XAbs + 86.7807322029461;
      build := build * XAbs + 296.564248779674;
      build := build * XAbs + 637.333633378831;
      build := build * XAbs + 793.826512519948;
      build := build * XAbs + 440.413735824752;
      temp := temp / build;
    end
    else
    begin
      build := XAbs + 0.65;
      build := XAbs + 4 / build;
      build := XAbs + 3 / build;
      build := XAbs + 2 / build;
      build := XAbs + 1 / build;
      temp := Exponential / build / 2.506628274631
    end;
  end;
  if x < 0 then
    Cumnor := 1.0 - temp
  else
    Cumnor := temp;
end;

function check_content(content: string): string;
var
  tmp: string;
  i, j: integer;
begin
  tmp := '';
  j := 0;
  for i := 1 to length(content) do
  begin
    if content[i] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.','-'] then
      tmp := tmp + content[i] else
    begin
      writeln('format error in datafield');
      field_error := true;
      tmp := '0';
    end;
    if content[i] = '.' then inc(j);

  end;
  if j > 1 then
  begin
    writeln('format error in datafield');
    field_error := true;
    check_content := '0';
  end;
  check_content := tmp;
end;



procedure compute;
var
  a_priori, a_posteriori, Z_expected, Z_observed, ptris3, ptris, lower, upper,
    interval, sensitivity, Varcof: extended;
  a_priori_uit : string;
begin
     writeln('lower_limit upper_limit variation_coefficient a_priori_risk_p Observed_Z_score Ptrisomy_p table$ gest_age mat_age');
  field_error := false;
  Varcof := strtofloat(check_content(paramstr(3)));
  Z_observed := strtofloat(check_content(paramstr(6)));
  lower := 0.5 * strtofloat(check_content(paramstr(1))) / Varcof;
  upper := 0.5 * strtofloat(check_content(paramstr(2))) / Varcof;
  if not field_error then
  begin
    if upper - lower < 0.002 then
      // this is done to handle the case that the upper and lower limit are
      // identical
    begin
      lower := lower - 0.001;
      upper := upper + 0.001;
    end;
    interval := upper - lower;
    a_priori := 1/strtofloat(check_content(paramstr(4)));
    a_priori:=a_priori+
    strtofloat(check_content(paramstr(5)))/100.0;
    a_priori_uit:=floattostrf(1/a_priori,ffFixed,6,0);
    ptris3 := (cumnor(Z_observed - upper) - cumnor(Z_observed - lower)) / interval;
      // this is the average likelihood of the Normal distribution
      // over an interval Z_observed - upper to Z_observed - lower
      // this result is not obtained by direct integration,
      // but by using an accurate function for the cumulative normal distribution
    ptris3 := ptris3 * a_priori / (ptris3 * a_priori +
      (1 - a_priori) * exp(-Z_observed * Z_observed / 2.0) / sqrt(2 * pi));
    writeln(lower: 6: 2, chr(9), upper: 6: 2, chr(9),
        Varcof: 6: 3, chr(9), 100*a_priori: 6: 3, chr(9), Z_observed: 6: 3,
        chr(9), 100*ptris3: 6: 3,chr(9),gestation:5:1,
        chr(9),mat_age:6:1,a_priori_uit,chr(9),t21_risk,chr(9),t18_risk,
        chr(9),t13_risk);
  end;
end;

procedure lees_tabellen;
var i, j, start: integer;
begin
   assignfile(invoer, 'T21risk.txt');
  reset(invoer);
  readln(invoer);
  readln(invoer);
  lees_tab; //skip table entry description
  T21[1, 1] := 0;
  for i := 1 to 26 do
  begin
    if i = 1 then start := 2 else start := 1;
    for j := start to 9 do T21[i, j] := strtoint(lees_tab);
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
    if i = 1 then start := 2 else start := 1;
    for j := start to 11 do T18[i, j] := strtoint(lees_tab);
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
    if i = 1 then start := 2 else start := 1;
    for j := start to 7 do T13[i, j] := strtoint(lees_tab);
  end;
end;






procedure tabel_risk_21;
// purpose : interpolate table to find risk of trisomy 21 and put result
// in field for prior frequency

var i, j: integer;
  estimate, estimate1, estimate2, f1, f2: extended;
  found1, found2: boolean;
begin
  gestation := strtofloat(check_content(paramstr(7)))+
  strtofloat(check_content(paramstr(8)))/7.0;
  mat_age := strtofloat(check_content(paramstr(9)))+
  strtofloat(check_content(paramstr(10)))/12.0;

  // find entry for gestation
  i := 1;
  found1 := false;
  repeat
    inc(i);
    found1 := (t21[1, i] <= gestation) and (t21[1, i + 1] >= gestation);
  until (i = 8) or found1;
  // find entry for maternal age
  j := 1;
  found2 := false;
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
    estimate1 := (1-f1) * T21[j, i] + f1 * t21[j, i + 1];
    estimate2 := (1-f1) * T21[j + 1, i] + f1 * t21[j + 1, i + 1];
    estimate := (1-f2) * estimate1 + f2 * estimate2;
    t21_risk := floattostrf(estimate,fffixed, 6, 0);

  end else
    writeln('no extrapolation possible, data outside table 21');
end;

procedure tabel_risk_18;
// purpose : interpolate table to find risk of trisomy 21 and put result
// in field for prior frequency

var i, j: integer;
  estimate, estimate1, estimate2, f1, f2: extended;
  found1, found2: boolean;
begin
   gestation := strtofloat(check_content(paramstr(7)))+
  strtofloat(check_content(paramstr(8)))/7.0;
  mat_age := strtofloat(check_content(paramstr(9)))+
  strtofloat(check_content(paramstr(10)))/12.0;

  // find entry for maternal age
  i := 1;
  found1 := false;
  repeat
    inc(i);
    found1 := (t18[1, i] <= gestation) and (t18[1, i + 1] >= gestation);
  until (i = 10) or found1;
  // find entry for maternal age
  j := 1;
  found2 := false;
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
    estimate1 := (1-f1) * T18[j, i] + f1 * t18[j, i + 1];
    estimate2 := (1-f1) * T18[j + 1, i] + f1 * t18[j + 1, i + 1];
    estimate := (1-f2) * estimate1 + f2 * estimate2;
    t18_risk:= floattostrf(estimate,fffixed, 6, 0);

  end else
    writeln('no extrapolation possible, data outside table 18');


end;

procedure tabel_risk_13;
// purpose : interpolate table to find risk of trisomy 21 and put result
// in field for prior frequency

var i, j: integer;
  estimate, estimate1, estimate2, f1, f2: extended;
  found1, found2: boolean;
begin
   gestation := strtofloat(check_content(paramstr(7)))+
  strtofloat(check_content(paramstr(8)))/7.0;
  mat_age := strtofloat(check_content(paramstr(9)))+
  strtofloat(check_content(paramstr(10)))/12.0;

  // find entry for maternal age
  i := 1;
  found1 := false;
  repeat
    inc(i);
    found1 := (T13[1, i] <= gestation) and (T13[1, i + 1] >= gestation);
  until (i = 6) or found1;
  // find entry for maternal age
  j := 1;
  found2 := false;
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
    estimate1 := (1-f1) * T13[j, i] + f1 * T13[j, i + 1];
    estimate2 := (1-f1) * T13[j + 1, i] + f1 * T13[j + 1, i + 1];
    estimate := (1-f2) * estimate1 + f2 * estimate2;
    T13_risk := floattostrf(estimate,fffixed, 6, 0);
  end else
    writeln('no extrapolation possible, data outside table 13');
  
end;

begin
lees_tabellen;
tabel_risk_13;
tabel_risk_18;
tabel_risk_21;
compute;

end. 