function ea_psi6032_set_max_current( current ,serial_port, EA_Addr )
%ea_psi6032_set_max_current( current ,serial_port, EA_Addr )
%interne Funktion, stellt die Strombegrenzung ein
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$

TX_Befehl(1:26) = 0;
current = fix(current * 1000);
                            % Übertragen werden die Milliampere
                            % nur ganzahlige Miliampere können übertragen
                            % werden


Kommando = hex2dec('24');   % 20 Remote control on/off
                            % 21 output stat on/off
                            % 22 Setting the maximum output voltage (0x22)
                            % 23 Setting the output voltage (0x23)
                            % 24 Setting the output current (0x24)
                            % 25 Setting the communication adress (0x25)
                            

TX_Befehl(1) = hex2dec('aa');      % Startbyte
TX_Befehl(2) = EA_Addr;            % Adresse des Geräts
TX_Befehl(3) = Kommando;           % Kommando
TX_Befehl(4) = mod(current,256);   % voltage low byte
  current = (current - TX_Befehl(4))/256;
TX_Befehl(5) = mod(current,256);
TX_Befehl(6:25) = 0;               % Füllbytes / Systemreserve
TX_Befehl(26) = mod(sum(TX_Befehl(1:25)),256); % Checksum

%disp 'set_max_current'
%TX_Befehl
% Befehl = dec2hex(TX_Befehl)'

%fprintf(s,char(TX_Befehl))

fwrite(serial_port,TX_Befehl)
