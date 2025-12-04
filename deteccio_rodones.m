% Carregar imatge
img = imread("Fotos\rodones\rodona_partida.png");

% Convertir a escala de grisos i aplicar filtre de mediana per reduir soroll
gray = rgb2gray(img);
gray = medfilt2(gray, [5,5]);

% Determinar si el fons és clar o fosc per escollir el mètode de binarització
bora = [gray(1,:), gray(end,:), gray(:,1)', gray(:,end)'];
mitjana_bora = mean(bora);

if mitjana_bora > 100
    % Fons clar → binarització adaptativa
    bin = imbinarize(gray, 'adaptive', 'Sensitivity', 0.55);
else
    % Fons fosc → binarització global (Otsu)
    nivell = graythresh(gray);
    gray_corr = imadjust(gray, [0.2 0.9], []);
    bin = imbinarize(gray_corr, nivell);
end

% Neteja de soroll i ompliment de forats
bin_clean = bwareaopen(bin, 500); % ← Aquesta versió tracta amb pastilles petites
bin_blister = imfill(bin_clean, 'holes');

% Detecció de contorns
bin_edges = edge(bin_blister, 'Canny');

% Suavitzar els contorns amb operacions morfològiques
se = strel('disk', 13);
edges_dilate = imdilate(bin_edges, se);
edges_closed = imerode(edges_dilate, se);

figure;
imshow(edges_closed);
title('Contorns detectats');

% Eliminar el contorn extern del blíster
labels = bwlabel(edges_closed);
props = regionprops(labels, 'Area', 'BoundingBox');

mask_blister = false(size(labels));
for i = 1:length(props)
    bb = props(i).BoundingBox;
    if bb(3) > 0.9*size(labels,2) && bb(4) > 0.9*size(labels,1)
        mask_blister = mask_blister | labels == i;
    end
end

% Aïllar només les pastilles
mask_pills = edges_closed & ~mask_blister;

% Omplir les regions i suavitzar-les
filled_pills = imfill(mask_pills, 'holes');
pre_pills = filled_pills - mask_pills;
pre_pills = imerode(pre_pills, strel('diamond', 2));  % ← Més suau per conservar pastilles rodones petites

figure;
imshow(pre_pills);
title('Mascara final de pastilles');

% Etiquetar les regions i obtenir propietats geomètriques
[pills, numPills] = bwlabel(pre_pills);
props = regionprops(pills, 'BoundingBox', 'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Area');

% Inicialitzar imatge de sortida i comptadors
Iout = img;
correcta = 0;
defecto = 0;

% Classificar cada pastilla segons forma i mida
for i = 1:numel(props)
    bb = props(i).BoundingBox;
    c = props(i).Centroid;
    ratio = props(i).MajorAxisLength / props(i).MinorAxisLength;
    area = props(i).Area;

    % Pastilla defectuosa si és massa allargada o massa petita
    if ratio > 1.3 || area < 1000
        defecto = defecto + 1;
        Iout = insertShape(Iout, 'Rectangle', bb, 'Color','red', 'LineWidth', 2);
        Iout = insertText(Iout, c, 'Defectuosa', 'BoxColor','red', 'TextColor','white', 'FontSize', 14);
    else
        correcta = correcta + 1;
        Iout = insertShape(Iout, 'Rectangle', bb, 'Color','green', 'LineWidth', 2);
        Iout = insertText(Iout, c, 'Correcte', 'BoxColor','green', 'TextColor','black', 'FontSize', 14);
    end
end

% Afegir avís si falten pastilles
total_detectades = correcta + defecto;
if total_detectades < 10
    Iout = insertText(Iout, [20, 20], 'Blíster incomplet', ...
        'BoxColor','yellow', 'TextColor','black', 'FontSize', 20);
end

% Mostrar resultat final
figure;
imshow(Iout);
title(sprintf('Correctes: %d | Defectuoses: %d', correcta, defecto));
