function ImaRangoSua=detecta_huecos_mask2(ImaNew3,Mascara,elimina_umbral)


noagujeros=0;
Mascara_rell=Mascara;
huecos_mask=cell(1);
indis=1;
ImaRangoSua=ImaNew3;


while (noagujeros==0)
  [filrell,colrell]=find(Mascara_rell==1);
  if(~isempty(filrell))
  BWtemp = bwselect(Mascara_rell,colrell(1,1),filrell(1,1),8);  
  [filtemp,coltemp]=find(BWtemp==1);
  
  huecos_mask{indis,1}=[filtemp coltemp];
  indis=indis+1;
  for indwer=1:length(filtemp)
      Mascara_rell(filtemp(indwer),coltemp(indwer))=0;
  end
  else
      noagujeros=1;
  end
end


Mascara_recons=zeros(size(Mascara));
Mascara_media=zeros(size(Mascara));
Mascara_agujeros=zeros(size(Mascara));
if (cellfun('size',huecos_mask,1)>0)
    for indagu=1:length(huecos_mask)
        hueco=huecos_mask{indagu,1};
        Mascara_agujeros = bwselect(Mascara,hueco(1,2),hueco(1,1),8);
        Mascara_media=imdilate(Mascara_agujeros ,strel('square',25));
        [fff,ccc,vvv]=find((ImaRangoSua.*Mascara_media));
        ImaRangoSua=ImaRangoSua+mean(vvv)*Mascara_agujeros;
        [filar,colar]=find((ImaRangoSua.*Mascara_media)>elimina_umbral*mean(vvv));
        for indero=1:length(filar)
            ImaRangoSua(filar(indero),colar(indero))=mean(vvv);
        end

        %     for indihueco=1:length(hueco)
        %         Mascara_recons(hueco(indihueco,1),hueco(indihueco,2))=1;
        %     end

    end
end