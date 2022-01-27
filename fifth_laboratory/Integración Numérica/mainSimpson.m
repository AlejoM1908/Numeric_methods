function mainSimpson()
  fprintf("Ingrese los extremos del intervalo [a, b] \n");
  a = 0;
  b = 0;
  nodos = 0;
  while (true)
    a = input("a = ");
    b = input("\nb = ");
    if (a < b)
      break;
    else
      fprintf("a debe ser menor que b\n");
    end
  end
  fprintf("Ingrese una cantidad impar de nodos\n");
  while (true)
    nodos = input("\n2M + 1 = ");
    if (mod(nodos, 2) ~= 0)
      break;
    else
      fprintf("Debe ser impar");
    end
  end
  fprintf("La función a integrar está en el archivo \n inFunc.m");
  s = input("\n ¿Está correcta? (1: si, 2:no)");
  while (true)
    if (s == 1)
      i = compuestaSimpson(a, b, nodos)
      break;
     else
      s = inputf("¿Ya? (1: si, 2: no)");
    end
  end
end
  