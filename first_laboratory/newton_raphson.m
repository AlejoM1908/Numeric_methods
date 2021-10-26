%The function newton_raphson is the main function
function newton_raphson()
    while 1
        try
            %Request function, p0 and tolerance
            func = input('Ingrese la función: '); 
            p0= input('Ingrese el punto inicial: ');
            t= 0.000001;
            s= str2sym(func);
            der_fun= diff(s);
            eval_f = subs(s,p0);
            eval_df= subs(der_fun, p0);
            c=0;

            while abs(eval_f)>t
                res= (p0 - (eval_f/eval_df));
                eval_f=subs(s,res);
                eval_df=subs(der_fun,res);
                p0=res;
                c=c+1;
            end
            double(res)
            
            

       catch excep
             Display error message
            clc
            
            if strcmp(excep.identifier, 'MATLAB:Bisection')
                disp(excep.message)
            else
                disp('Ocurrio algun error inesperado')
            end
        end
    end
end
%
%function fill_table()
    
%end
% The function continous_function is used to return the continous function
% where the bolzano bisection will be applied on
% @Param x is the value to evaluate in the function
% Return the continous function
function value= request_function()
    % Ask for the function and parcing it from string to function
    value= str2func(['@(x)' input('Ingrese la función: ', 's')]);
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
