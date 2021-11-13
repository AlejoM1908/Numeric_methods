% The function triangular_factorization is the main function
function triangular_factorization()
    while 1
        try
            % Request user data
            matrix_size= request_matrix_size();
            variables= request_variables(matrix_size);
            equations= request_equations(matrix_size);

            % Getting the value matrix from the equations
            [A,~]= get_values_matrix(equations, variables);

            % Getting the lower and upper triangle matrices from A
            [L,U]= process_matrix(A);

            disp(L,U)
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

% The function clear_console is usde to clear the console
function clear_console()
    clc
end

% The function get_values_matrix is used to extract the values matrix from the given equations
% @Param equations is the equations vector
% @Param variables is the variables vector
% Return the matrix and equality vector from the parameters
function [matrix, equality]= get_values_matrix(equations, variables)
    [matrix, equality]= equationsToMatrix(equations, variables);
end

% The function process_matrix is used to generate the lower and upper triangular matrices from
% the given matrix
% @Param matrix is the given matrix to process
% Return the lower and upper matrices
function [lower, upper]= process_matrix(matrix)
    [lower, upper]=lu(matrix);
end

% The function request_equations is used to get the linear equation system from the user
% @Param size is the matrix size
% Return a vector of strings representing the equations
% Throw MATLAB:Triangular when vector length and size are different
function value= request_equations(size)
    value= split(input('Ingrese las ecuaciones separadas por comas: ', 's'), ',');

    disp(value)
    if length(value)~=size
        throw(MException('MATLAB:Triangular',...
                    'El número de ecuaciones excede el tamaño de la matriz cuadrada'))
    end
end

% The function request_variables is used to get the variables from the user
% @Param size is the matrix size
% Return a vector of characters representing the variables
% Throw MATLAB:Triangular when vector length and size are different
function value= request_variables(size)
    value= split(input('Ingrese las variables separadas por comas: ', 's'), ',');

    disp(value)
    if length(value)~=size
        throw(MException('MATLAB:Triangular',...
                    'El número de variables excede el tamaño de la matriz cuadrada'))
    end
end

% The function reques_matrix_size is used to get the square matrix size from the user
% Return the matriz size
% Throw MATLAB:Triangular when the input isn't numeric or error occurs
function value= request_matrix_size()
    try
        value= str2double(input('Ingrese el tamaño de la matriz cuadrada: ','s'));
        if isnan(value)
            throw(MException('MATLAB:Triangular',...
                        'El valor ingresado no es númerico, intente nuevamente'))
        end
    catch 
        throw(MException('MATLAB:Triangular',...
                        'El valor ingresado no es númerico, intente nuevamente'))
    end
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