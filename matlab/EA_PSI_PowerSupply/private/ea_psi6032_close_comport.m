function ea_psi6032_close_comport( s )
%ea_psi6032_close_comport schliesst den COM port und löscht die Variablen
%  Detailed explanation goes here
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$

fclose(s)
delete(s)
clear s