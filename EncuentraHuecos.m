function h_modify=EncuentraHuecos(caras,vertices,dibujar,num_h_rellenar)

% h=Findholes(caras,vertices,dibujar);
h=FindHoles3(caras);
%%%% solo se procesan los agujeros que tienen mas de 5 vertices
[filuj,coluj]=find(cellfun('length',h)>num_h_rellenar);
h_modify=[];
for ijuy=1:length(coluj)
    h_modify{1,ijuy}=h{1,coluj(ijuy)};
end

end
