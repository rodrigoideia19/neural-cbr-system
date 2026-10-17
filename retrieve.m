function [array_indices_casos_passados, similaridades_exatas_casos_passados] = retrieve(casosTreinoNormalizados, novo_caso, similarity_threshold)
    array_indices_casos_passados = [];
    similaridades_exatas_casos_passados = [];
    
    config_pesos = [3, 3, 2, 2, 3, 2, 1, 1, 1, 2, 1, 1, 1, 1];
    
    matriz_casos = table2array(casosTreinoNormalizados(:, 1:14));
    vetor_novo = table2array(novo_caso(:, 1:14));
    
    for i = 1:size(matriz_casos, 1)
        
        distancias = zeros(1, 14);
        
        for j = 1:14
            distancias(1, j) = abs(vetor_novo(j) - matriz_casos(i, j)) * config_pesos(j);
        end
        
        final_similarity = 1 - (sum(distancias) / sum(config_pesos));
        
        if final_similarity >= similarity_threshold
            array_indices_casos_passados = [array_indices_casos_passados i];
            similaridades_exatas_casos_passados = [similaridades_exatas_casos_passados final_similarity];
        end
    end
    fprintf('Found %d cases similar to the new case.\n', length(array_indices_casos_passados));
end