%Esta función ejecuta el método de Jacobi
function r = jacobi(A,b, v_init, max_iter)
  
  %Establece parámetros básicos del programa como
  %un contador, la tolerancia y los vectores iniciales
  
  format short;
  tolerancia = 0.00000000001;
  contador = 1;
  solucionado = false;
  x_i = v_init;
  x_f = zeros(1, size(A)(1));
  d = 0;
  
  %Se crea una matriz auxiliar para almacenar todos los vectores obtenidos
  %en el procedimiento y así poder graficarlos
  
  elem_plot = zeros(size(A), 0);
  
  %Imprime el encabezado de la tabla de salida
  
  fprintf('t \t  X_k \t \t  Y_k \t\t  Z_k \t    Distancia Euclídeal  \n');
  
  %Este es el cálculo de la fórmula iterativa. 
  %El cálculo solo se detendrá sí el sistema fue resuelto o 
  %si el proceso supera la cantidad de iteraciones deseada
  
  while !solucionado && max_iter >= contador 
    for j = 1 : size(A)(2)
      s = 0;
      for k = 1 : size(x_i)(2)
        if k != j
          s = s + A(j, k) * x_i(k);
        endif
      endfor
      x_f(j) = (b(j) - s) / A(j, j);
    endfor
    
    %Calcula la distancia entre los vectores X_{k-1} y X_{k}
    %para determinar la convergencia y saber si el sistema fue
    %resuelto 
    
    d = distancia_euclidea(x_f, x_i);
    solucionado = d <= tolerancia;
    % Actualiza el valor del vector final e inicial 
    % así mismo, imprime los valores obtenidos en  esta iteración 
    x_i = x_f;
    
    fprintf('%g \t', contador);
    for i = 1 : size(x_f)(2)
      fprintf('%f\t', x_f(i));  
    endfor
    fprintf('%f\n', d);
    
    % Actualiza el contador, y añade el vector obtenido a la la matriz auxiliar
    
    contador = contador + 1;
    elem_plot = [elem_plot, x_f'];
  endwhile
  
  % Se extraen filas de la matriz auxiliar, servirán como vectores para 
  % elaborar la gráfica que explica la convergencia. 
  
  x = elem_plot(1, 1:end);
  y = elem_plot(2, 1:end);
  z = elem_plot(3, 1:end);
  plot3(x, y, z, 'LineWidth', 2);
  r = x_f;
endfunction