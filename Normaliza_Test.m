%% Script Definitivo de Preparação do data_test ( V / Vmax)
clc;
fprintf('A iniciar a preparação completa do dataset de teste...\n\n');

% Leitura dos ficheiros
if ~isfile('dataset_TP_test.csv') || ~isfile('dataset_TP.csv')
    error('ERRO: Faltam os ficheiros CSV na pasta atual.');
end
data_test = readtable('dataset_TP_test.csv');
data_train = readtable('dataset_TP.csv'); 

% Mapeamento rigoroso das variáveis categóricas
fprintf('-> A aplicar o mapeamento exato das categorias...\n');

% Manutenção (Low=0, Medium=0.5, High=1)
t_maint = zeros(height(data_test), 1);
t_maint(strcmp(data_test.maintenance_level, 'Medium')) = 0.5;
t_maint(strcmp(data_test.maintenance_level, 'High')) = 1;
data_test.maintenance_level = t_maint;

% Modo Operação (Idle=0, Normal=0.5, Overload=1)
t_op = zeros(height(data_test), 1);
t_op(strcmp(data_test.operating_mode, 'Normal')) = 0.5;
t_op(strcmp(data_test.operating_mode, 'Overload')) = 1;
data_test.operating_mode = t_op;

% Cooling (Air=0, Oil=1)
t_cool = zeros(height(data_test), 1);
t_cool(strcmp(data_test.cooling_type, 'Oil')) = 1;
data_test.cooling_type = t_cool;


t_sens = zeros(height(data_test), 1);
t_sens(strcmp(data_test.sensor_status, 'OK')) = 1;
data_test.sensor_status = t_sens;

% Target (Normal=1, Electrical=2, Mechanical=3)
t_targ = zeros(height(data_test), 1);
t_targ(strcmp(data_test.class_cat, 'Normal')) = 1;
t_targ(strcmp(data_test.class_cat, 'ElectricalFailure')) = 2;
t_targ(strcmp(data_test.class_cat, 'MechanicalFailure')) = 3;
data_test.class_cat = t_targ;

% 3. Normalização V / Vmax 
fprintf('-> A aplicar normalização (Valor / Vmax do Treino)...\n');
for c = 1:10
    v_max = max(data_train{:, c}, [], 'omitnan'); % Descobre o máximo do treino
    if v_max > 0
        data_test{:, c} = data_test{:, c} / v_max; % Divide o teste por esse máximo
    end
end

fprintf('\n[SUCESSO] O data_test está matematicamente alinhado com o Treino!\n');
save('dataset_teste_preparado.mat', 'data_test');