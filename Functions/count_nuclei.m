function cc = count_nuclei(image, verbose)

    % COUNT_NUCLEI that are within the root illumination figure
    % the region of nuclei is not computed
    % only number of nuclei can be identified
    
    % Input
    % Image - (:,:,3) uint8 matrix
    % verbose - logical scalar
    %   true - display image and outputs
    %   false - silent all
    
    % Steps
    % 1. equalize the image
    % 2. brighten the image
    % 3. reduce image noise with morphology
    % 4. highlight local bright region
    % 5. count & label local bright region
    
    arguments
        image (:,:,3) uint8 
        verbose (1,1) logical = 0
    end
    
    % split out green channel
    green_channel = image(:,:,2);    

    % equalize the intensity before brightening
    im_histeq = adapthisteq(green_channel);

    % brighten the nucleus using local region brightening
    im_brighten = imlocalbrighten(im_histeq);
    
    % round structural elemtent to preserve nucleus round shape
    % morphology opening operation removing salt noise
    se = strel("disk", 5);
    im_saltless = imopen(im_brighten, se);
    
    % get the peak of local region
    im_max = imregionalmax(im_saltless);
        
    % display green channel nuclei image along with marking region
    overlay_1 = labeloverlay(green_channel, im_max, "Colormap","cool", "Transparency", 0.5);
    
    % display original image along with marking region
    overlay_2 = labeloverlay(image, im_max, "Colormap","cool", "Transparency", 0.5);

    % compute connected objects
    cc = bwconncomp(im_max);
        
    if verbose
        
        figure('name', "Nuclei with Regional Max")
        set(gcf, 'Position',  [100, 20, 700, 700]);
        
        subplottight(4,2,1);
        imshow(green_channel,'border', 'tight');
        title("1 Green Channel Image");
        
        subplottight(4,2,3);
        imshow(im_histeq,'border', 'tight');
        title("2 Equalized Nuclei");
        
        subplottight(4,2,5);
        imshow(im_brighten,'border', 'tight');
        title("3 Brighten Nuclei");
        
        subplottight(4,2,7);
        imshow(im_saltless,'border', 'tight');
        title("4 Saltless Nuclei");
        
        subplottight(4,2,2);
        imshow(im_max,'border', 'tight');
        title("5 Nuclei Marking Region");
        
        subplottight(4,2,4);
        imshow(overlay_1,'border', 'tight');
        title("6 green channel with overlay");
        
        subplottight(4,2,6);
        imshow(overlay_2,'border', 'tight');
        title("7 RGB with overlay");
        
    end
    
end
