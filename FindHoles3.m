function    holes=FindHoles3(f)
% holes=FindHoles3(f,v,dibujar)
caras=f;
aristas2=[caras(:,1:2);caras(:,2:3);caras(:,3) caras(:,1)];
[aristas,indices_orden]=sort(aristas2,2); %las aristas se ordenan por filas, para que el índice menor se encuentre siempre en la columna 1

%% Buscamos dentro de aristas aquéllas que no únicas y, por tanto pertenecen a los huecos
%Para buscar las aristas que sólo aparecen a la vez se seguirá el siguiente algoritmo:
% 1.- Calculamos lo elementos únicos de las aristas. Esta función devuelve también un conjunto de índices (ind_unic) que verifica que
% aristas=uni(ind_unic); Por tanto, en ind_uni están indicadas las propias repeticiones. Por ejemplo: si aristas = [1 2; 4 5; 1 2;6 7;8 9]; tras
% ejecutar unique tendremos que unic=[1 2; 4 5; 6 7; 8 9]; y en ind_unic=[1 2 1 3 4], que indica que aristas está formado por la fila 1 de unic seguido de
% la fila 2 y seguido, de nuevo, por la fila 1, etc
[unic,ind_aristas,ind_unic]=unique(aristas,'rows');

repeticion=hist(ind_unic,sort(unique(ind_unic)));
repeticion2=repeticion(ind_unic)';
aristas33=aristas2(repeticion2==1,:);
gruposcaras=finddisconnsurf(aristas33);
if(~isempty(gruposcaras))
for indal=1:size(gruposcaras,2)
    if(size(gruposcaras{1,indal},1)>2)
        loops=extractloops(gruposcaras{1,indal});
        loops(isnan(loops))=[];
        loops=[loops loops(1,1)];
        holes{1,indal}=loops;
    end
end
else
    holes=[];
end




% for indal=1:size(gruposcaras,2)
%     preloop=gruposcaras{1,indal};
%     loop=preloop(1,:);
%     ini=loop(1,2);
%     terminar=0;
%     preloop(1,:)=[];
%     while (~isempty(preloop))
%         [filun,colun]=find(preloop==ini);
%         filun=filun(1,1);
%         colun=colun(1,1);
% %         ini=preloop(filun,setdiff([1 2],colun));
% %         ini=setdiff(sort(unique(preloop(filun,colun))),2352)
%         loop=[loop ini'];
%         preloop(filun,:)=[];
%     end
%     holes{1,indal}=[loop loop(1,1)];
% end



end





% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %% Adaptamos datos
% if nargin==1
%     error('Fatla la matriz de vértices');
% elseif nargin==2
%     dibujar=0;
% end
% if size(f,1)==3
%     f=f';
% elseif size(f,2)~=3
%     error('La matriz de caras no está correctamente definida');
% end
% 
% if size(v,1)==3
%     v=v';
% elseif size(v,2)~=3
%     error('La matriz de caras no está correctamente definida');
% end
% 
% %% Creamos la matriz de aristas de toda la malla
% fr=[f(:,1:2) f(:,2:3) f(:,3) f(:,1)]; %Creo la matriz de índices
% aristas=reshape(fr',2,[])'; %y reordeno, de tal forma que cada fila es un par de aristas.
% [aristas,indices_orden]=sort(aristas,2); %las aristas se ordenan por filas, para que el índice menor se encuentre siempre en la columna 1
% 
% %% Buscamos dentro de aristas aquéllas que no únicas y, por tanto pertenecen a los huecos
% %Para buscar las aristas que sólo aparecen a la vez se seguirá el siguiente algoritmo:
% % 1.- Calculamos lo elementos únicos de las aristas. Esta función devuelve también un conjunto de índices (ind_unic) que verifica que
% % aristas=uni(ind_unic); Por tanto, en ind_uni están indicadas las propias repeticiones. Por ejemplo: si aristas = [1 2; 4 5; 1 2;6 7;8 9]; tras
% % ejecutar unique tendremos que unic=[1 2; 4 5; 6 7; 8 9]; y en ind_unic=[1 2 1 3 4], que indica que aristas está formado por la fila 1 de unic seguido de
% % la fila 2 y seguido, de nuevo, por la fila 1, etc
% [unic,ind_aristas,ind_unic]=unique(aristas,'rows');
% 
% % 2.- En segundo lugar ordenaremos el vector ind_unic. Siguiendo con el ejemplo, ind_unic=[1 1 2 3 4]. Se puede observar que los índices
% % repetido los hemos agrupado.
% ind_unic=sort(ind_unic);
% 
% % 3.- Los índices finales se obtinen eligiendo por un lado los indices en posiciones impares (ind_unic(1:2:end)) y los pares
% % (ind_unic(2:2:end)), eliminando los índices que hay en los pares de los impares y viceversa y, del resultado de estas dos operaciones,
% % haciendo la unión. En nuestro ejemplo, impares =[1 2 4] y pares=[1 3]. Si extraemos de los impares los pares, impares-pares=[2 4], y si
% % extraemos de los pares los impares, pares-impares=[3]. La unión de ambos es: union=[2 3 4], que como se puede observar son los índices de
% % las aristas no repetidas. aristas_bordes=unic(union); En nuestro caso aristas_bordes=[4 5;8 9];
% impares = ind_unic(1:2:end);
% pares = ind_unic(2:2:end);
% indices_no_repetidos=union(setdiff(impares, pares),setdiff(pares,impares));
% aristas_bordes=unic(indices_no_repetidos,:);
% clear pares impares indices_no_repetidos aristas unic ind_aristas ind_unic indices_orden fr
% %% Realizamos la ordenación de huecos
% terminar = 0;
% n_hueco=0;
% %Reordeno la matriz de tal forma que la convierto en un vector en donde las posiciones impares se corresponden con el primer índice de cada
% %borde y las pares con el segundo. Si, p.e., aristas_bordes=[1 2;4 5;2 5; 1 4] => aristas_huecos=[1 2 4 5 2 5 4 1];
% aristas_huecos=reshape(aristas_bordes',1,[]); 
% if ~isempty(aristas_huecos)
%     while ~terminar
%         hueco=aristas_huecos(1:2); %Empiezo siempre un hueco con los dos primeros índices;
%         aristas_huecos=aristas_huecos(3:end); %y los quito de la lista
%         terminar1=0;
%         while ~terminar1
%             %Tengo que buscar el último de la lista hueco en la lista aristas_huecos
%             posicion=find(aristas_huecos==hueco(end));
%             if rem(posicion,2)
%                 hueco=[hueco aristas_huecos(posicion+1)]; %Si es impar la posición, el otro nodo es el siguiente
%                 aristas_huecos=QuitaNodos(aristas_huecos,posicion,posicion+1); %Quitamos los nodos que acabamos de usar
%             else
%                 hueco=[hueco aristas_huecos(posicion-1)]; %Si es par la posición, el otro nodo es el anterior
%                 aristas_huecos=QuitaNodos(aristas_huecos,posicion-1,posicion); %Quitamos los nodos que acabamos de usar
%             end
%             %Se ha terminado con un hueco cuando el primer nodo es igual al último o cuando no tenenos más nodos que buscar
%             terminar1 = (hueco(1)==hueco(end)) | isempty(aristas_huecos);
%         end
%         %Cada hueco se almacena en una posición de la celda hole. Ha y algún caso ¿? en el que el primero no es igual al último. En este caso se
%         %fuerza. (El matener que el 1º=último es por comodidad a la hora de dibujar)
%         n_hueco=n_hueco+1;
%         if hueco(1)==hueco(end)
%             holes{n_hueco}=hueco;
%         else
%             holes{n_hueco}=[hueco hueco(1)];
%         end
%         %Se termina toda la búsqueda cuando no hay más nodo que buscar
%         terminar=isempty(aristas_huecos);
%     end
% else
%     holes = {};
% end
%         
%         
%         
% %% Dibujamos las aristas para visualizarlas
% if dibujar && ~isempty(holes)
%     p=DibujaMalla(v,f,0.5*ones(length(v),1),1);
%     hold on
%     colores=rand(length(holes),3);
%     for k=1:length(holes)
%         plot3(v(holes{k},1),v(holes{k},2),v(holes{k},3),'Color',colores(k,:),'LineWidth',2);
%     end
% end
% 
% 
% %% Funciones propias de FindHole
% function    vector=QuitaNodos(vector,pos_menor,pos_mayor);
% %Función que quita de un vector los elementos dados entre pos_menor y pos_mayor
% if length(vector)==2
%     vector=[]; %Si es de dos, hemos terminado
% else
%     if pos_menor==1
%         vector = vector(pos_mayor+1:end);
%     elseif pos_mayor==length(vector)
%         vector=vector(1:pos_menor-1);
%     else
%         vector=[vector(1:pos_menor-1) vector(pos_mayor+1:end)];
%     end
% end