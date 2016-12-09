function ea_psi6032_set_comm_addr( neue_EA_Addr ,serial_port, EA_Addr )
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$



TX_Befehl(1:26) = 0;


Kommando = hex2dec('25');   % 20 Remote control on/off
                            % 21 output stat on/off
                            % 22 Setting the maximum output voltage (0x22)
                            % 23 Setting the output voltage (0x23)
                            % 24 Setting the output current (0x24)
                            % 25 Setting the communication adress (0x25)
                            

TX_Befehl(1) = hex2dec('aa');      % Startbyte
TX_Befehl(2) = EA_Addr;            % alte (aktuelle) Adresse des Geräts
TX_Befehl(3) = Kommando;           % Kommando
TX_Befehl(4) = neue_EA_Addr;       % neue Adresse des Geräts
TX_Befehl(5:25) = 0;               % Füllbytes / Systemreserve
TX_Befehl(26) = mod(sum(TX_Befehl(1:25)),256); % Checksum
disp 'set_comm_addr'

TX_Befehl
Befehl = dec2hex(TX_Befehl)'

fwrite(serial_port,TX_Befehl)

