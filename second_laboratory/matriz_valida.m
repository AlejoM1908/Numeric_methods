%Función que determina si una matríz 
%es válida para ser sometida al  método de Jacobi

function t = matriz_valida(A)
  
  %Evalúa si la matriz es cuadrada
  
  t = size(A)(1) == size(A)(2);
  
  %Evalúa si |A_i^i| > \Sigma |A_i^j|, j \in [1, n] - {i}
  
  
  for i = 1: size(A)(1)
    s = 0;
    for j = 1: size(A)(2)
      if i != j
        s = s + abs(A(i, j));
      endif
    endfor
    if abs(A(i, i)) <= s
      t = false 
      break
    endif
  endfor
endfunction
