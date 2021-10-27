%The function newton_raphson is the main function
function newton_raphson()
cont=1;
    while cont==1
        try
            %We request function and p0 
            format long;
            func = input('Ingrese la función: '); 
            p0= input('Ingrese el punto inicial: ');
            %We stablish the tolerance
            t= 0.000000000000000000000000001;
            %We use str2sym in order to turn func into a symbolic object
            %Symbolic objects allow the use of diff to obtain the
            %derivative of the function
            s= str2sym(func);
            der_fun= diff(s);
            %We use subs to evaluate p0 in function and obtain the value 
            eval_f = subs(s,p0);
            eval_df= subs(der_fun, p0);
            %We establish an iterator 
            it=0;
            %We use tags to display the table
            tags= ['      k      | ','   Time p_k     | ','   p_k+1-p_k   ' ...
                '  | ','     Height |    '];
            disp(tags)
            %We create four vectors in order to store the iterator, the
            %time p_k, p_k+1-p_k and the height
            vec1= zeros(1,5);
            vec2= zeros(1,5);
            vec3= zeros(1,5);
            vec4= zeros(1,5);
            %Each column of the table is stored in a vector
            vec2(1,it+1)=p0;
            vec3(1, it+1)=eval_f;
            while abs(eval_f)>t
                %res calculates the value of the time in each iteration 
                %prev calculates the value of p_{k+1} - p_k in each
                %iteration
                res= (p0 - (eval_f/eval_df));
                prev= res-p0;
                vec2(1,it+2)=res;
                vec4(1,it+1)=prev;
                %We replace the values of eval_f and eval_df in each
                %iteration evaluating res in s and in the derivative of
                %func
                eval_f=subs(s,res);
                eval_df=subs(der_fun,res);
                vec3(1,it+2)=eval_f;
                p0=res;
                it=it+1;
                vec1(1,it+1)=it;
                                                                                
            end
            %We transpose the vectors and concatenate them to create a matrix
            vec1=vec1';
            vec2 =vec2'; 
            vec3=vec3'; 
            vec4=vec4';
            m=[vec1, vec2, vec4, vec3];
            %We print the values in the matrix
            for i=1: it+1
                fprintf('      %g         %.10f     %.10f      %.10f \n', ...
                    m(i,1), m(i,2), m(i,3),   m(i,4));
            end
            %We plot the function and mark the solution point
            x=-2*p0:0.5:2*p0;
            [a,tam]= size(x);
            y=  zeros(1,tam);
            for i=1: tam
                y(1,i)= subs(s,x(1,i));
            end
            
            plot(x,y,'.k',res,0,'o');title 'Newton Raphson Method';xlabel 'Time'; ylabel 'Height'; 
       catch excep
            %Display error message
            clc
            
            if strcmp(excep.identifier, 'MATLAB:Bisection')
                disp(excep.message)
            else
                disp('Ocurrio algun error inesperado')
            end
        end
        %Continuity validation
        cont= input('¿Desea continuar? 1 para sí/ 2 para no: ');
        
    end
end
