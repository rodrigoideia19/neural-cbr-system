%% Load Dataset
data = readtable('dataset_TP.csv');

%% PREPARAÇÃO DOS DADOS (Categóricos -> Numéricos)
idx_Low = strcmp(data.maintenance_level, 'Low');
idx_Medium = strcmp(data.maintenance_level, 'Medium');
data_maintenance = zeros(height(data), 1);
data_maintenance(idx_Low) = 0;
data_maintenance(idx_Medium) = 0.5;
data_maintenance(~idx_Low & ~idx_Medium) = 1;
data.maintenance_level = data_maintenance;

idx_Idle = strcmp(data.operating_mode, 'Idle');
idx_Normal = strcmp(data.operating_mode, 'Normal');
data_opmode = zeros(height(data), 1);
data_opmode(idx_Idle) = 0;
data_opmode(idx_Normal) = 0.5;
data_opmode(~idx_Idle & ~idx_Normal) = 1;
data.operating_mode = data_opmode;

data.cooling_type = double(~strcmp(data.cooling_type, 'Air'));

data.sensor_status = double(strcmp(data.sensor_status, 'OK'));

%% Tratamento de Valores em Falta (Inputs)
cols_mediana = {'temperature', 'vibration', 'rotation_speed', 'voltage', 'current', 'pressure', 'torque','noise_level'};
cols_media = {'efficiency', 'load_val'};
cols_moda = {'maintenance_level', 'operating_mode', 'cooling_type', 'sensor_status'};

for c = 1:length(cols_mediana)
    col = cols_mediana{c};
    data.(col)(isnan(data.(col))) = median(data.(col), 'omitnan');
end

for c = 1:length(cols_media)
    col = cols_media{c};
    data.(col)(isnan(data.(col))) = mean(data.(col), 'omitnan');
end

for c = 1:length(cols_moda)
    col = cols_moda{c};
    data.(col)(isnan(data.(col))) = mode(data.(col));
end

%% Normalização [Fórmula V/Vmax]
input_features = data.Properties.VariableNames(1:14);
for c = 1:length(input_features)
    col = input_features{c};
    v_max = max(data.(col));
    
    if v_max > 0
        
        data.(col) = data.(col) / v_max;
    end
end

%% Conversão e Imputação do Target (CBR Retrieve)
target_col = NaN(height(data), 1); 
target_col(strcmpi(strtrim(data.class_cat), 'Normal')) = 1;
target_col(strcmpi(strtrim(data.class_cat), 'ElectricalFailure')) = 2;
target_col(strcmpi(strtrim(data.class_cat), 'MechanicalFailure')) = 3;
data.class_cat = target_col;

indexesEmFalta = find(isnan(data.class_cat));
indexesConhecidos = find(~isnan(data.class_cat));

config_pesos = [3, 3, 2, 2, 3, 2, 1, 1, 1, 2, 1, 1, 1, 1]; 
feature_matrix = table2array(data(:, 1:14));

fprintf('\nStarting missing target imputation (Retrieve phase)...\n\n');
for m = 1:length(indexesEmFalta)
    idxEmFalta = indexesEmFalta(m);
    casoEmFalta = feature_matrix(idxEmFalta, :);
    
    distancia_minima = inf;
    diagnostico_sugerido = -1;
    
    for k = 1:length(indexesConhecidos)
        idxConhecido = indexesConhecidos(k);
        casoConhecido = feature_matrix(idxConhecido, :);
        
        distancias = abs(casoEmFalta - casoConhecido);
        distancia_global = sum(distancias .* config_pesos) / sum(config_pesos);
        
        if distancia_global < distancia_minima
            distancia_minima = distancia_global;
            diagnostico_sugerido = data.class_cat(idxConhecido);
        end
    end
    data.class_cat(idxEmFalta) = diagnostico_sugerido; 
end
fprintf('Imputation completed...\n\n');

%% Verificação Finar e Save
final_nans = sum(isnan(data.class_cat));
fprintf('Missing values after treatment: %d\n\n', final_nans);

save('dataset_normal_normalizado.mat', 'data');
fprintf('Dataset successfully saved to dataset_normal_normalizado.mat.\n');