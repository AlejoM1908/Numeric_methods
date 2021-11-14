% The function triangular_factorization is the main function
function triangular_factorization()
    while 1
        try
            % Request user data
            matrix_size= request_matrix_size();
            A= request_matrix(matrix_size);
            b= request_values(matrix_size);

            % Getting the lower and upper triangle matrices from A
            [L,U]= process_matrix(A, matrix_size);

            disp(L)
            disp(U)

            % Solve the system
            response= solve_system(U,b,matrix_size);
            disp(A*response)

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


function value= solve_system(Upper, b, size)
    % Back substitution :
    x = zeros(size, 1);
    AM = [Upper b];
    x(size) = AM(size, size+1) / AM(size, size);
    for i = size - 1: - 1:1
        x(i) = (AM(i, size+1) - AM(i, i + 1:size) * x(i + 1:size)) / AM(i, i);
    end

    value= x;
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

% The function request_matrix is used to get the values matrix from the user
% @Param size is the matrix size
% Return a matrix corresponding to the values matrix
% Throw MATLAB:Triangular when matrix length and size are different
function value= request_matrix(size)
    value= input('Ingrese la matriz con los valores separados por espacios y las filas por punto y coma:\n');
    value= reshape(value, size, size);

    if length(value)~=size
        throw(MException('MATLAB:Triangular',...
                        'El tamaño de la matriz ingresada no coincide con el tamaño ingresado'))
    end
end

% The function request_values is used to get the values vector from the user
% @Param size is the matrix size
% Return a vector corresponding to the values vector that form the augmented matrix
% Throw MATLAB:Triangular when vector length and size are different
function value= request_values(size)
    value= input('Ingrese el vector de valores que forma la matriz aumentada:\n');

    if length(value)~=size
        throw(MException('MATLAB:Triangular',...
                        'El tamaño del vector ingresado no coincide con el tamaño ingresado'))
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