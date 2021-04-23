function cc = count_nuclei_2(image, verbose)
% get connected components using watershed method on nuclei

    arguments
        image (:,:,3) uint8 
        verbose (1,1) logical = 0
    end

    % green channel
    gc = image(:,:,2);
    
    % brighten image
    im_ad = imadjust(gc);

    % denoise
    im_med = medfilt2(im_ad, [3 3]);

    % denoise
    im_ave = imfilter(im_med, fspecial("average", 3));

    % compensate the blur introduced by denoise function
    im_shp = imsharpen(im_ave);

    % brighten image
    T = pieceWiseLinear([30, 64], [255 255]); % plot T to see transformation graph
    im_pwl = T(im_shp + 1);

    % get seed
    marker = imerode(im_pwl, strel('disk', 1));

    % use marker seed to reconstruct image
    im_rct = imreconstruct(marker, im_pwl);

    % threshold image
    im_bnr = imbinarize(im_rct, "adaptive");

    % distance transformation for segmentation
    im_dist = bwdist(~im_bnr, "euclidean");

    % watershed segmentation
    lbl = watershed(imcomplement(im_dist));
    im_rgb_seg = label2rgb(lbl,'white','k','shuffle');

    % merge original image with watershed label image
    im_seg = im_bnr & im_rgb_seg(:,:,1);

    % opening to remove small region
    im_seg_op = imopen(im_seg, strel('disk', 2));

    % area open to remove small region
    im_seg_bwao = bwareaopen(im_seg_op, 50);

    % return connected components
    cc = bwconncomp(im_seg_bwao);
    
    % for displaying image with overlay
    overlay_1 = labeloverlay(im_pwl, im_seg_bwao, "Colormap","cool", "Transparency", 0.5);
    overlay_2 = labeloverlay(image, im_seg_bwao, "Colormap","cool", "Transparency", 0.5);
    
    if verbose
        
        figure('name', "Nuclei with Watershed")
        set(gcf, 'Position',  [300, 40, 700, 700]);
        
        subplottight(5,2,1);
        imshow(gc,'border', 'tight');
        title("1 Green Channel Image");
        
        subplottight(5,2,3);
        imshow(im_shp,'border', 'tight');
        title("2 medianed, averaged, unsharpened image");
        
        subplottight(5,2,5);
        imshow(im_pwl,'border', 'tight');
        title("3 piecewiselineared bright image");
        
        subplottight(5,2,7);
        imshow(marker,'border', 'tight');
        title("4 marker for reconstruction image");
        
        subplottight(5,2,9);
        imshow(im_rct,'border', 'tight');
        title("5 reconstructed noiseless image");
        
        subplottight(5,2,2);
        imshow(im_bnr,'border', 'tight');
        title("6 binarized image");
        
        subplottight(5,2,4);
        imshow(im_dist, [],'border', 'tight');
        title("7 distance transformation");
        
        subplottight(5,2,6);
        imshow(im_seg_bwao, [],'border', 'tight');
        title("8 watershed");
        
        subplottight(5,2,8);
        imshow(overlay_1, 'border', 'tight');
        title("9 green channel with overlay");
        
        subplottight(5,2,10);
        imshow(overlay_2, 'border', 'tight');
        title("10 RGB with overlay");
    end
    
end

