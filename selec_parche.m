function varargout = selec_parche(varargin)
% SELEC_PARCHE M-file for selec_parche.fig
%      SELEC_PARCHE, by itself, creates a new SELEC_PARCHE or raises the existing
%      singleton*.
%
%      H = SELEC_PARCHE returns the handle to a new SELEC_PARCHE or the handle to
%      the existing singleton*.
%
%      SELEC_PARCHE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELEC_PARCHE.M with the given input arguments.
%
%      SELEC_PARCHE('Property','Value',...) creates a new SELEC_PARCHE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selec_parche_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selec_parche_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selec_parche

% Last Modified by GUIDE v2.5 04-Jul-2011 01:57:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @selec_parche_OpeningFcn, ...
    'gui_OutputFcn',  @selec_parche_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end



% End initialization code - DO NOT EDIT


% --- Executes just before selec_parche is made visible.
function selec_parche_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selec_parche (see VARARGIN)

% Choose default command line output for selec_parche
handles.output = hObject;
handles.vertices = varargin {1};
handles.caras = varargin {2};
handles.normales = varargin {3};
handles.borde_hueco = varargin {4};
handles.extension_parche  = varargin {5};
handles.cmax  = varargin {6};
handles.camara= varargin {7};
handles.matriztrans= varargin {8};
handles.normal_puntos= varargin {9};
handles.parte= varargin {10};
handles.image_interp = varargin(11);

handles.malla= -1;
handles.puntos= -1;
handles.output = 0;
% handles.calculada=0;
handles.factor_limite=0;
handles.curvatura=0;
handles.plano_proy=0;
handles.visualizacion.aristas=1;
handles.modo_sh='Flat';
handles.modo_li='None';




% scrsz = get(0,'ScreenSize'); %Vemos cuál es el tamaño de la pantalla

set(handles.figure1,'Position',[25 25 205 46]);
cameratoolbar('Show');

opengl hardware;

if(handles.puntos~=-1)
    delete(handles.puntos);
end
set(handles.slider1,'Value',handles.extension_parche);
set(handles.slider2,'Value',handles.cmax);
set(handles.checkbox3,'Value',1);
set(handles.checkbox3,'Value',0);
set(handles.pushbutton1,'Enable','off');


%%%% determinación de los grados de vecindad necesarios para que , a partir
%%%% de un borde de hueco dado se cubra la malla completa
pasos=1;
indice=1;
while(pasos<(length(handles.vertices)-sum((1:round(length(handles.borde_hueco)/6))*6)))
    pasos=pasos+6*indice;
    indice=indice+1;
end




set(handles.slider1,'Max',indice);

set(handles.edit1,'String',num2str(handles.extension_parche));



set(handles.edit2,'String',num2str(handles.cmax));
[handles.vertices_parche,handles.caras_parche]=define_parche2(handles.vertices,handles.caras,handles.normales,handles.borde_hueco,handles.extension_parche,handles.cmax,handles.factor_limite);


set(handles.axes1,'Visible','off');%,'CameraPosition',camara);

axes(handles.axes1);
if(handles.malla==-1)
    handles.malla = patch('faces', handles.caras, 'vertices' ,handles.vertices, 'FaceAlpha', 1, 'VertexNormals', handles.normales);
    set(handles.malla, 'facec', 'interp');                                                % Set the face color interp
    set(handles.malla, 'FaceVertexCData', 0.5*ones(length(handles.vertices),1));                                           % Set the color (from file)
    
    maximov=max(handles.vertices);
    %     light('Position',[maximov(1,1) 0 maximov(1,3)/2],'Style','infinite');     % add a default light
    light('Position',[-maximov(1,1) 0 maximov(1,3)/2],'Style','infinite');
    daspect([1 1 1]);
    if(handles.camara.objetivo==0)
        set(handles.axes1,'CameraTargetMode','auto');
        set(handles.axes1,'CameraPositionMode','auto');
        set(handles.axes1,'CameraViewAngleMode','auto');
    else
        
        set(handles.axes1,'CameraTarget',handles.camara.objetivo);
        set(handles.axes1,'CameraPosition',handles.camara.posicion);
        set(handles.axes1,'CameraViewAngle',handles.camara.angulo);
    end
    
    
    
    
    hold on;
    %     hhh3=rotate3d;
    cameratoolbar('SetMode','orbit');
    camlight;
    % lighting phong;
    % lighting gouraud;
    lighting none;
    shading flat;
    set(handles.malla, 'EdgeColor','k');
    
    drawnow;
end

handles.puntos=plot3(handles.vertices(handles.vertices_parche,1),handles.vertices(handles.vertices_parche,2),handles.vertices(handles.vertices_parche,3),'r.');
% setAllowAxesRotate(hhh3,handles.axes1,true);
%
% setAllowAxesRotate(hhh3,handles.axes2,false);


% Update handles structure
guidata(hObject, handles);



% UIWAIT makes selec_parche wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = selec_parche_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if(handles.puntos~=-1)
    delete(handles.puntos);
end
handles.extension_parche=double(uint8(get(gcbo,'Value')));
set(handles.edit1,'String',num2str(handles.extension_parche));
[handles.vertices_parche,handles.caras_parche]=define_parche2(handles.vertices,handles.caras,handles.normales,handles.borde_hueco,handles.extension_parche,handles.cmax,handles.factor_limite);
axes(handles.axes1);
handles.puntos=plot3(handles.vertices(handles.vertices_parche,1),handles.vertices(handles.vertices_parche,2),handles.vertices(handles.vertices_parche,3),'r.');
guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
if(handles.puntos~=-1)
    delete(handles.puntos);
end
handles.extension_parche=double(uint8(str2num(get(gcbo,'String'))));
set(handles.slider1,'Value',num2str(handles.extension_parche));
[handles.vertices_parche,handles.caras_parche]=define_parche2(handles.vertices,handles.caras,handles.normales,handles.borde_hueco,handles.extension_parche,handles.Cmax,handles.factor_limite);
axes(handles.axes1);
handles.puntos=plot3(handles.vertices(handles.vertices_parche,1),handles.vertices(handles.vertices_parche,2),handles.vertices(handles.vertices_parche,3),'r.');
guidata( hObject, handles );



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = 1;

guidata( hObject, handles );


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

if(handles.puntos~=-1)
    delete(handles.puntos);
end
handles.factor_limite=double(uint8(get(gcbo,'Value')));
set(handles.edit2,'String',num2str(handles.factor_limite));
if(~handles.curvatura)
    handles=calcula_curvatura(hObject, handles);
    
end

[handles.vertices_parche,handles.caras_parche]=define_parche2(handles.vertices,handles.caras,handles.normales,handles.borde_hueco,handles.extension_parche,handles.cmax,handles.factor_limite);

axes(handles.axes1);
handles.puntos=plot3(handles.vertices(handles.vertices_parche,1),handles.vertices(handles.vertices_parche,2),handles.vertices(handles.vertices_parche,3),'r.');


guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
if(handles.puntos~=-1)
    delete(handles.puntos);
end

handles.factor_limite=double(uint8(str2num(get(gcbo,'String'))));
set(handles.slider2,'Value',num2str(handles.factor_limite));
if(~handles.curvatura)
    handles=calcula_curvatura(hObject, handles);
    
end
[handles.vertices_parche,handles.caras_parche]=define_parche2(handles.vertices,handles.caras,handles.normales,handles.borde_hueco,handles.extension_parche,handles.cmax,handles.factor_limite);
axes(handles.axes1);
handles.puntos=plot3(handles.vertices(handles.vertices_parche,1),handles.vertices(handles.vertices_parche,2),handles.vertices(handles.vertices_parche,3),'r.');



guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
if(get(gcbo,'Value'))
    if(~handles.curvatura)
        handles=calcula_curvatura(hObject, handles)
        
    end
    % handles.curvatura=plot_mesh(handles.vertices,handles.caras, handles.options);
    axes(handles.axes1);
    handles.curvatura = patch('vertices',handles.vertices,'faces',handles.caras,'FaceVertexCData',handles.options.face_vertex_color, 'FaceColor','interp');
    shading interp;
    colormap jet(256);
else
    if(handles.curvatura)
        delete(handles.curvatura);
    end
end
if(handles.visualizacion.aristas)
    set(handles.malla, 'EdgeColor','k');
else
    set(handles.malla, 'EdgeColor','none');
end

guidata( hObject, handles );

function handles=calcula_curvatura(hObject, handles)
handles.options.curvature_smoothing = 10;
handles.options.verb = 0;
[Umin,Umax,Cmin,Cmax,Cmean,Cgauss,Normal] = compute_curvature(handles.vertices,handles.caras,handles.options);
% options.face_vertex_color = perform_saturation(Cgauss,1.2);

handles.cmin=Cmin;
handles.cmax=Cmax;
% hold on;
% plot_mesh(handles.vertices,handles.caras, options);
% shading interp; colormap jet(256);
handles.options.face_vertex_color = perform_saturation(abs(Cmin)+abs(Cmax),1.2);
guidata( hObject, handles );


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vertices_eleg=handles.vertices(handles.vertices_parche,:); %% Coordenadas de los vertices de la porción de malla.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%BARRA DE ESPERA
%     if (automatico==0)
%         barra_espera = waitbar(0,'Rellenando...');
%         steps = 4;
%     end
%%%%%FIN DE BARRA DE ESPERA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%% Se cambia el sistema de referencia de los vértices que componen la
%%%% porción de malla extraída. Se recalcula la lista de caras en
%%%% referencia a la lista de vértices que componen dicha porción.
[handles.vertices_trans,handles.nuevas_caras2,handles.traduce_caras,handles.matriz_trans]=cambia_sistema(vertices_eleg,handles.caras_parche,handles.normal_puntos,handles.vertices_parche,handles.caras,handles.matriztrans);
[filun,colun]=find(handles.traduce_caras==handles.borde_hueco(1,2));
punto_traducido=handles.nuevas_caras2(filun(1,1),colun(1,1));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%BARRA DE ESPERA
%     if (automatico==0)
%         waitbar(1 / steps);
%     end
%%%%%FIN DE BARRA DE ESPERA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Se aplica una nueva transformación a la malla. Se ha de
%%%% desplazarla a niveles cercanos al plano (a cero). Se referencian
%%%% con respecto a un máximo (amplificación). Se desplazan un
%%%% infinitesimal para que ningun punto alcance el valor 0 de
%%%% profundidad.
handles.vector_trans=min(handles.vertices_trans);
unidad=[1 1 1];
amplificacion=1;
desplazamiento=1e-15;
handles.vertices_seccion2=amplificacion*(handles.vertices_trans-handles.vector_trans(ones(length(handles.vertices_trans),1),:))+desplazamiento*unidad(ones(length(handles.vertices_trans),1),:);

%     tiempo_parche=toc; %% FIN CALCULO DEL TIEMPO DE EXTRACCION DE LA PORCION DE MALLA

%%%% INICIO GRABACION DATOS EN HOJA EXCEL
%     if(general_excel)
%         M={'T.parche',tiempo_parche};
%         [status, message] = xlswrite([path_mallas fichero_excel], M, nombre_malla,['A' num2str(indica_hoja)]);
%         eval('!taskkill /F /IM EXCEL.EXE');
%         indica_hoja=indica_hoja+1;
%     end
%     %%%% FIN GRABACION DATOS EN HOJA EXCEL
%
%     tic;%% INICIO CALCULO DEL TIEMPO DE GENERACION DE LA IMAGEN DE RANGO

%%%% Se calcula la imagen de rango correspondiente a la proyección de
%%%% la porción de malla sobre el plano Z=0. Por otra parte se
%%%% determina la mascara de los agujeros de dicha porción.
[handles.ImaRanInterp,handles.celdasX,handles.celdasY,handles.mascarapol2,handles.agujeros,handles.agujero_actual,handles.minimanew,handles.caras_rango,resolucion]=genera_imagen_rango2(handles.vertices_seccion2,handles.nuevas_caras2,handles.parte,handles.borde_hueco(1,1),punto_traducido,cell2mat(handles.image_interp));




axes(handles.axes2);
imshow((handles.ImaRanInterp-min(min(handles.ImaRanInterp)))/max(max(handles.ImaRanInterp)));
% sc((handles.ImaRanInterp-min(min(handles.ImaRanInterp)))/max(max(handles.ImaRanInterp)),'gray');
set(handles.pushbutton1,'Enable','on');


guidata( hObject, handles );


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
modos={['Flat'];['Faceted'];['Interp']};
handles.modo_sh=modos{get(gcbo,'Value')};
shading(handles.axes1,handles.modo_sh);
if(handles.visualizacion.aristas)
    set(handles.malla, 'EdgeColor','k');
else
    set(handles.malla, 'EdgeColor','none');
end
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6
modos={['None'];['Flat'];['Gouraud']};
handles.modo_li=modos{get(gcbo,'Value')};
lighting(handles.axes1,handles.modo_li);
if(handles.visualizacion.aristas)
    set(handles.malla, 'EdgeColor','k');
else
    set(handles.malla, 'EdgeColor','none');
end
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
handles.visualizacion.aristas=get(handles.checkbox3,'Value');
if(handles.visualizacion.aristas)
    set(handles.malla, 'EdgeColor','k');
else
    set(handles.malla, 'EdgeColor','none');
end
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton2.
function pushbutton2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(gcbo,'Value'))
    if(~handles.plano_proy)
        load datos_proy.mat;
        p_proy=[];
        v_normal=v_ini(:,3)';
        
        punto_plano=cdg+(normales(borde_hueco(1,1),:).*(max(p_ini(:,3))-min(p_ini(:,3))).*1.25);
        for indol=1:length(p_ini)
            p_proy=[p_proy;p_ini(indol,:)+((-(dot(p_ini(indol,:),v_normal)-dot([punto_plano],v_normal))/sqrt(norm(v_normal))).*v_normal)];
        end
        axes(handles.axes1);
        handles.contorno=plot3(p_proy(:,1),p_proy(:,2),p_proy(:,3),'r');
        hold on;
        densidad=8;
        color=[1 0.69 0.39];
        handles.plano_proy=Representa_Plano(p_proy,v_normal,densidad,color);
        
    else
        set(handles.contorno,'Visible','on');
        set(handles.plano_proy,'Visible','on');
    end
    
else
    if(handles.plano_proy)
        %         delete(handles.contorno);
        %         delete(handles.plano_proy);
        set(handles.contorno,'Visible','off');
        set(handles.plano_proy,'Visible','off');
    end
end

guidata( hObject, handles );

% Hint: get(hObject,'Value') returns toggle state of checkbox4
