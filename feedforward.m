function [] = feedforward()
    clc;
    fprintf('A iniciar testes estruturados...\n\n');

    % 1. Carregar os dados de Treino
    if exist('dataset_normal_normalizado.mat', 'file')
        load('dataset_normal_normalizado.mat', 'data');
    else
        error('Erro: dataset_preparado.mat não encontrado.');
    end

    resultados = [];

    fprintf('A treinar as redes (isto pode demorar uns segundos)...\n');
    
    % Configuração por Defeito (10 neurónios, tansig, purelin, trainlm)
    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'tansig', 'purelin', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Defeito [10]', 'accG', accG, 'accT', accT, 'rede', rede)];

    % Topologia
    [accG, accT, rede] = treinarRede(data, [5 5], 'trainlm', 'tansig', 'purelin', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Topologia [5 5]', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, [10 10], 'trainlm', 'tansig', 'purelin', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Topologia [10 10]', 'accG', accG, 'accT', accT, 'rede', rede)];
    
    [accG, accT, rede] = treinarRede(data, 25 , 'trainlm', 'tansig', 'purelin', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Topologia [25]', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, [8 4], 'trainlm', 'tansig', 'purelin', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Topologia [8 4]', 'accG', accG, 'accT', accT, 'rede', rede)];

    % Função treino
    [accG, accT, rede] = treinarRede(data, 10, 'traingd', 'tansig', 'purelin', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Função traingd', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, 10, 'trainscg', 'tansig', 'purelin', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Função trainscg', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, 10, 'trainbr', 'tansig', 'purelin', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Função trainbr', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, 10, 'traingda', 'tansig', 'purelin', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Função traingda', 'accG', accG, 'accT', accT, 'rede', rede)];
    
    % Ativação
    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'logsig', 'purelin', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Ativação logsig-purelin', 'accG', accG, 'accT', accT, 'rede', rede)];
    
    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'tansig', 'purelin', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Ativação tansig-purelin', 'accG', accG, 'accT', accT, 'rede', rede)];
    
    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'tansig', 'tansig', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Ativação tansig-tansig', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'tansig', 'softmax', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Ativação tansig-softmax', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'logsig', 'logsig', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Ativação logsig-logsig', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'logsig', 'softmax', [0.7 0.15 0.15]);
    resultados = [resultados; struct('nome', 'Ativação logsig-softmax', 'accG', accG, 'accT', accT, 'rede', rede)];

    % Divisão de exemplos
    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'tansig', 'purelin', [0.8 0.1 0.1]);
    resultados = [resultados; struct('nome', 'Defeito [0.8 0.1 0.1]', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'tansig', 'purelin', [0.9 0.05 0.05]);
    resultados = [resultados; struct('nome', 'Defeito [0.9 0.05 0.05]', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'tansig', 'purelin', [0.5 0.25 0.25]);
    resultados = [resultados; struct('nome', 'Defeito [0.5 0.25 0.25]', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'tansig', 'purelin', [0.6 0.2 0.2]);
    resultados = [resultados; struct('nome', 'Defeito [0.6 0.2 0.2]', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'tansig', 'purelin', [0.7 0.2 0.1]);
    resultados = [resultados; struct('nome', 'Defeito [0.7 0.2 0.1]', 'accG', accG, 'accT', accT, 'rede', rede)];

    [accG, accT, rede] = treinarRede(data, 10, 'trainlm', 'tansig', 'purelin', [0.7 0.1 0.2]);
    resultados = [resultados; struct('nome', 'Defeito [0.7 0.1 0.2]', 'accG', accG, 'accT', accT, 'rede', rede)];
    %% --- RESULTADOS FINAIS ---
    fprintf('\n=========================================================\n');
    fprintf('%-30s | %-10s | %-10s\n', 'CONFIGURAÇÃO', 'ACC GLOBAL', 'ACC TESTE');
    fprintf('---------------------------------------------------------\n');
    for i = 1:length(resultados)
        fprintf('%-30s | %6.2f%%   | %6.2f%%\n', resultados(i).nome, resultados(i).accG, resultados(i).accT);
    end
    fprintf('=========================================================\n\n');

    % Ordenar e extrair o Pódio
    todas_accT = [resultados.accT];
    [~, indices_podio] = sort(todas_accT, 'descend');

    fprintf('--- O PÓDIO (As 3 Melhores) ---\n');
    for i = 1:min(3, length(indices_podio))
        idx = indices_podio(i);
        fprintf('%dº Lugar: %s (Teste: %.2f%%)\n', i, resultados(idx).nome, resultados(idx).accT);
    end

    save('resultados_testes.mat', 'resultados', 'data');
end


function [media_acc_global, media_acc_teste, melhor_rede] = treinarRede(dados, topologia, f_treino, f_ativ_esc, f_ativ_sai, racios)
    
    inputs = table2array(dados(:, 1:14))';
    
    t_num = dados.class_cat;
    targets = zeros(3, length(t_num));
    for i = 1:length(t_num)
        targets(t_num(i), i) = 1;
    end
    
    acc_global_arr = zeros(1, 10);
    acc_teste_arr = zeros(1, 10);
    melhor_acc = 0; melhor_rede = [];
    
    for rep = 1:10
        net = feedforwardnet(topologia);
        net.trainFcn = f_treino;
        
        for j = 1:(net.numLayers - 1)
            net.layers{j}.transferFcn = f_ativ_esc;
        end
        net.layers{end}.transferFcn = f_ativ_sai;
        
        net.divideFcn = 'dividerand';
        net.divideParam.trainRatio = racios(1);
        net.divideParam.valRatio = racios(2);
        net.divideParam.testRatio = racios(3);
        net.trainParam.showWindow = false;
        
        [net_treinada, tr] = train(net, inputs, targets);
        
        out = sim(net_treinada, inputs);
        
        r = 0;
        for i = 1:size(out, 2)
            [~, b] = max(out(:, i));
            [~, d] = max(targets(:, i));
            if b == d
                r = r + 1;
            end
        end
        acc_global_arr(rep) = (r / size(out, 2)) * 100;
        
        if ~isempty(tr.testInd)
            TInput = inputs(:, tr.testInd);
            TTargets = targets(:, tr.testInd);
            out_test = sim(net_treinada, TInput);
            
            r_teste = 0;
            for i = 1:size(tr.testInd, 2)
                [~, b] = max(out_test(:, i));
                [~, d] = max(TTargets(:, i));
                if b == d
                    r_teste = r_teste + 1;
                end
            end
            acc_teste_arr(rep) = (r_teste / size(tr.testInd, 2)) * 100;
        end
        
        if acc_teste_arr(rep) >= melhor_acc
            melhor_acc = acc_teste_arr(rep);
            melhor_rede = net_treinada;
        end
    end
    
    media_acc_global = mean(acc_global_arr);
    media_acc_teste = mean(acc_teste_arr);
end