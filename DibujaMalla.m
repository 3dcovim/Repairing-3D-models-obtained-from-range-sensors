function p=DibujaMalla(V,F,C,numero_figura,normales)
% DibujaMalla dibuja la malla dada por las siguientes variables de entrada:
%   -> V: matriz nx3 de coordenadas de los vértices de la malla
%   -> F: matriz mx3 con los índices de los vertices que forman cada patch
%   -> C: matriz nx1 ó nx3 con el color asociado a cada vértice
%   ->numero_figura: número de figura en donde se dibujará la malla
%   ->normales: normales de los vertices de la malla (opcional)
%--------------------------------------------------------------------------
% DibujaMalla(V,F,C,numero_figura)

figure(numero_figura)
hold on
camara=get(gca,'CameraPosition');
cla
set(gcf,'Color',[1 1 1]);%,'Position',[10 258   560   420]);
set(gca,'Visible','off');%,'CameraPosition',camara);
if nargin==4
    p = patch('faces', F, 'vertices' ,V, 'FaceAlpha', 1);
else
    p = patch('faces', F, 'vertices' ,V, 'FaceAlpha', 1, 'VertexNormals', normales);
end
set(p, 'facec', 'interp');                                                % Set the face color interp
set(p, 'FaceVertexCData', C);                                           % Set the color (from file)
%set(p, 'facealpha',.4)                                                 % Use for transparency
set(p, 'EdgeColor','none');
% light('Position',camara,'Style','infinite');
% light('Position',-camara,'Style','infinite');
%light('Position',[max(V(:,1)) 0 max(V(:,3))/2],'Style','infinite');     % add a default light
%light('Position',[-max(V(:,1)) 0 max(V(:,3))/2],'Style','infinite');
daspect([1 1 1])                                                        % Setting the aspect ratio
% view(3)                                                                 % Isometric view
drawnow