% The function bolzano_bisection is the main function
function bolzano_bisection()
    while 1
        try
            % Request function and limits
            func= request_function();
            a= input('Ingrese el limite inferior: ');
            b= input('Ingrese el limite superior: ');

            % Check if the limits evaluated has opposite signs
            if b < a
                throw(MException('MATLAB:Bisection',...
                    'El limite superior es menor al limte inferior'))
            elseif opposite_signs(func(a), func(b))
                % Start iterating to get the solution
                get_value(a,b,func)
            else
                throw(MException('MATLAB:Bisection',...
                    'Los limites evaluados no tienen signos diferentes'))
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

% The function opposite_signs is used to detect if the given numbers has 
% different signs
% @Param a is the first number
% @Param b is the second number
% Return true if the numbers has opposite signs, false on the contrary
function value = opposite_signs(a,b)
    if a < 0
        value= b>=0;
    else
        value= b < 0;
    end
end

% The function get_value is used to start the bolzano bisection algorithm
% and the data output
% @Param a is the left limit
% @Param b is the right limit
% @Param func is the continous function
function get_value(a,b,func)
    iterations= get_iterator();
    tags= ['lower limit | ','upper limit | ','iterations | ','median | ','result'];

    clear_console()
    disp(tags)
    value= bisection(a,b,func,iterations);
    fprintf('El valor para llevar la función a 0 es : %f\n', value)

    graph_function(a,b,func,value)
end

% The function continous_function is used to return the continous function
% where the bolzano bisection will be applied on
% @Param x is the value to evaluate in the function
% Return the continous function
function value= request_function()
    % Ask for the function and parcing it from string to function
    value= str2func(['@(x)' input('Ingrese la función: ', 's')]);
end

% The function clear_console is usde to clear the console
function clear_console()
    clc
end

% The function get_iterator is used to ask the user for the number of
% iterations or return the default value
% Return the number of iterations
function value= get_iterator()
    clear_console()

    % Get user selection
    option= input('Desea definir las iteraciones? (y/n): ','s');

    if strcmp(option, "y")
        % Get iteration number from user
        value= input('Ingrese el número de iteraciones: ');
    else
        % Return the default value
        value= 10;
    end
end

% The function get_median is used to calculate the median between the to
% given numbers
% @Param a is the first number
% @Param b is the second number
% Return the median between the two numbers
function value= get_median(a,b)
    value= (a+b)/2;
end

% The function bisection is a recursive function that the closest value
% where the function value is 0
% @Param a is the left limit
% @Param b is the right limit
% @Param func is the continous function
% @Param iterator is the amount of times to operate, default 10
function value= bisection(a,b,func,iterator)
    % Check if the iterator ends
    if iterator <= 0
        value = round(get_median(a,b),4);
        return
    end
    
    % Check if the iteration suffice the answer
    c= get_median(a,b);
    if func(c) < 0.00001 && func(c) > -0.00001
        value= round(c,4);
        return
    end
    
    disp([a,b,iterator,c,func(c)])
    % Check between interval [a,c] and [c,b]
    if opposite_signs(func(a),func(c))
        value= bisection(a,c,func,iterator-1);
    elseif opposite_signs(func(c),func(b))
        value= bisection(c,b,func,iterator-1);
    end
end

% The function graph_function is used to graph the resuts
% @Param a is the left limit
% @Param b is the right limit
% @Param func is the continous function
% @Param value is the value of the iterations
% Return the graph of the function and the result point
function graph_function(a,b,func,value)
    range = a:(a+b)/400:b;

    % Set the graph style
    plot(range, func(range), '-b', value, func(value), '*r')
    title('Bolzano Bisection')
    legend('function', 'zero value')
    xlabel('x')
    ylabel(extractAfter(func2str(func), '@(x)'))
end
