% The function least_squares_regression is the main function
function least_squares_regression()
    while 1
        try
            % Request user data
            points= request_points();

            % Calculate Summations
            values= calculate_summations(points);
            [matrix, matrix_values]= get_equations(values(end,:), length(points));
            
            % Using triangular factorization to solve the system
            [L,U]= process_matrix(matrix, 2);
            [x,~]= solve_system(L, U, matrix_values, 2);

            % Get polynom
            polynom= convert_polynom(x.');

            % Printing results
            clear_console()
            pretty_print_console(values, polynom)
            pretty_print_graph(points, polynom)

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


function pretty_print_console(values, func)
    funcStr= extractBetween(func2str(func), '@(x)', '.*x.^0');
    n= length(values);

    disp('    x     |      y     |     x^2    |     x*y')
    for i= 1:n
        fprintf('%f  |  %f  |  %f  |  %f\n', ...
        round(values(i,1) ,4), round(values(i,2), 4), round(values(i,3), 4), round(values(i,4),4))
    end

    fprintf('\nresult polynom: %s\n', cell2mat(funcStr(1)))
end

function pretty_print_graph(points, func)
    low= points(1,1);
    up= points(end,1);
    range= low:(low+up)/12:up;

    plot (range, func(range), '-b', points(:,1),points(:,2), '*r')
    legend('polinomio', 'puntos')
    title('Regresión lineal por minimos cuadrados')
    xlabel('x')
    ylabel('y')
end

% The function request_points is used to request the points to the user
% for the lagrange interpolation
% return the nx2 matrix of points coordinates
function value= request_points()
    value= input('ingrese el vector de puntos: ');
    value= reshape(value( :,[1:2:end, 2:2:end]), [], 2);
end

% The function calculate_summations is used to calculate the summations
% needed for the line regresion of least squares
% @Param points is a nx2 matrix of n given points
% return a n+1x4 matrix containing all the summations values
function value= calculate_summations(points)
    n= length(points);
    value= zeros(n+1,4);

    % Copy the points array to the return matrix
    for i= 1:n
        value(i,1)= points(i,1);
        value(i,2)= points(i,2);
    end

    % Calculate the needed operations x^2 and x*y from the points
    for i= 1:n
        value(i,3)= value(i,1).^2;
        value(i,4)= value(i,1)*value(i,2);
    end

    % Calculate the summations
    for i= 1:4
        for j= 1:n
            value(n+1,i)= value(n+1,i) + value(j,i);
        end
    end
end

function [matrix,values]= get_equations(summations, n)
    matrix= zeros(2);
    values= zeros(2,1);

    % Assign the values to the matrix
    matrix(1,1)= summations(3);
    matrix(1,2)= summations(1);
    values(1,1)= summations(4);
    matrix(2,1)= summations(1);
    matrix(2,2)= n;
    values(2,1)= summations(2);
end

% The function solve_system is used to solve the system having the LU descomposition
% @Param Upper is the upper triangular matrix
% @Param b is the values vector
% @Param size is the matrix size
% Return the solution vectors x and y
function [x,y]= solve_system(lower, upper, b, size)
    % Forward Substitution
    y= zeros(size, 1);
    y(1)= b(1)/lower(1,1);
    for i= 2:size
        y(i)= (b(i) - lower(i,1:i-1) * y(1:i-1)) / lower(size,size);
    end

    % Backward Substitution
    x= zeros(size, 1);
    x(size)= y(size) / upper(size, size);
    for i = size - 1:-1:1
        x(i)= (y(i) - upper(i, i+1:size) * x(i+1:size)) / upper(i, i);
    end
end

% The function process_matrix is used to generate the lower and upper triangular matrices from
% the given matrix using the doolittle algorithm
% @Param matrix is the given matrix to process
% Return the lower and upper matrices
function [lower, upper]= process_matrix(matrix, size)
    upper= zeros(size, size);
    lower= zeros(size, size);

    % Descomposing the matrix into upper and lower triangular matrices
    for i= 1:size
        % Finding Upper triangular
        for k= i:size
            % Summation of Lower[i][j] * Upper[j][k]
            sum= 0;
            for j= 1:i
                sum= sum + (lower(i,j) * upper(j,k));
            end
            upper(i,k)= matrix(i,k) - sum;
        end

        % Finding Lower triangular
        for k= i:size
            if i==k
                lower(i,i)= 1; % Diagonal as 1
            else
                % Summation of Lower[k][j] * Upper[j][i]
                sum= 0;
                for j= 1:i
                    sum= sum + (lower(k,j) * upper(j,i));
                end
                lower(k,i)= (matrix(k,i) - sum) / upper(i,i);
            end
        end
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

% The function clear_console is used to clear the console
function clear_console()
    clc
end