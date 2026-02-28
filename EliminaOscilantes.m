function caraseditadas=EliminaOscilantes(caras)

% carasr=[caras(:,1:2) caras(:,2:3) caras(:,3) caras(:,1)]; %Creo la matriz de índices
% aristas=reshape(carasr',2,[])'; %y reordeno, de tal forma que cada fila es un par de aristas.
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
arist_repeticion=reshape(repeticion2,size(caras,1),3);
[filelim,colelim]=find(sum(arist_repeticion,2)==4);
caraseditadas=caras;
caraseditadas(filelim,:)=[];


