function [] = cbr_teste()
    clearvars; clc;
    fprintf('=== CBR SYSTEM EVALUATION (NORMALIZED DATA) ===\n\n');
    
    %% LOAD DATA
    if exist('dataset_normal_normalizado.mat', 'file')
        load('dataset_normal_normalizado.mat', 'data');
        dataset_normal_normalizado = data;
    else
        error('Erro: dataset_normal_normalizado.mat não encontrado. Corre o tratamento_dataset.m primeiro.');
    end
   
    tabela_normal_original = readtable('dataset_TP.csv');
    tabela_teste_original= readtable('dataset_TP_test.csv');
    
    %% PREPARAÇÃO DOS DADOS (Categóricos -> Numéricos)
    lista_tabelas_para_processar = {tabela_normal_original, tabela_teste_original};
    
    for i = 1:2
        tabela_atual = lista_tabelas_para_processar{i};
        
        coluna_maintenanceLevel_temp = zeros(height(tabela_atual), 1);
        coluna_maintenanceLevel_temp(strcmpi(tabela_atual.maintenance_level, 'Low')) = 0;
        coluna_maintenanceLevel_temp(strcmpi(tabela_atual.maintenance_level, 'Medium')) = 0.5;
        coluna_maintenanceLevel_temp(strcmpi(tabela_atual.maintenance_level, 'High')) = 1;
        tabela_atual.maintenance_level = coluna_maintenanceLevel_temp;
        
        coluna_operatingMode_temp = zeros(height(tabela_atual), 1);
        coluna_operatingMode_temp(strcmpi(tabela_atual.operating_mode, 'Idle')) = 0;
        coluna_operatingMode_temp(strcmpi(tabela_atual.operating_mode, 'Normal')) = 0.5;
        coluna_operatingMode_temp(strcmpi(tabela_atual.operating_mode, 'Overload')) = 1;
        tabela_atual.operating_mode = coluna_operatingMode_temp;
        
        tabela_atual.cooling_type = double(strcmpi(tabela_atual.cooling_type, 'Oil'));
        tabela_atual.sensor_status = double(strcmpi(tabela_atual.sensor_status, 'OK'));
        
        target_numerico = zeros(height(tabela_atual), 1);
        target_limpo = strrep(tabela_atual.class_cat, ' ', '');
        target_numerico(strcmpi(target_limpo, 'Normal')) = 1;
        target_numerico(strcmpi(target_limpo, 'ElectricalFailure')) = 2;
        target_numerico(strcmpi(target_limpo, 'MechanicalFailure')) = 3;
        tabela_atual.class_cat = target_numerico;
        
        lista_tabelas_para_processar{i} = tabela_atual;
    end
    
    % Recuperar as tabelas agora que os textos são números
    dataset_normal_norm = lista_tabelas_para_processar{1};
    dataset_teste_norm = lista_tabelas_para_processar{2};
    
    % Normalização Min-Max do Teste 
    for indice_coluna_a_normalizar = 1:14
        Vmax = max(dataset_normal_norm{:,indice_coluna_a_normalizar}, [], 'omitnan');
        if Vmax > 0
            dataset_teste_norm{:,indice_coluna_a_normalizar} = dataset_teste_norm{:,indice_coluna_a_normalizar} / Vmax;
        end
    end
    
    %% DEFINIR CONFIGURAÇÕES DE PESOS
    configuracoes_pesos_teste = {
    '1. Pesos Iguais (Baseline): [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]',                ones(1, 14);
    '2. Pesos do Guiao (Conhecimento Perito): [3, 3, 2, 2, 3, 2, 1, 1, 1, 2, 1, 1, 1, 1]',   [3, 3, 2, 2, 3, 2, 1, 1, 1, 2, 1, 1, 1, 1];
    '3. Foco Extremo na Fisica do Motor: [5, 5, 1, 1, 5, 5, 1, 1, 1, 5, 0, 0, 0, 0]',        [5, 5, 1, 1, 5, 5, 1, 1, 1, 5, 0, 0, 0, 0];
    '4. Foco Exclusivo nos Alarmes: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10]',             [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10];
    '5. Teste de Stress (Sem Sensores Chave): [1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 5, 5, 5, 5]',   [1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 5, 5, 5, 5];
    '6. Degradação (Apenas Ruído): [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]',              [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]
};

    %% EVALUATION (CBR RETRIEVE)
    matriz_pura_dataset_normal_normalizado = table2array(dataset_normal_normalizado(:, 1:14));
    matriz_pura_dataset_teste_normalizado = table2array(dataset_teste_norm(:, 1:14));
    
    fprintf('A testar %d configuracoes de pesos no Dataset Normalizado...\n\n', size(configuracoes_pesos_teste, 1));
    
    for indice_configPesos_a_testar = 1:size(configuracoes_pesos_teste, 1)
        nome_configuracao = configuracoes_pesos_teste{indice_configPesos_a_testar, 1};
        pesos_atuais = configuracoes_pesos_teste{indice_configPesos_a_testar, 2};
        total_acertos = 0;
        
        for indice_caso_a_diagnosticar = 1:height(dataset_teste_norm)
            % Cálculo da Distância Linear Ponderada
            diferencas_absolutas = abs(matriz_pura_dataset_normal_normalizado - matriz_pura_dataset_teste_normalizado(indice_caso_a_diagnosticar,:)) .* pesos_atuais;
            distancias_totais = sum(diferencas_absolutas, 2);
            
            [~, indice_caso_mais_proximo] = min(distancias_totais);
            
            % Verificar se a classe prevista bate certo com a real
            if dataset_normal_normalizado.class_cat(indice_caso_mais_proximo) == dataset_teste_norm.class_cat(indice_caso_a_diagnosticar)
                total_acertos = total_acertos + 1;
            end
        end
        
        precisao = (total_acertos / height(dataset_teste_norm)) * 100;
        fprintf('%-85s -> Precisão: %6.2f%% (%d/%d corretos)\n', nome_configuracao, precisao, total_acertos, height(dataset_teste_norm));
    end
    fprintf('\n=== TESTS COMPLETED ===\n');
end