function x=ft(AA,nn,yy)

%Se pide los datos
a = nn;
A = AA;
U = zeros(a,a);
L = zeros(a,a);
U=A;

%se Halla U con el metodo de gauss
m = a-1;
if (det(A)~= 0)
  for i = 1:m
    y = U(i,i);
    v1 = U(i,:);
    for j = i+1:a
      v2 = U(j,:);
      c = U(j,i)/y;
      L(j,i)=c;
      res = v2 - c*v1;
      U(j,:) = res;
    end
  end
  for i = 1:a
    L(i,i)=1;
  end
  aux = yy;
  %sprintf('el valor de Y es: ');
  Y = sust(L,aux,a);
  %sprintf('el valor de X es: ');
  X = susts(U,Y,a);
end
x=X;
