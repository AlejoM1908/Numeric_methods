function main_jacobi()
  fprintf('Le damos la bienvenida\nEste es el m�todo de Jacobi \n');
  A = input('Ingrese la Matriz asociada al sistema: ');
  while !matriz_valida(A)
    A = input('Matriz no v�lida, ingrese otra:');
  endwhile
  b = input('Ingrese el vector de soluciones del sistema:');
  v_0 = input('Ingrese el vector del que vamos a partir:');
  max_iter = input('�Cual es el m�ximo de iteraciones que desea?: ');
  jacobi(A, b, v_0, max_iter)
  