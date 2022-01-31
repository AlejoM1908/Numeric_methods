clc; 
clear;
% Imprime nombre del metodo
fprintf("ECUACIONES DIFERENCIALES\n");
fprintf("Metodo de diferencias finitas \n\n");
format long;
% Se piden los datos al usuario
% se piden los p(t),q(t),r(t) y los límites junto con alfa y beta
% a,x(a),b,x(b) además del paso h
disp("Solucion a ecuaciones de la forma");
disp("x''(t) = p(t)x'(t) + q(t)x(t) + r(t)")
pts = input("Ingrese p(t) en comillas simples: ");
p = inline(pts);
qts = input("Ingrese q(t) en comillas simples: ");
q = inline(qts);
rts = input("Ingrese r(t) en comillas simples: ");
r = inline(rts);
a = input("Ingrese el limite inferior a: ");
alfa = input("Ingrese x(a)=alfa: ");
b = input("Ingrese el limite superior b: ");
beta = input("Ingrese x(b)=beta: ");
h = input("Ingrese el tamaño del paso: ");
N = (b-a)/h;


% Se crean e inicializan las matrices para generar el sistema Ax = b
MA = zeros(N-1,N-1);    
solB = zeros(N-1,1);

% Calcula los tk
tk = zeros(N-1,1);
for j=1:N-1
    tk(j,1) = a + j*h;
end

%Se llenan las filas de las matrices teniendo en cuenta la 
% representación matricial
% Llena primera fila de matriz A y matriz solución B
MA(1,1) = 2 + (h^2)*q(tk(1,1));
MA(1,2) = (h/2)*p(tk(1,1))-1;
solB(1,1) = -h^2*r(tk(1,1)) + ((h/2)*p(tk(1,1)) + 1)*alfa; 

% Llena ultima fila de matriz A y matriz solución B
MA(N-1,N-2) = (-h/2)*p(tk(N-1,1))-1;
MA(N-1,N-1) = 2 + (h^2)*q(tk(N-1,1));
solB(N-1,1) = -h^2*r(tk(N-1,1)) + ((-h/2)*p(tk(N-1,1)) + 1)*beta;

% Llena el resto de elementos la matriz A y la matriz solución B
for j=2:N-2
    MA(j,j-1) = (-h/2)*p(tk(j,1))-1;
    MA(j,j) = 2 + (h^2)*q(tk(j,1));
    MA(j,j+1) = (h/2)*p(tk(j,1))-1;
    solB(j,1) =  -h^2*r(tk(j,1));
end

% Calcula la solución del sistema Ax = b, hallando x
x = MA\solB;

X(1) = alfa;
X(2:N) = x;
X(N+1) = beta;

T(1) = a;
T(2:N) = tk;
T(N+1) = b;

A(:,2) = X;
A(:,1) = T;
Tabla = array2table(A, 'VariableNames',{'T_j','X_j'});
%disp(Tabla)

oper = input('¿Conoce la función exacta?: 0 SI | 1 NO: ');
if oper == 0
    exac= input('Ingrese la función: ');
    %1.25+0.486089652*t-(2.25*t.^2)+2*t.*atan(t)+0.5*((t.^2)-1).*log(1+t.^2);
    funcion=strcat('@(t)',exac);
    xc = str2func(funcion);
    XC(1) = xc(a);
    XC(2:N) = xc(tk);
    XC(N+1) = xc(b);
    ERR(:,1) = T;
    ERR(:,2) = XC - X;
    B(:,2) = XC;
    B(:,1) = T;
    %Se crean las tablas de los valores obtenidos con la función analítica 
    %y los errores obtenidos y se concatenan
    tAnalitica = array2table(B, 'VariableNames',{'T_j','Exacto'});
    tError = array2table(ERR, 'VariableNames',{'T_j','Err = X(tj) - X_j'});
    tablaN= join(Tabla,tAnalitica);
    tablaDef= join(tablaN,tError);
    disp(tablaDef);
else
    disp(Tabla);
end
% Se grafican los valores de x obtenidos y los valores obtenidos
% analíticamente
plot(T,X);
ylabel('y')
xlabel('t')
title('Gráfica de la aproximación numérica')


hold on
plot(T,XC);
hold off
legend('y = x(t)','Analitico')

grid on

