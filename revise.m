function [novo_caso] = revise(novo_caso, nova_temperatura)
    fprintf('Update your engine temperature with the new estimated value? (y/n)\n');
    option = input('Option: ', 's');
    
    if strcmpi(strtrim(option), 'y')
        novo_caso.temperature = nova_temperatura;
        fprintf('Temperature updated successfully.\n');
    else
        fprintf('Original temperature maintained.\n');
    end
end