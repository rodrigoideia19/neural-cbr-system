function [] = cbr()
    clc;
    similarity_threshold = 0.90; 
    
    load('dataset_normal_normalizado.mat', 'data'); 
    casosTreinoNormalizados = data;
    
    dados_originais = readtable('dataset_TP.csv'); 
    
    % NOVO CASO MANUAL (Valores Brutos)
    novo_caso_array =   [78.21, 1.29, 1442.02, 222.44, 18.55, 5.22, 73.69, 0.78, 55.6, 106.99, 0.5, 1, 0, 1];
    
    nomes_colunas = {'temperature', 'vibration', 'rotation_speed', 'voltage', ...
                 'current', 'pressure', 'noise_level', 'efficiency', ...
                 'load_val', 'torque', 'maintenance_level', 'operating_mode', ...
                 'cooling_type', 'sensor_status'};
             
    novo_caso = array2table(novo_caso_array, 'VariableNames', nomes_colunas);
    
    % Target: Falha Mecânica (Classe 3)
    novo_caso.class_cat = 3; 
    
    fprintf('=== NOVO CASO INSERIDO MANUALMENTE ===\n');
    fprintf('Cenario: Motor com desgaste severo nos rolamentos.\n\n');
    
    % NORMALIZAÇÃO DO CASO NOVO 
    cols_numericas = {'temperature', 'vibration', 'rotation_speed', 'voltage', ...
                      'current', 'pressure', 'noise_level', 'efficiency', ...
                      'load_val', 'torque'};
                  
    for indice_atributo = 1:length(cols_numericas)
        nome_coluna_a_tratar = cols_numericas{indice_atributo};
        Vmax = max(dados_originais.(nome_coluna_a_tratar), [], 'omitnan');
        
        if Vmax > 0
            novo_caso.(nome_coluna_a_tratar) = novo_caso.(nome_coluna_a_tratar) / Vmax;
        end
    end
    
    %% RETRIEVE
    fprintf('\nStarting retrieve phase...\n\n');
    [array_indices_casos_passados, similaridades_exatas_casos_passados] = retrieve(casosTreinoNormalizados, novo_caso, similarity_threshold);
    
    if isempty(array_indices_casos_passados)
        fprintf('Nenhum caso encontrado.\n');
        return;
    end
    
    tabela_casos_recuperados = casosTreinoNormalizados(array_indices_casos_passados, :);
    tabela_casos_recuperados.Similarity = similaridades_exatas_casos_passados'; 
    
    fprintf('\nRetrieve phase completed...\n\n');
    disp(tabela_casos_recuperados(:, [1:4, 15, 16]));
    
    %% REUSE 
    fprintf('\nStarting reuse phase...\n\n');
    nova_temperatura = reuse(casosTreinoNormalizados, novo_caso);
    fprintf('\n\nReuse phase completed...\n');
    
    %% REVISE
    fprintf('\nStarting revise phase...\n\n');
    novo_caso = revise(novo_caso, nova_temperatura);
    fprintf('\nRevise phase completed...\n');
    
    %% RETAIN
    fprintf('\nStarting retain phase...\n\n');
    retain(casosTreinoNormalizados, novo_caso);
    fprintf('\nRetain phase completed...\n\n');
end