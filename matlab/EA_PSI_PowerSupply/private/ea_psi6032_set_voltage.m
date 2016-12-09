function ea_psi6032_set_voltage( voltage ,serial_port, EA_Addr )
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
% Ersteller: ESchreiter@hszg.de
% Datum:     $date$
% Version:   $id$



TX_Befehl(1:26) = 0;
voltage = fix(voltage * 1000);
                            % Übertragen werden die Millivolt,
                            % nur Ganzahlige Millivolt können übertragen
                            % werden


Kommando = hex2dec('23');   % 20 Remote control on/off
                            % 21 output stat on/off
                            % 22 Setting the maximum output voltage (0x22)
                            % 23 Setting the output voltage (0x23)
                            

TX_Befehl(1) = hex2dec('aa');      % Startbyte
TX_Befehl(2) = EA_Addr;            % Adresse des Geräts
TX_Befehl(3) = Kommando;           % Kommando
TX_Befehl(4) = mod(voltage,256);   % voltage low byte
  voltage = (voltage - TX_Befehl(4))/256;
TX_Befehl(5) = mod(voltage,256);
  voltage = (voltage - TX_Befehl(5))/256;
TX_Befehl(6) = mod(voltage,256);
  voltage = (voltage - TX_Befehl(6))/256;
TX_Befehl(7) = mod(voltage,256);
TX_Befehl(8:25) = 0;               % Füllbytes / Systemreserve
TX_Befehl(26) = mod(sum(TX_Befehl(1:25)),256); % Checksum

% disp 'set_voltage'
% TX_Befehl
% Befehl = dec2hex(TX_Befehl)'



fwrite(serial_port,TX_Befehl)