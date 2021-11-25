%La función diferencias_finitas permite obtener la tabla de diferencias y
%relacionarla con las temperaturas y los puntos
function diferencias_finitas(matriz, val_inter)
    %Se halla la cantidad de filas de la matriz y se crean los vectores
    %para almacenar las variables de temperatura, presion y de los puntos
    len= size(matriz,1);
    ordenadas=zeros(1,len);
    puntos=zeros(1,len);
    abscisas=zeros(1,len);
    dif=inf;
    pos=0;
    %Se llenan los vectores de las ordenadas, las abscisas y de los puntos
    for i=1: len
        ordenadas(1,i)= matriz(i,2);
        if  i<len
            puntos(1,i+1)=i;
        end
        abscisas(1,i)= matriz(i,1);
        %Se calcula el x y se obtiene la posición en la que este se
        %encuentra en la tabla
        if dif>abs(val_inter-matriz(i,1));
            dif= abs(val_inter-matriz(i,1));
            x=abscisas(1,i);
            pos=i;
        end
        
    end
    %Se despliegan los tags para la tabla
    tags= ['    Punto  | ','  x_i  | ',' f[x_i]' ...
                ' | ',' ▲f[x_i] |', '▲^2f[x_i]|', '▲^3f[x_i]|'... 
                '▲^4f[x_i]|','▲^5f[x_i]|'];
    disp(tags)
    %Se concatenan los vectores y la matriz
    tabla= horzcat(puntos', abscisas', calcular_diferencias(ordenadas,len));
    disp(tabla)
    %Se calculan h, s y el resultado de la interpolación
    h= tabla(2,2)-tabla(1,2);
    s= (val_inter-x)/h;
    res_P= tabla(pos,3)+ s*tabla(pos+1,4);
    %Se grafica la función y se destaca el punto que se busca interpolar
    fprintf('%s %f \n','El resultado de la interpolación es: ', res_P);
    plot(abscisas, ordenadas,val_inter,res_P,'o');
    title 'Polinomio de Newton en diferencias finitas hacia adelante';
    xlabel 'Temperatura (°F)';
    ylabel 'Presión de Vapor (lb/in^2)'; 
    
end