%The function lagrange_interpolation is the main function
function lagrange_interpolation()
    while 1
        try
            % Request user data
            flag= request_method();
            
            if flag
                [func, values]= request_data();
                points= convert_points(func, values);
            else
                points= request_points();
                func= str2func('@(x)0');
            end

            % Apply lagrange interpolation
            P= lagrange(points);
            polynom= convert_polynom(P);

            % print all functions
            pretty_print_graph(flag, polynom, points, func)
            pretty_print_table(flag, polynom, points, func)
            % Exit program
            decision= get_exit();
            if decision
                break
            end
        catch excep
            % Display error message
            clear_console()

            if strcmp(excep.identifier, 'MATLAB:Lagrange')
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

% The function request_data is used to ask the user the function and the points
% for the lagrange interpolation
% return the func and the values row vector
function [func, values]= request_data()
    func= str2func(['@(x)' input('Ingrese la función: ', 's')]);
    values= input('ingrese el vector de valores de x separados por comas: ');
end

% The function pretty_print_graph is used to graph all the parameters
% @Param flag is a boolean that tells if the user gives the function
% @Param polynom is the polynom found by the lagrange interpolation
% @Param points is the nx2 matrix representing the given points
% @Param func is the function given by the user
function pretty_print_graph(flag, polynom, points, func)
    low= points(1,1);
    up= points(end,1);
    range= low:(low+up)/12:up;

    if flag
        plot (range, polynom(range), '-b', range, func(range), '-r', points(:,1),points(:,2), '*r')
        legend('polinomio', 'función', 'puntos')
    else
        plot (range, polynom(range), '-b', points(:,1),points(:,2), '*r')
        legend('polinomio', 'puntos')
    end

    title('Interpolación de Lagrange')
    xlabel('x')
    ylabel('y')
end

% The function pretty_print_table is used to print all the parameters into a table representation
% @Param flag is a boolean that tells if the user gives the function
% @Param polynom is the polynom found by the lagrange interpolation
% @Param points is the nx2 matrix representing the given points
% @Param func is the function given by the user
function pretty_print_table(flag, polynom, points, func)
    low= points(1,1);
    up= points(end,1);

    if flag
        disp('   X_k    |   f(X_k)   |   P(X_k)   |   error')
        for i=low:(low+up)/12:up
            disp(sprintf('%f  |  %f  |  %f  |  %f', i, round(func(i),4), round(polynom(i),4), round(func(i)-polynom(i),4)))
        end
    else
        disp('   X_k    |   P(X_k)')
        for i=low:(low+up)/12:up
            disp(sprintf('%f  |  %f', i, round(polynom(i),4)))
        end
    end
end

% The function convert_points is used to convert the given function and 
% values into a nx2 matrix with the points coordinates
% @Param func is the function given by the user
% @Param values is the row vector of values given by the user
% return the nx2 matrix of points coordinates
function value= convert_points(func, values)
    n= length(values);

    for i= 1:n
        value(i, 1)= values(i);
        value(i, 2)= func(values(i));
    end
end

% The function convert_polynom is used to convert the vector of polynom
% values into the function representation
% Param vector is the row vector of values from the polynom
% return the function representation of the polynom
function value= convert_polynom(vector)
    n= length(vector);
    data= '';
    power= 0;

    for i= n-1:-1:0
        data= strcat(sprintf('%f.*x.^%d', vector(1, i+1), power), data);
        power= power+1;
        if i~=0
            data= strcat('+',data);
        end
    end

    value= str2func(['@(x)' data]);
end

% The function request_points is used to request the points to the user
% for the lagrange interpolation
% return the nx2 matrix of points coordinates
function value= request_points()
    value= input('ingrese el vector de valores de x: ');
    n= floor(length(value)/2);
    value= reshape(value, n, 2);
end

% The function request_method is used to ask the user if he want to enter
% the function or the points matrix
% return a boolean user for a flag in the program
function value= request_method()
    option= input('Que metodo desea usar\n 1) Ingresar Puntos\n 2) Ingresar función\n Opción: ', 's');
    
    if strcmp(option, '1')
        value= 0;
    elseif strcmp(option, '2')
        value= 1;
    else
        throw(MException('MATLAB:Lagrange',...
                        'El valor ingresado no es reconocido, intente nuevamente'))
    end
end

% The function lagrange is used to generate the polynom values row vector
% from the points matrix
% @Param points is the nx2 matrix of points coordinates
% return the polynom row vector of values
function value= lagrange(points)
    clear_console()
    n= length(points);
    P= zeros(n,n);

    for i= 1:n
        V= 1;
        for j= 1:n
            if i~=j
                V= conv(V, poly(points(j,1)))/(points(i,1)-points(j,1));
            end
        end
        P(i,:)= V*points(i,2);
    end

    value= sum(P);
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
