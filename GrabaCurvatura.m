function GrabaCurvatura(vertices,caras,nombre)

options.curvature_smoothing = 10;
options.verb = 0;
[Umin,Umax,Cmin,Cmax,Cmean,Cgauss,Normal] = compute_curvature(vertices,caras,options);
figure(10);
subplot(1,2,1);
options.face_vertex_color = perform_saturation(Cgauss,1.2);
plot_mesh(vertices,caras, options); shading interp; colormap jet(256);
title('Gaussian curvature');
subplot(1,2,2);
options.face_vertex_color = perform_saturation(abs(Cmin)+abs(Cmax),1.2);
plot_mesh(vertices,caras, options); shading interp; colormap jet(256);
title('Total curvature');
saveas(10,[nombre '.fig']);
saveas(10,[nombre '.jpg']);
close(10);
save(nombre,'Umin','Umax','Cmin','Cmax','Cmean','Cgauss','Normal');

end
