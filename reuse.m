function [nova_temperatura] = reuse(casosTreinoNormalizados, novo_caso)
    % Neural Network Feedforward
    matriz_VibRotVol_transposta = table2array(casosTreinoNormalizados(:, 2:4))'; 
    array_temperature_transposto = casosTreinoNormalizados.temperature';          
    
    rede_neuronal = feedforwardnet(10);
    rede_neuronal.trainParam.showWindow = true; 
    rede_neuronal_treinada = train(rede_neuronal, matriz_VibRotVol_transposta, array_temperature_transposto);
    
    array_novo_VibRotVol_transposto = [novo_caso.vibration, novo_caso.rotation_speed, novo_caso.voltage]';
    
    nova_temperatura = rede_neuronal_treinada(array_novo_VibRotVol_transposto);
    
    fprintf(['Based on the attributes Vibration, Rotation Speed and Voltage of the case base,\n', ...
             'the estimated temperature for the new case is %.4f, instead of %.4f.'], ...
             nova_temperatura, novo_caso.temperature);
end