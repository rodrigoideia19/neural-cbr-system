%% TAREFA 3.3 b) - COMPARAÇÃO INDEPENDENTE: DATA vs DATA_TEST
fprintf('A executar treinos independentes com plotconfusion...\n\n');

if ~isfile('resultados_testes.mat') || ~isfile('dataset_teste_preparado.mat')
    error('ERRO: Faltam os ficheiros .mat gerados nos passos anteriores.');
end

load('resultados_testes.mat', 'resultados', 'data');
load('dataset_teste_preparado.mat', 'data_test');

inputs_data = table2array(data(:, 1:14))';
targets_data = zeros(3, height(data));
for i = 1:height(data)
    targets_data(data.class_cat(i), i) = 1;
end

inputs_test = table2array(data_test(:, 1:14))';
targets_test = zeros(3, height(data_test));
for i = 1:height(data_test)
    targets_test(data_test.class_cat(i), i) = 1;
end

% Isolar Redes (As 3 melhores e as 3 piores)
todas_accT = [resultados.accT];
[~, idx_ord] = sort(todas_accT, 'descend');

% O 1:3 vai buscar o topo. O end-2:end vai buscar os últimos três.
indices_alvo = [idx_ord(1:3), idx_ord(end-2:end)];

etiquetas = {'1ª Melhor', '2ª Melhor', '3ª Melhor', '3ª Pior', '2ª Pior', '1ª Pior'};

for k = 1:length(indices_alvo)
    conf = resultados(indices_alvo(k));
    rede_base = conf.rede;
    
    % IMPRIME A ETIQUETA E O NOME DA REDE
    fprintf('\n>>> [%s] A treinar a rede: %s\n', etiquetas{k}, conf.nome);
    
    % TREINO NO DATA
    rn_data = init(rede_base); 
    rn_data.trainParam.showWindow = false;

    [rn_data_treinada, tr_data] = train(rn_data, inputs_data, targets_data);
    out_data = sim(rn_data_treinada, inputs_data);

    %Mostrar dados do DATA
    [~, previsao_data] = max(out_data);
    [~, real_data] = max(targets_data);
    acc_global_data = (sum(previsao_data == real_data) / length(real_data)) * 100;
    
    %Dados de Teste (tr_data para filtrar os dados de teste)
    prev_teste_data = previsao_data(tr_data.testInd);
    real_teste_data = real_data(tr_data.testInd);
    acc_teste_data = (sum(prev_teste_data == real_teste_data) / length(real_teste_data)) * 100;
    
    fprintf('-> [NÃO NORM] Precisão Global: %6.2f%% | Precisão Teste: %6.2f%%\n', acc_global_data, acc_teste_data);
    
    % TREINO NO DATA_TEST
    rn_test = init(rede_base); 
    rn_test.trainParam.showWindow = false;

    [rn_test_treinado, tr_test] = train(rn_test, inputs_test, targets_test);
    out_test = sim(rn_test_treinado, inputs_test);

    %Mostrar dados do DATA_TEST
    [~, previsao_test] = max(out_test);
    [~, real_test] = max(targets_test);

    acc_global_test = (sum(previsao_test == real_test) / length(real_test)) * 100;

    % Precisão de Teste (Usar tr_test.testInd para filtrar)
    prev_teste_norm = previsao_test(tr_test.testInd);
    real_teste_norm = real_test(tr_test.testInd);
    acc_teste_test = (sum(prev_teste_norm == real_teste_norm) / length(real_teste_norm)) * 100;


    fprintf('  -> [NORMALIZ] Precisão Global: %6.2f%% | Precisão Teste: %6.2f%%\n', acc_global_test, acc_teste_test);
    
    % Criar o título exato que vai aparecer por cima de cada matriz no gráfico
    nome_nao_norm = sprintf('%s n_norm (%s)', etiquetas{k}, conf.nome);
    nome_norm = sprintf('%s norm (%s)', etiquetas{k}, conf.nome);
    
    figure('Name', sprintf('%s - %s', etiquetas{k}, conf.nome), 'NumberTitle', 'off');
    
    % Desenhar as duas matrizes lado a lado na nova janela
    plotconfusion(targets_data, out_data, nome_nao_norm, targets_test, out_test, nome_norm);
end

fprintf('\nMatrizes de confusão geradas com sucesso!\n');