function ea_psi6032_set_remote( remote_status,serial_port, EA_Addr )
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$



TX_Befehl(1:26) = 0;


Kommando = hex2dec('20');   % 20 Remote control on/off
                            % 21 output stat on/off
                            % 22 Setting the maximum output voltage (0x22)
                            

TX_Befehl(1) = hex2dec('aa');      % Startbyte
TX_Befehl(2) = EA_Addr;            % Adresse des Geräts
TX_Befehl(3) = Kommando;           % Kommando
TX_Befehl(4) = remote_status;       % Parameter
TX_Befehl(5:25) = 0;               % Füllbytes / Systemreserve
TX_Befehl(26) = mod(sum(TX_Befehl(1:25)),256); % Checksum
% disp 'set_remote'
% Befehl = dec2hex(TX_Befehl)'

%fprintf(s,char(TX_Befehl))

fwrite(serial_port,TX_Befehl)
