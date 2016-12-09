function [Fehler Beschreibung data] = ea_psi6032_get_answer(serial_port, EA_Addr)
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$

%disp 'get_answer'
Fehler = 0;
Beschreibung = '';
data = '';
count = 0;

pause(0.075)

if (serial_port.BytesAvailable > 0)
    % out = fscanf(s)
    [data  count ] = fread(serial_port, serial_port.BytesAvailable);
end

if (count == 26)
   % '0xAA' - Startbyte        
   % Adresse des Geräts
   % '0x12' - Antworttelegram
    if ( data(1) == 170 & ...
       data(2) == EA_Addr & ...
       data(3) == 18)  
           
       if(data(4) == hex2dec('90'))
           Beschreibung = strcat(Beschreibung, 'Fehler: Prüfsumme nicht korrekt\n');
           Fehler = Fehler + 1;
           % disp 
       end
       
       if(data(4) == hex2dec('a0'))
           % disp 'Fehler: Fehler bei der Parametereingabe'
           Beschreibung = strcat(Beschreibung, 'Fehler: Fehler bei der Parametereingabe\n');
           Fehler = Fehler + 1;
       end
       
       if(data(4) == hex2dec('b0'))
           % disp 'Fehler: Befehle wurde nicht ausgeführt'
           Beschreibung = strcat(Beschreibung, 'Fehler: Befehle wurde nicht ausgeführt\n');
           Fehler = Fehler + 1;
       end
       
       if(data(4) == hex2dec('c0'))
           % disp 'Fehler: Befehle ist nicht wirksam'
           Beschreibung = strcat(Beschreibung, 'Fehler: Befehle ist nicht wirksam\n');
           Fehler = Fehler + 1;
       end

       if(data(4) == hex2dec('80'))
           % disp 'Befehl erfolgreich!'
           Beschreibung = strcat(Beschreibung, 'Befehl erfolgreich!\n');
           Fehler = 0;
       end       
   end % if (out(1) ...
else % if (count == 26) ...
    Fehler = Fehler + 1;
end % if (count == 26) ...