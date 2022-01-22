function newton_polynomial_interpolation_derivative()
    while 1
        try
            % Request user data
            func = request_function();
            n= request_degree();
            selection= request_diff_type();
            point= request_point();

            % Generate the divided differences matrix
            t_array= generate_values(n, selection, point);
            diffs= divided_diff(func, n, t_array);
            result= solve_polynom(diffs(1,:), t_array, n);
            fprintf('La derivada del punto %f hallada por el metodo fue: %f\n', point, result)

            % Exit program
            decision= get_exit();
            if decision
                break
            end
        catch excep
            % Display error message
            clear_console()

            if strcmp(excep.identifier, 'MATLAB:interpolation')
                disp(excep.message)
            else
                disp('Ocurrio algun error inesperado')
                disp(excep.message)
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

function value= request_degree()
    value= 4;
end

function value= request_diff_type()
    value= 2;
end

function value= request_point()
    value= 0.8;
end

function value= divided_diff(func, n, t_array)
    value = zeros(n+1);
    values= zeros(1, n+1);

    for temp= 1:n+1
        values(temp)= func(t_array(temp));
    end

    value(:,1)= values;

    for j= 2:n+1
        for i=  1:n+2-j
            value(i,j)= (value(i+1,j-1) - value(i, j-1))/(t_array(i+j-1)-t_array(i));
        end
    end
end

function value= generate_values(n, selection, point)
    precision= 0.00001;
    i= 1;
    value = zeros(1,n+1);

    switch selection
        case 1
            % Progressive differences
            for temp= 0:1:n
                value(i)= point + (precision * temp);
                i = i+1;
            end
        case 2
            % Centered differences
            value(1)= point;
            i= 2;

            for temp= 1:1:floor(n/2)
                value(i)= point + (precision * temp);
                value(i+1)= point + (precision * temp * -1);
                i = i+2;
            end
        case 3
            % Regressive dufferences
            for temp= 0:-1:(n*-1)
                value(i)= point + (precision * temp);
                i = i+1;
            end
    end
end

function value= solve_polynom(a_array, t_array, n)
    multiplication= 1;
    value= a_array(2);

    for temp= 3:n+1
        multiplication= multiplication * (t_array(1) - t_array(temp));
        value = value + (a_array(temp) * multiplication);
    end
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
    
end
