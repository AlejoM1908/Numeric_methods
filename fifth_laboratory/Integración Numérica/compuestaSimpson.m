function i = compuestaSimpson(a, b, nodos)
  f = @inFunc; %La funcion a integrar 
  h = h(a, b, nodos); %La amplitud de los intervalos
  M = M(nodos); 
  x = [a: h: b]; %Nodos obtenidos en el intervalo a, b
  
  %Primer sumando de la formula 
  
  s0 = (h / 3) * (feval(f, a) + feval(f, b));
  
  %Sumatoria para obtener el segundo sumando 
  
  s1 = 0;
  for k = 2: M
    s1 = s1 + feval(f, x(2 * k - 1));
  end
  s1 = (2 * h / 3) * s1;
  
  %Sumatoria para calcular el tercer elemento de la formula 
  
  s2 = 0;
  for k = 1: M
    s2 = s2 + feval(f, x(2 * k));
  end
  s2 = (4 * h / 3) * s2;
  
  fprintf("S(F, %f) = %f + %f + %f \n", h, s0, s1, s2);
  
  
  i = s0 + s1 + s2;