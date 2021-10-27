%The function newton_raphson is the main function
function newton_raphson()
cont=1;
    while cont==1
        try
            %Request function and p0 
            format long;
            func = input('Ingrese la función: '); 
            p0= input('Ingrese el punto inicial: ');
            t= 0.000000000000000000000000001;
            s= str2sym(func);
            der_fun= diff(s);
            eval_f = subs(s,p0);
            eval_df= subs(der_fun, p0);
            it=0;
            tags= ['      k      | ','   Time p_k   | ','p_k+1-p_k | ','    Height | '];
            disp(tags)
            %fprintf('      %g         %.10f               %.10f\n',it, double(p0), double(eval_f));
           
            while abs(eval_f)>t
                                
                res= (p0 - (eval_f/eval_df));
                prev= res-p0;
                if it==0
                  
                    fprintf('      %g         %.10f     %.10f          %.10f\n',it, double(p0), double(prev), double(eval_f));
             
                end   
                                
                eval_f=subs(s,res);
                eval_df=subs(der_fun,res);
                p0=res;
                it=it+1;
                fprintf('      %g         %.10f     %.10f          %.10f\n',it, double(p0), double(prev),  double(eval_f));
                
                
                                     
            end
            double(res);
            
       catch excep
             Display error message
            clc
            
            if strcmp(excep.identifier, 'MATLAB:Bisection')
                disp(excep.message)
            else
                disp('Ocurrio algun error inesperado')
            end
        end
        cont= input('¿Desea continuar? 1 para sí/ 2 para no: ');
        
    end
end
