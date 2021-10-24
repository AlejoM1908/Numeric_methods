% The function bolzano_bisection is the main function
function bolzano_bisection()
    while 1
        try
            % Request function and limits
            func = request_function();
            a = input('Ingrese el limite izquierdo: ');
            b = input('Ingrese el limite derecho: ');

            % Check if the limits evaluated has opposite signs
            if opposite_signs(func(a), func(b))
                % Start iterating
                bisection(a,b,func,get_iterator())
            else
                throw(MException('Bisection:',...
                    'Limits not opposite when evaluated'))
            end
        catch e
            % Display error message
            clear_console()
            if strcmp(e.identifier, 'Bisection:')
                disp('La función ingresada no tiene limites con valores opuestos')
            else
                disp('Ocurrio algun error')
            end
        end
    end
end

% The function opposite_signs is used to detect if the given numbers has 
% different signs
% @Param a is the first number
% @Param b is the second number
% Return true if the numbers has opposite signs, false on the contrary
function value = opposite_signs(a,b)
    if a<0
        value = b>=0;
    else
        value = b<0;
    end
end

% The function continous_function is used to return the continous function
% where the bolzano bisection will be applied on
% @Param x is the value to evaluate in the function
% Return the continous function
function value = request_function()
    % Ask for the function and parcing it from string to function
    value = str2func(['@(x)' input('Ingrese la función: ', 's')]);
end

% The function clear_console is usde to clear the console
function clear_console()
    clc
end

% The function get_iterator is used to ask the user for the number of
% iterations or return the default value
% Return the number of iterations
function value = get_iterator()
    clear_console()

    % Get user selection
    option = input('Desea definir las iteraciones? (y/n): ','s');

    if strcmp(option, "y")
        % Get iteration number from user
        value = input('Ingrese el número de iteraciones: ');
    else
        % Return the default value
        value = 10;
    end
end

% The function get_median is used to calculate the median between the to
% given numbers
% @Param a is the first number
% @Param b is the second number
% Return the median between the two numbers
function value = get_median(a,b)
    value = (a+b)/2;
end

% The function bisection is a recursive function that the closest value
% where the function value is 0
% @Param a is the left limit
% @Param b is the right limit
% @Param func is the continous function
% @Param iterator is the amount of times to operate, default 10
function bisection(a,b,func,iterator)
    % Check if the iterator ends
    if iterator <= 0
        disp(round(get_median(a,b),4))
        return
    end
    
    % Check if the iteration suffice the answer
    c = get_median(a,b);
    if func(c) < 0.00001 && func(c)> -0.00001
        disp(round(c,4))
        return
    end
    
    % Check between interval [a,c] and [c,b]
    if opposite_signs(func(a),func(c))
        bisection(a,c,func,iterator-1)
    elseif opposite_signs(func(c),func(b))
        bisection(c,b,func,iterator-1)
    end
end
