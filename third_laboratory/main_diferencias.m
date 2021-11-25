%En la función main_diferencias se piden los datos de la tabla y el valor a
%interpolar y se llama a la función diferencias_finitas
function main_diferencias
    control=1;
    while control==1
        m= input('Ingrese la tabla en forma de matriz: ');
        v= input('Ingrese al valor a interpolar: ');
        diferencias_finitas(m,v);
        control= input('¿Desea hacer el proceso de nuevo? 1 para sí/ 2 para no: ');
    end
end