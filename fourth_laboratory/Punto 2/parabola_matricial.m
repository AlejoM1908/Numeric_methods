function parabola_matricial
    %Limpia pantalla y muestra nombre del método
    clear
    clc
    
    disp(' PARÁBOLA ÓPTIMA POR MINIMOS CUADRADOS ');
    
    %X=[-3 0 2 4];
    %Y=[3 1 1 3];
    
    %Se piden los datos N cantidad de puntos, X y Y vectores, O orden de la
    %ecuación
    %Se establece M como O+1 para definir la cantidad de ecuaciones
    N = input('Ingrese cuantos puntos hay: ');
    X = input('Ingrese el vector X: ');
    Y = input('Ingrese el vector Y: ');
    O = input('Ingrese el orden de la ecuacion: ');
    M=O+1;
    %Se crea la matriz F y se llena
    F = zeros(N,M);
    expo=-1;
    
    for i=1:M
        expo=expo+1;
        for j=1:N
            F(j,i)=X(j)^expo;
        end
    end
    F;
    %Se halla F' y se hacen los cálculos de F'*F y de F'*y
    %Con estos datos se usa la función ft para usar el método de Gauss y
    %hallar la solución al sistema
    FT=F';
    S= FT*F;
    yt=Y';
    z= FT*yt;
    res= ft(S,M,z);

    %se imprime el polinomio en pantalla
    j= size(res);
    n = j(1,2);
    st="";
    for i=1:n
        s1=num2str(res(i));
        exp=i-1;
        if (i==1)
            st=s1;
        end
        if (i~=1)
            st=strcat(st,"+",s1,"x^",num2str(exp));
        end
    end
    disp("EL POLINOMIO ES:");
    disp(st);
    res_invert = fliplr(res);
    %Se grafica la función y los puntos dados inicialmente
    
    x=linspace(-4,5);
    vF=polyval(res_invert,x);
    plot(x,vF,LineWidth=3),title(st),xlabel('x'),ylabel('y'),grid,
    grid on
    hold on
    plot(X,Y,'o')
    

end