function cc = count_cells(image, verbose)
%   COUNT_CELL analyse image based on red channel of the image
%   this function will do image enhancement in order for the segmentation
%   to be effective, it will plot out intermediate process and return the
%   connected component struct at the end of the process

    arguments
        image (:,:,3) uint8 
        verbose (1,1) logical = 0
    end

    % split out root cell walls
    red_channel = image(:,:,1);

    % remove salt noise in black open area
    im_blur = medfilt2(red_channel, [3 3]);

    % sharpen image with unsharpening using guassian blur
    % 'Radius' 1 — Standard deviation of the Gaussian lowpass filter
    % 'Amount' 0.8 — Strength of the sharpening effect
    % 'Threshold' 0 — Minimum contrast required for a pixel to be considered an edge pixel
    im_sharp = imsharpen(im_blur, 'Radius', 1, 'Amount', 0.8, 'Threshold', 0);

    % higher the constrast with piecewise linear stretching
    % equivalent to imadjust(I,stretchlim(I))
    % [lower upper] = stretchlim
    % new 0 = intensity <= lower bound, new 255 = intensity >= upper bound
    im_stretch = imadjust(im_sharp);

    % binarize brighten image locally (generate big patch of salt noise)
    im_blackwhite = imbinarize(im_stretch, "adaptive");

    % remove pepper noise within the edge of the cell walls
    se = strel("disk", 2);
    im_pepperless = imclose(im_blackwhite, se);

    % expend edge of cell walls for better segmentation
    se = strel("square", 2);
    im_dilate = imdilate(im_pepperless, se);

    % automatically fill empty border in white
    % written by myself - see autoimfill.m in the same folder
    im_filled = autoimfill(im_dilate);

    % remove cell walls that is too small
    se = strel("square", 5);
    im_shrink = imopen(~im_filled, se);
    
    im_dist = bwdist(~im_shrink, "euclidean");

    lbl = watershed(imcomplement(im_dist));
    im_rgb_seg = label2rgb(lbl,'white','k','shuffle');

    im_seg = im_shrink & im_rgb_seg(:,:,1);
    
    im_seg_op = imopen(im_seg, strel('disk', 2));

    im_seg_bwao = bwareaopen(im_seg_op, 50);

    % display original image along with marking region
    im_fused_original = labeloverlay(image, im_seg_bwao, "Colormap","cool");
    
    % display red channel cell wall image along with marking region
    im_fused_red = labeloverlay(im_stretch, im_seg_bwao, "Colormap","cool");
    
    % calculate and display labeled object
    cc = bwconncomp(im_seg_bwao); 
    
    if verbose
        
        figure
        set(gcf, 'Position',  [500, 60, 700, 700])
        
        subplottight(4,2,1);
        imshow(red_channel,'border', 'tight');
        title("1 Red Channel Image");
        
        subplottight(4,2,3);
        imshow(im_stretch,'border', 'tight');
        title("2 Medianed, sharpened & piecewised");
        
        subplottight(4,2,5);
        imshow(im_blackwhite,'border', 'tight');
        title("3 Binarized cell walls");
        
        subplottight(4,2,7);
        imshow(im_dilate,'border', 'tight');
        title("4 Dilate cell walls");
        
        subplottight(4,2,2);
        imshow(im_filled,'border', 'tight');
        title("5 fill in outer area");
        
        subplottight(4,2,4);
        imshow(im_seg_bwao,'border', 'tight');
        title("6 Remove pepper or small object");
        
        subplottight(4,2,6);
        imshow(im_fused_original,'border', 'tight');
        title("7 Original Image with Marking Region Overlay");
        
        subplottight(4,2,8);
        imshow(im_fused_red,'border', 'tight');
        title("8 Cell wall Image with Marking Region Overlay");
    end
end

