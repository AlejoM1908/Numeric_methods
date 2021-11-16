%Esta función calcula la diferencia 
%euclídea entre dos vectores, u y v

function r = distancia_euclidea(u, v)
  %calcula el vector u-v 
  vector_diferencia = zeros(1, size(u)(2));
  for i = 1 : size(vector_diferencia)(2)
    vector_diferencia(i) = u(i) - v(i);
  endfor
  
  %Obtiene la norma del vector u-v
  r = norma(vector_diferencia);
  
  
