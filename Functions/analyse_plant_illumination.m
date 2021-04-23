function analyse_plant_illumination(im, verbose)

%   ANALYSE_PLANT_ILLUMINATION analyse any given illuminated plant root
%   image

%   this function goes through both count_green_nuclei and count_cell_walls
%   funtion and return a complete statistical output

    % im - image
    % verbose - 
    %   1 : display all output
    %   0 : suppress intermediate progress output
    
    arguments
        im (:,:,3) uint8 
        verbose (1,1) logical = 0
    end

    fprintf(" \n==== Analyse Plant Illumination ====\n \n");
    
    % analyse nuclei using method 1 (regional max)
    cc1 = count_nuclei(im, verbose);
    label_1 = labelmatrix(cc1);
    rgb_label_1 = label2rgb(label_1, 'spring','c','shuffle'); 

    % analyse nuclei using method 2 (watershed)
    cc2 = count_nuclei_2(im, verbose);
    label_2 = labelmatrix(cc2);
    rgb_label_2 = label2rgb(label_2, 'spring','c','shuffle'); 
    
    % analyse cell wall only (watershed)
    cc3 = count_cells(im, verbose);
    label_3 = labelmatrix(cc3);
    rgb_label_3 = label2rgb(label_3, 'spring','c','shuffle'); 
    
    % plot detected object region
    figure
    set(gcf, 'Position',  [700, 80, 700, 700])
    
    subplottight(2,2,1);
    imshow(im);
    title("Input Image");
    
    subplottight(2,2,3);
    imshow(rgb_label_1, 'border', 'tight');
    title("Detect Nuclei Result with regional max");
    
    subplottight(2,2,2);
    imshow(rgb_label_2, 'border', 'tight');
    title("Detect Nuclei Result with watershed");
    
    subplottight(2,2,4);
    imshow(rgb_label_3, 'border', 'tight');
    title("Detect Cells Result");

    % compute all statistical values with detected components
    % this section will take more time to compute
    whole_statistic(im(:,:,2), cc1, " of Nuclei with Regional Max");
    whole_statistic(im(:,:,2), cc2, " of Nuclei with Watershed");
    whole_statistic(im(:,:,1), cc3, " of Cell Walls with Watershed");
    
    % object detection result
    my_disp("Numbers of nuclei detected with method 1", cc1.NumObjects);
    my_disp("Numbers of nuclei detected with method 2", cc2.NumObjects);
    my_disp("Numbers of cells detected", cc3.NumObjects);
            
end

