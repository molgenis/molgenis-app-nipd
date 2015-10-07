program Commandline_risk_NIPT;

{$MODE Delphi}

{$APPTYPE CONSOLE}
uses sysutils;
var
  a_priori, Z_observed, ptris3, lower, upper,
    interval, Varcof: extended;

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



begin

  Varcof := strtofloat(paramstr(5));
  Z_observed := strtofloat(paramstr(1));
  lower := 0.5 * strtofloat(paramstr(2)) / Varcof;
  upper := 0.5 * strtofloat(paramstr(3)) / Varcof;
    if upper - lower < 0.002 then
      // this is done to handle the case that the upper and lower limit are
      // identical
    begin
      lower := lower - 0.001;
      upper := upper + 0.001;
    end;
    interval := upper - lower;
    a_priori := 1 / strtofloat(paramstr(4));
    ptris3 := (cumnor(Z_observed - upper) - cumnor(Z_observed - lower)) /
      interval;
      // this is the average likelihood of the Normal distribution
      // over an interval Z_observed - upper to Z_observed - lower
      // this result is not obtained by direct integration,
      // but by using an accurate function for the cumulative normal distribution
    ptris3 := ptris3 * a_priori / (ptris3 * a_priori +
      (1 - a_priori) * exp(-Z_observed * Z_observed / 2.0) / sqrt(2 * pi));
    writeln(100 * ptris3: 6: 3);

end.

