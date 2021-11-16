function main_jacobi()
  fprintf('Le damos la bienvenida\nEste es el método de Jacobi \n');
  A = input('Ingrese la Matriz asociada al sistema: ');
  while !matriz_valida(A)
    A = input('Matriz no válida, ingrese otra:');
  endwhile
  b = input('Ingrese el vector de soluciones del sistema:');
  v_0 = input('Ingrese el vector del que vamos a partir:');
  max_iter = input('¿Cual es el máximo de iteraciones que desea?: ');
  jacobi(A, b, v_0, max_iter)
  