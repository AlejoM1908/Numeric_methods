function r = newton_raphson(x0, func)
    try
        f = str2sym(func);
        df = diff(f);
        t = 0.000000000000000000000000001;
        eval_f = subs(f,x0);
        eval_df = subs(df, x0);
        while abs(eval_f) > t
                %res calculates the value of the time in each iteration 
                %prev calculates the value of p_{k+1} - p_k in each
                %iteration
                res = (x0 - (eval_f / eval_df));
                prev = res - x0;
                
                %We replace the values of eval_f and eval_df in each
                %iteration evaluating res in s and in the derivative of
                %func
                eval_f = subs(f, res);
                eval_df = subs(df, res);
                x0 = res;                                                                 
            end
            r = x0;
    
    catch excep
        % Display error message
        clear_console()

        if strcmp(excep.identifier, 'MATLAB:Raphson')
            disp(excep.message)
        else
            disp('Ocurrio algun error inesperado')
        end
    end
end

% The function clear_console is usde to clear the console
function clear_console()
    clc
end