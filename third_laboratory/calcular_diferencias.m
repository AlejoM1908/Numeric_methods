%La función calcular_diferencias calcula las diferencias y genera una
%matriz 
function matriz=calcular_diferencias(vec1, tam)
    %Creación de la matriz
    matriz = zeros(tam);
    %Llena la primera fila de la columna con los valores almacenados en
    %el vector
    for i =1:tam
            matriz(i,1)= vec1(1,i);
    end
    %Se calculan las diferencias
    for j=2:tam
        for i=j:tam
            matriz(i,j)= matriz(i, j-1)-matriz(i-1,j-1);
        end
    end
end