function plano=Representa_Plano(nube_puntos,v_normal,densidad,color)

cdg_proy=mean(nube_puntos);
punto_plano=cdg_proy;

a = v_normal(1,1);
b = v_normal(1,2);
c = v_normal(1,3);
d = -dot([punto_plano],v_normal);
% densidad=8;
% [xx,yy,zz] = meshgrid(min(p_ini(:,1)):0.1:max(p_ini(:,1)), min(p_ini(:,2)):0.1:max(p_ini(:,2)), min(p_ini(:,3)):0.1:max(p_ini(:,3)));
% [xx,yy,zz] = meshgrid(linspace(min(p_ini(:,1)),max(p_ini(:,1)),densidad),linspace(min(p_ini(:,2)),max(p_ini(:,2)),densidad),linspace(min(p_ini(:,3)),max(p_ini(:,3)),densidad));
% [xx,yy] = meshgrid(linspace(min(p_ini(:,1)),max(p_ini(:,1)),densidad),linspace(min(p_ini(:,2)),max(p_ini(:,2)),densidad));
% zz=ones(size(xx));
% [xx,yy,zz] = meshgrid(linspace(min(min(p_ini)),max(max(p_ini)),densidad),linspace(min(min(p_ini)),max(max(p_ini)),densidad),linspace(min(min(p_ini)),max(max(p_ini)),densidad));

% extremo=max([max(nube_puntos(:,1))-min(nube_puntos(:,1)) max(nube_puntos(:,2))-min(nube_puntos(:,2)) max(nube_puntos(:,3))-min(nube_puntos(:,3))]);
% [xx,yy,zz] = meshgrid(linspace(punto_plano(1,1)-extremo/2,punto_plano(1,1)+extremo/2,densidad),linspace(punto_plano(1,2)-extremo/2,punto_plano(1,2)+extremo/2,densidad),linspace(punto_plano(1,3)-extremo/2,punto_plano(1,3)+extremo/2,densidad));


extremo_xx=1.35*(max(nube_puntos(:,1))-min(nube_puntos(:,1)));
extremo_yy=1.35*(max(nube_puntos(:,2))-min(nube_puntos(:,2)));

[xx,yy] = meshgrid(linspace(cdg_proy(1,1)-extremo_xx/2,cdg_proy(1,1)+extremo_xx/2,densidad),linspace(cdg_proy(1,2)-extremo_yy/2,cdg_proy(1,2)+extremo_yy/2,densidad));
zz=(-a*xx-b*yy-d)/c;
% mesh(xx,yy,zz);
plano=surf(xx,yy,zz);
set(plano,'FaceColor',color);