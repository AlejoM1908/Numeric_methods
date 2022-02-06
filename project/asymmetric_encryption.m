function asymmetric_encryption
    display_welcome()
    
    while 1
        try 
            option= get_option();
            
            % Read a polynom from a file and save it in a string
            % and get the user´s message
            polynom= get_from_file('polynom.txt');
            
            if option
                message= get_message();
                
                % Encrypt the message using the polynom and numeric
                % methods
                bins= encrypt_message(polynom, message);
                
                % transform the encrypted message on a black and white image
                % where 0 is black and 1 is white
                image= mat2gray(bins, [0 1]);
                
                % saves de image as a .png
                [file, path]= select_dir('*.png',true);
                save_image(file, path, image)
                clear_console()
                disp('mensaje encriptado satisfactoriamente!!')
            else
                %Open a image with a encrypted message
                [file, path]= select_dir('*.png', false);
                image= get_image(file, path);
                %gets a bit matrix from a image
                bins= process_image(image);

                %decrypt the image using a polinom and 
                %the previous matrix
                message= decrypt_message(polynom, bins);
                clear_console()
                pretty_print_message(message)
            end

            % Get exit
            decision= get_exit();

            if decision
                break
            end
        catch excep
            % Display error message
            clear_console()

            if strcmp(excep.identifier, 'MATLAB:Encryption')
                disp(excep.message)
            else
                disp('Ocurrio algun error inesperado')
                disp(excep.message)
            end
        end
    end
end
% The function encrypt_message is used to get the binary representation of the roots matrix that is 
% obtained by the Newton-Raphson method
% @Param polynom is the string that represents the function with which we evaluate the ASCII values
% @Param message is the message to encode
% return the binary matrix of the roots 
function value= encrypt_message(polynom, message)
    asciis = string_to_ascii(message);
    tam = size(asciis);
    cryptos = [];
    bins = [];
    
    for i = 1: tam(1, 2)
        f = sprintf('%s%s%s',polynom, " - ", int2str(asciis(1,i)));
        x = double(newton_raphson(0, f));
        cryptos = [cryptos x];
    end

    for i = 1: tam(1, 2)
        b = float2bin(cryptos(1, i));
        bins = [bins' b'];
        bins = bins';
    end

    value= bins;
end

% The function process_image is used to convert the given array to it's binary representation
% @Param array is the image array to be processed
% return the bianry representation of the given array
function value= process_image(array)
    dimensions= size(array);

    for i= 1:dimensions(1,1)
        for j= 1:dimensions(1,2)
            if (array(i,j) == 255) 
                array(i,j)=1;
            end
        end
    end
    
    value= double(array);
end

% The function decrypt_message is used to get the encrypted message from the image array
% @Param polynom is the polynom used to encrypt the message
% @Param array is the image pixels array
% return the decrypted message
function value= decrypt_message(polynom, array)
    dimensions= size(array);
    decrypted= [];
    chars= [];
    message= '';

    for i= 1:dimensions(1,1)
        decrypted(i)= bin2float(array(i,:));
    end

    for i= 1:dimensions(1,1)
        func= str2func(sprintf('%s%s', '@(x)', polynom));
        chars(i)= func(decrypted(i));
    end

    for i= 1:dimensions(1,1)
        message= sprintf('%s%s', message, char(ceil(chars(i))));
    end

    value= message;
end

% The function float2bin transforms floats to binary
% @Param number is the float that will be transformed into binary
% return the binary value of the float
function value= float2bin(number)
    n = 32; % number bits for integer part of your number      
    m = 32; % number bits for fraction part of your number
    % binary number
    value = fix(rem(number * pow2(-(n - 1): m), 2));
end

% The function bin2float is used to transform a binary number into it's floating point number representation
% @Param number is the binary number to be processed
% return the floating point number representation of the given binary
function value= bin2float(number)
    n = 32; % number bits for integer part of your number      
    m = 32; % number bits for fraction part of your number

    value = number * pow2(n - 1: -1: -m).';
end

% The function get_from_file is used to scan a file and get all it's content
% @Param file_name is the string that represents the name of the file is the OS
% return the whole file content
function value= get_from_file(file_name)
    file_id= fopen(file_name, 'r');
    value= fscanf(file_id, '%c');
    fclose(file_id);
end

% The function select_dir is used to browse the file system and get the name and path of a file
% to write or read in it
% @Param file_name is the default file name for saving
% @Param save is a flag to select read or write operation from the ui
% return the file name and it's directory path
function [file, path]= select_dir(pattern, save)
    if save 
        [file, path]= uiputfile(pattern);
    else 
        [file, path]= uigetfile(pattern);
    end
end

% The function save_file is used to save specific data to a file
% @Param file is the file name
% @Param path is the directory path to the file
% @Param data is the data to be saved
function save_file(file, path, data)
    file_id= fopen(sprintf('%s%s', path, file), 'w');
    fwrite(file, data)
    fclose(file_id);
end

% The function get_image is used to browse the file systema and open the given image
% @Param file is the file name
% @Param path is the path to the file in the file system
% return the matrix representation of the image
function value= get_image(file, path)
    value= imread(sprintf('%s%s', path, file));
end

% The function save_image is a function used to save the imgae in the given path
% @Param file is the name of the image
% @Param path is the path in the file system
% @Param image is the array representation of the image to be saved
function save_image(file, path, image)
    imwrite(image, sprintf('%s%s', path, file))
end

% The function get_message is used to ask the user for the message to encrypt
% return the message to encrypt
function value= get_message
    value= input('Por favor ingrese su mensaje a continuación:\n', 's');
end

% The function string_to_ascii returns an array of the ASCII values of a word
% @Param text is the word to be transformed into ascii representation array
% return the ascii representation array from the given word
function value= string_to_ascii(text)
    value = double(text);
end

% The function ascii_to_string returns a string from the given ascii array
% @Param ascii_array is the array of ascii values
% return the string representation from the ascii values array
function value= ascii_to_string(ascii_array)
    value= char(ascii_array);
end

% The function display_welcome presents a start message to the user
function display_welcome()
    disp('##############################################')
    disp('#Bienvenido al sistema de cifrado de mensajes#')
    disp('##############################################')
    disp('')
end

% The function get_option is used to validate if the user wants to encrypt a message or decrypt an image
function value= get_option()
    option= input('Que desea hacer a continuación: \n1) Encriptar un mensaje nuevo\n2)Desencriptar un mensaje\nSu selección: ', 's');
    
    switch option
        case '1'
            value= 1;
        case '2'
            value= 0;
        otherwise
            throws(MException('MATLAB:Encryption',...
                    'El valor ingresado no es reconocido, intente nuevamente'))
    end
end

%this function prints a message with a stetic format
function pretty_print_message(message)
    %set the length and a decorator
    length= size(message);
    decorator = '##';

    %print the decorator as a frame for the message
    for i= 1:length(1,2)
        decorator = sprintf('%s%s', decorator, '#');
    end

    disp(decorator)
    disp(sprintf('%s%s%s', '#', message, '#'))
    disp(decorator)
end

% The function get_exit is used to close the program execution
function value= get_exit()
    option= input('La ejecución finalizo correctamente, desea salir? (y/n): ', 's');

    if strcmp(option, "y")
        value= 1;
    else
        value= 0;
    end
end

% The function clear_console is used to clear the console
function clear_console()
    clc
end
