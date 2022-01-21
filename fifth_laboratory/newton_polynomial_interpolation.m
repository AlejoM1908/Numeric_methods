function newton_polynomial_interpolation()
    while 1
        try
            % Request user data
            func = request_function();

            % Exit program
            decision= get_exit();
            if decision
                break
            end
        catch excep
            % Display error message
            clear_console()

            if strcmp(excep.identifier, 'MATLAB:Bisection')
                disp(excep.message)
            else
                disp('Ocurrio algun error inesperado')
            end
        end
    end
end

% The function continous_function is used to return the continous function
% where the bolzano bisection will be applied on
% @Param x is the value to evaluate in the function
% Return the continous function
function value= request_function()
    % Ask for the function and parcing it from string to function
    value= str2func(['@(x)' input('Ingrese la función: ', 's')]);
end

% The function get_exit is used to close the program execution
% return a boolean for a flag in the program
function value= get_exit()
    option= input('La ejecución finalizo correctamente, desea salir? (y/n): ', 's');

    if strcmp(option, "y")
        value= 1;
    else
        value= 0;
    end
end

% The function clear_console is usde to clear the console
function clear_console()
    clc
end
