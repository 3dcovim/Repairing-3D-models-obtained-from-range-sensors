function [ppp,c2,ventana_grafica]=Representa_Malla(v,f,normales,camara)

scrsz = get(0,'ScreenSize'); %Vemos cuál es el tamaño de la pantalla

if(exist('ventana_grafica','var'))
    close(ventana_grafica);
end

%Dibujamos malla 2

% ventana_grafica=figure('Position',[scrsz(3)/2 scrsz(4)/5 scrsz(3)/2-10 scrsz(4)/2],'color',[1 1 1],'KeyPressFcn',@pulsatecla); %Creamos una figura de tamaño máximo y con fondo blanco
ventana_grafica=figure('Position',[scrsz(3)*0.15 scrsz(4)*0.15 scrsz(3)*0.7 scrsz(4)*0.7],'color',[1 1 1],'KeyPressFcn',@pulsatecla); %Creamos una figura de tamaño máximo y con fondo blanco

opengl hardware;

set(ventana_grafica,'Renderer','OpenGL');
% axis equal
% set(f2,'WVisual','68');
%set(gcf,'KeyPressFcn',@pulsatecla);

hold on;
%camara=get(gca,'CameraPosition');
cla;
set(gcf,'Color',[1 1 1]);%,'Position',[10 258   560   420]);
set(gca,'Visible','off');%,'CameraPosition',camara);
ppp = patch('faces', f, 'vertices' ,v, 'FaceAlpha', 1, 'VertexNormals', normales);

set(ppp, 'facec', 'interp');                                                % Set the face color interp
set(ppp, 'FaceVertexCData', 0.5*ones(length(v),1));                                           % Set the color (from file)
%set(ppp, 'facealpha',.4)                                                 % Use for transparency



% set(ppp, 'EdgeColor','k');
set(ppp, 'EdgeColor','none');




% light('Position',camara,'Style','infinite');
% light('Position',-camara,'Style','infinite');
maximov=max(v);
light('Position',[maximov(1,1) 0 maximov(1,3)/2],'Style','infinite');     % add a default light
light('Position',[-maximov(1,1) 0 maximov(1,3)/2],'Style','infinite');
daspect([1 1 1])                                                        % Setting the aspect ratio
% view(3)
% Isometric view

if(camara.objetivo==0)

    set(gca,'CameraTargetMode','auto');
    set(gca,'CameraPositionMode','auto');
    set(gca,'CameraViewAngleMode','auto');
else
    % view(azim01,elev01);
    set(gca,'CameraTarget',camara.objetivo);
    set(gca,'CameraPosition',camara.posicion);
    set(gca,'CameraViewAngle',camara.angulo);
end



c2 = datacursormode(ventana_grafica);
set(c2,'DisplayStyle','window','SnapToDataVertex','on');
rotate3d on;


datacursormode on;

cameratoolbar('Show');
% cameratoolbar('ToggleSceneLight');
cameramenu;
camlight;
% lighting phong;
lighting gouraud;

shading flat;

drawnow;
