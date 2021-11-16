%Esta función calcula la norma de un vector 
function n = norma(v)
  n = 0;
  for i = 1 : size(v)(2)
    n = n + v(i) ^ 2;
  endfor
  n = sqrt(n);
endfunction 
  