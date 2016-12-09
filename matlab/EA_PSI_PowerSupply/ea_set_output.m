function [error, Statustext] = ea_set_output( output_state, com_port, EA_Addr)
%ea_set_output schaltet Ausgang ein und aus
%  Übergabeparameter: output_state  = 0 - deaktiviert
%                                     1 - aktiviert
%                     com_port = z.B. 'COM3' (= default)
%                     EA_Addr  = z.B. 0 (= default)
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$

error = 0;

if nargin < 3, EA_Addr = 0; end
if nargin < 2, com_port = 'com3' ; end

try
BAUD = 9600;
s = serial(com_port);
%if strcmp(get(s, 'status'), 'closed') == 1 % Wenn Port geschlossen ist
fopen(s)
s.ReadAsyncMode = 'continuous';
s.BaudRate = BAUD;
% Schnittstelle, Eingangspuffer leer räumen
if (s.BytesAvailable > 0)
    [data  count ] = fread(s, s.BytesAvailable); 
end

% in Remote-Zustand schalten
ea_psi6032_set_remote(1,s,0);
[Fehler Beschreibung data] = ea_psi6032_get_answer(s,0);
error = error + Fehler;
if Fehler ; disp(Beschreibung); end

% Ausgang setzen
ea_psi6032_set_output(output_state,s,EA_Addr);
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