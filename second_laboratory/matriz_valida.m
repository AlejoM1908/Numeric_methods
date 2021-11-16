%Funci�n que determina si una matr�z 
%es v�lida para ser sometida al  m�todo de Jacobi

function t = matriz_valida(A)
  
  %Eval�a si la matriz es cuadrada
  
  t = size(A)(1) == size(A)(2);
  
  %Eval�a si |A_i^i| > \Sigma |A_i^j|, j \in [1, n] - {i}
  
  
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
