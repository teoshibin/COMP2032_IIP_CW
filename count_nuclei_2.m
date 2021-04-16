function cc = count_nuclei_2(image, verbose)
%COUNT_NUCLEI_2 Summary of this function goes here
%   Detailed explanation goes here

    arguments
        image (:,:,3) uint8 
        verbose (1,1) logical = 0
    end

    gc = image(:,:,2);
    
    im_ad = imadjust(gc);

    im_med = medfilt2(im_ad, [3 3]);

    im_ave = imfilter(im_med, fspecial("average", 3));

    im_shp = imsharpen(im_ave);

    T = pieceWiseLinear([30, 64], [255 255]); % plot T to see transformation graph
    im_pwl = T(im_shp + 1);

    marker = imerode(im_pwl, strel('disk', 1));

    im_rct = imreconstruct(marker, im_pwl);

    im_bnr = imbinarize(im_rct, "adaptive");

    im_dist = bwdist(~im_bnr, "euclidean");

    lbl = watershed(imcomplement(im_dist));
    im_rgb_seg = label2rgb(lbl,'white','k','shuffle');

    im_seg = im_bnr & im_rgb_seg(:,:,1);

    im_seg_op = imopen(im_seg, strel('disk', 2));

    im_seg_bwao = bwareaopen(im_seg_op, 50);

    cc = bwconncomp(im_seg_bwao);
    
    if verbose
        
        figure
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
        imshow(labeloverlay(im_pwl, im_seg_bwao, "Colormap","cool", "Transparency", 0.5));
        title("9 overlay");
        
        subplottight(5,2,10);
        imshow(labeloverlay(image, im_seg_bwao, "Colormap","cool", "Transparency", 0.5));
        title("10 overlay");
    end
    
end

