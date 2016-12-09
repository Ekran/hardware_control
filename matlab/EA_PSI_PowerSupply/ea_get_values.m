function [Values,error, Statustext] = ea_get_values( com_port, EA_Addr)
%[error, Statustext, Values] = ea_get_values( com_port, EA_Addr)
%  Übergabeparameter: com_port = z.B. 'COM3' (= default)
%                     EA_Addr  = z.B. 0 (= default)
% Rückgabewerte     : error    = 0, kein Fehler, >=1: Fehler
%                     Statustext: Text mit Status
%                     Values = Array [current, voltage, status,
%                     max_current, max_voltage, set_voltage]
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$

try
error = 0;

if nargin < 2, EA_Addr = 0; end
if nargin < 1, com_port = 'com3' ; end


    s = ea_psi6032_open_comport(com_port);
        

% in Remote-Zustand schalten
ea_psi6032_set_remote(1,s,EA_Addr);
[Fehler Beschreibung data] = ea_psi6032_get_answer(s,EA_Addr);
error = error + Fehler;
if Fehler ; disp(Beschreibung); end

% Werte anfordern
ea_psi6032_get_values(s,EA_Addr)
[Fehler Beschreibung data] = ea_psi6032_get_answer(s,EA_Addr);
error = error + Fehler;
if Fehler;  disp(Beschreibung); end

current = (data(4)+data(5)*256)/1000;
voltage = (data(6)+data(7)*256+data(8)*65536+data(9)*16777216)/1000;
status = data(10);
max_current = (data(11)+data(12)*256)/1000;
max_voltage = (data(13)+data(14)*256+data(15)*65536+data(16)*16777216)/1000;
set_voltage = (data(17)+data(18)*256+data(19)*65536+data(20)*16777216)/1000;
Values = [current, voltage, status, max_current, max_voltage, set_voltage];

% in Remote-Zustand verlassen
ea_psi6032_set_remote(0,s,EA_Addr);
[Fehler Beschreibung data] = ea_psi6032_get_answer(s,EA_Addr);
error = error + Fehler;
if Fehler;  disp(Beschreibung); end

if nargout == 0
   disp 'ans = [current, voltage, status, max_current, max_voltage, set_voltage];'
end

ea_psi6032_close_comport(s)



if error
    Statustext = strcat(mfilename,' Fehler: Es sind Fehler aufgetreten ');
else
    Statustext = strcat(mfilename,' OK: Werte ausgelesen');
end
catch
error_message = lasterr;
error = 1;
Statustext = strcat(mfilename,' Fehler: Programm unerwartet beendet! Meldung', error_message);
disp(Statustext)
ea_psi6032_close_comport( s )

end