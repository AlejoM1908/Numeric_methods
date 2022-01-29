function shooting_method()
    while 1
        try
            % Request user data
            [p,q,r]= request_functions();
            [f,g]= generate_first_order_system_u(p,q,r);
            [f2,g2]= generate_first_order_system_v(p,q);
            [a,b]= request_bounds();
            h= request_step(a(1), b(1));

            % Process data
            u_k= rk4(h, a(2), 0, f, g, a(1), b(1));
            v_k= rk4(h, 0, 1, f2, g2, a(1), b(1));

            % Get solution
            [x_j, w_j]= get_solution(b(2), u_k, v_k);

            % Print Solution
            pretty_print(a(1), b(1), x_j, w_j, u_k, v_k, h)

            % Exit program
            decision= get_exit();
            if decision
                break
            end
        catch excep
            % Display error message
            clear_console()

            if strcmp(excep.identifier, 'MATLAB:shooting')
                disp(excep.message)
            else
                disp('Ocurrio algun error inesperado')
                disp(excep.message)
            end
        end
    end
end

% The function pretty_print is used to print the solution to the console and plot the functions
% @Param a is the left boundary x value
% @Param b is the right boundary x value
% @Param x_j is the iteration over u array
% @Param w_j is the iteration over v array
% @Param u_k is the array of values of t in u
% @Param v_k is the array of values of t in v
% @Param h is the value of the step in the iteration
function pretty_print(a, b, x_j, w_j, u_k, v_k, h)
    t = a:h:b;
    solFunc = str2func("@(t) 1.25+0.4860896526*t-2.25*(t^2)+2*t*atan(t)+0.5*((t^2)-1)*log(1+t^2)");

    fprintf('\nLos resultados son:\n')
    fprintf('   t_j\t\t  x_j\t\t x(t_j)\t\t error\n');

    for i = 1:length(v_k)-1
        fprintf('%0.6f\t%0.6f\t%0.6f\t%0.6f\n', t(i), x_j(i), solFunc(t(i)), solFunc(t(i))-x_j(i));
    end

    x_j = x_j(1:length(x_j)-1);
    u_k = u_k(1:length(u_k)-1);
    w_j = w_j(1:length(w_j)-1);

    plot(t, x_j, "-", t, u_k,"-r", t, w_j, "-y");
    xlabel("t");
    ylabel("y");
    legend("x(t)", "u(t)", "w(t)");
end

% The function request_functions is used to request the functions p, q and r from the user
% return the string for p, q and r functions
function [p, q, r]= request_functions()
    % Ask for the functions and parcing it from string to function
    p= input('Ingrese la función p: ', 's');
    q= input('Ingrese la función q: ', 's');
    r= input('Ingrese la función r: ', 's');
end

% The function generate_first_order_system_u is used to transform a second order differential equation to a first order system using variable u
% @Param p is the string that represents p function
% @Param q is the string that represents q function
% @Param r is the string that represents r function
% return the two equations from the first order system f and g
function [f, g]= generate_first_order_system_u(p, q, r)
    f= str2func("@(y) y");
    g= strcat("(", p, ")*y+", "(", q, ")*u+", r);
    g= str2func(strcat("@(t,u,y) ", g));
end

% The function generate_first_order_system_v is used to transform a second order differential equation to a first order system using variable v
% @Param p is the string that represents p function
% @Param q is the string that represents q function
% return the two equations from the first order system f and g
function [f, g]= generate_first_order_system_v(p, q)
    f= str2func("@(y) y");
    g= strcat("(", p, ")*y+", "(", q, ")*v");
    g= str2func(strcat("@(t,v,y) ", g));
end

% The function get_solution use the values from ruge-kutta 4th and x_b to find the original function solution
% @Param x_b is the value of b evaluated in the function
% @Param u_k is the array of values of t in u
% @Param v_k is the array of values of t in v
% return the two arrays of values from the iterating over arrays u and v
function [x_j, w_j]= get_solution(x_b, u_k, v_k)
    c = (x_b-u_k(end-1))/v_k(end-1);
    x_j = [];
    w_j = [];

    for j = 1:length(v_k)
        w_j = [w_j, c*v_k(j)];
        x_j = [x_j, u_k(j)+w_j(j)];
    end
end

% The function request_bound is used to request the boundaries point for the problem solution
% return the vector a and b with the points values
function [a, b]= request_bounds
    a= input('Ingrese el vector de valores de la barrera izquierda');
    b= input('Ingrese el vector de valores de la barrera derecha');
end

% The function request_step is used to request the user the step length
% @Param a is the left boundary x value
% @Param b is the right boundary x value
% return the step length
function value= request_step(a, b)
    value= str2double(input('Ingrese el numero de iteraciones que quiere realizar: ','s'));
    if isnan(value)
        throw(MException('MATLAB:shooting',...
                    'El valor ingresado no es númerico, intente nuevamente'))
    end

    value= (b-a)/value;
end

% The function rk4 implement the ruge-kutta 4th method
% @Param a is the left boundary x value
% @Param b is the right boundary x value
% @Param h is the value of the step in the iteration
% @Param x0 is the value of the first point in the iteration in x
% @Param y0 is the value of the first point in the iteration in y
% @Param f is the first function from the first order system
% @Param g is the second function from the fist order system
function x_k = rk4(h, x0, y0, f, g, a ,b)
    x_k = [x0];
    y_k = [y0];

    x = 0;
    y = 0;
    k= a:h:b;
    disp(k)

    %Se calculan los u_k
    for t = a:h:b
        x = x_k(end);
        y = y_k(end);

        f1 = f(y);
        g1 = g(t, x, y);

        f2 = f(y+(h/2)*g1);
        g2 = g(t+(h/2), x+(h/2)*f1, y+(h/2)*g1);

        f3 = f(y+(h/2)*g2);
        g3 = g(t+(h/2), x+(h/2)*f2, y+(h/2)*g2);

        f4 = f(y+h*g3);
        g4 = g(t+h, x+h*f3, y+h*g3);

        x = x+((h/6)*(f1+2*f2+2*f3+f4));
        y = y+((h/6)*(g1+2*g2+2*g3+g4));

        x_k = [x_k, x];
        y_k = [y_k, y];
    end
end

% The function get_exit is used to close the program execution
% return a boolean for a flag in the program
function value= get_exit()
    option= input('La ejecución finalizo correctamente, desea salir? (y/n): ', 's');

    if strcmp(option, "y")
        value= 1;
    else
        value= 0;
    end
end

% The function clear_console is usde to clear the console
function clear_console()
    
end
