function [casosTreinoNormalizados] = retain(casosTreinoNormalizados, novo_caso)
    
    fprintf('Add the new case to the library? (y/n)\n');
    option = input('Option: ', 's');
    
    if option == 'y' || option == 'Y'
        casosTreinoNormalizados = [casosTreinoNormalizados; novo_caso];
        
        data = casosTreinoNormalizados;
        save('dataset_preparado.mat', 'data');
        
        fprintf('New case successfully added to the Case Library.\n');
    else
        fprintf('New case was not added.\n');
    end
    
end