function [error, Statustext] = ea_set_max_voltage( voltage, com_port, EA_Addr)
%ea_set_voltage setzt im Netzteil die Ausgangsspannung
%  Übergabeparameter: voltage  = Spannung in Volt
%                     com_port = z.B. 'COM3' (= default)
%                     EA_Addr  = z.B. 0 (= default)
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$

error = 0;

if nargin < 3, EA_Addr = 0; end
if nargin < 2, com_port = 'com3' ; end

try
    s = ea_psi6032_open_comport( com_port );

% in Remote-Zustand schalten
ea_psi6032_set_remote(1,s,0);
[Fehler Beschreibung data] = ea_psi6032_get_answer(s,0);
error = error + Fehler;
if Fehler ; disp(Beschreibung); end

% Spannung einstellen
ea_psi6032_set_max_voltage(voltage,s,EA_Addr)
[Fehler Beschreibung data] = ea_psi6032_get_answer(s,0);
error = error + Fehler;
if Fehler;  disp(Beschreibung); end

% in Remote-Zustand verlassen
ea_psi6032_set_remote(0,s,0);
[Fehler Beschreibung data] = ea_psi6032_get_answer(s,0);
error = error + Fehler;
if Fehler;  disp(Beschreibung); end


% Serial Port schließen und Zugriff löschen
ea_psi6032_close_comport( s );

if error
    Statustext = strcat(mfilename,' Fehler: Es sind Fehler aufgetreten ');
else
    Statustext = strcat(mfilename,' OK: Spannung eingestellt');
end
catch
error_message = lasterr;
error = 1;
Statustext = strcat(mfilename,' Fehler: Programm unerwartet beendet! Meldung: ', error_message);
disp(Statustext)
ea_psi6032_close_comport( s );
end