function [vert_recambia]=cambia_sistema_retorno(verticesNew,matriz_trans)

vert_recambia=[];

for indices=1:size(verticesNew,1)
    nueva_coordenada=[verticesNew(indices,:) 1]*inv(matriz_trans);
    vert_recambia=[vert_recambia;nueva_coordenada(1,1:3)];
end
