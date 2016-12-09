function ea_psi6032_set_output( output_status,s, EA_Addr )
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$



TX_Befehl(1:26) = 0;


Kommando = hex2dec('21');   % 20 Remote control on/off
                            % 21 output stat on/off
                            % 22 Setting the maximum output voltage (0x22)
                            % 23 Setting the output voltage (0x23)
                            % 24 Setting the output current (0x24)
                            % 25 Setting the communication adress (0x25)
                            

TX_Befehl(1) = hex2dec('aa');      % Startbyte
TX_Befehl(2) = EA_Addr;            % Adresse des Geräts
TX_Befehl(3) = Kommando;           % Kommando
TX_Befehl(4) = output_status;      % Parameter
TX_Befehl(5:25) = 0;               % Füllbytes / Systemreserve
TX_Befehl(26) = mod(sum(TX_Befehl(1:25)),256); % Checksum

% disp 'set_output'
% Befehl = dec2hex(TX_Befehl)'

%fprintf(s,char(TX_Befehl))

fwrite(s,TX_Befehl)




