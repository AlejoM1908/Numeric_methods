%The function lagrange_interpolation is the main function
function lagrange_interpolation()
    while 1
        try
            % Request user data
            
            % Exit program
            decision= get_exit();
            if decision
                break
            end
        catch excep
            % Display error message
            clear_console()

            if strcmp(excep.identifier, 'MATLAB:Triangular')
                disp(excep.message)
            else
                disp('Ocurrio algun error inesperado')
                disp(excep.message)
            end
        end
    end
end

% The function clear_console is used to clear the console
function clear_console()
    clc
end

% The function get_exit is used to close the program execution
function value= get_exit()
    option= input('La ejecución finalizo correctamente, desea salir? (y/n): ', 's');

    if strcmp(option, "y")
        value= 1;
    else
        value= 0;
    end
end
