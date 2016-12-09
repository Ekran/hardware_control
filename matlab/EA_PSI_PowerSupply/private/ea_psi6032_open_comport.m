function s = ea_psi6032_open_comport( com_port )
%ea_psi6032_open_comport öffnet den COM port, stellt 9600 Baud ein und
%löscht den RX-Buffer
%  Detailed explanation goes here
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$

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