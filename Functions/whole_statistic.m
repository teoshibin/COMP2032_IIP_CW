function [stats, area_stats, circularity_stats, ...
    perimeter_stats, mean_intensity_stats, ...
    intensity_stats, length_stats] = whole_statistic(gray_im, cc, msg)
    % compute all statistical values with detected components
    % this section will take more time to compute
    
    stats = regionprops('table', cc, gray_im, ...
        "Area", "Circularity", ...
        "Perimeter", "MaxIntensity", ...
        "MeanIntensity", "MinIntensity", ...
        "MajoraxisLength", "MinoraxisLength");

    % display all properties
    my_disp("Statistical Analysis" + msg, stats);
        
    % calculate all statistical analysis
    area_stats = calculate_statistic(stats.Area);
    my_disp("Area Stats", area_stats);
    
    circularity_stats = calculate_statistic(stats.Circularity);
    my_disp("Cicularity Stats", circularity_stats);
    
    perimeter_stats = calculate_statistic(stats.Perimeter);
    my_disp("Perimeter Stats", perimeter_stats);
    
    mean_intensity_stats = calculate_statistic(stats.MeanIntensity);
    my_disp("Local Region Mean Intensity Stats",mean_intensity_stats);
    
    intensity_stats = calculate_statistic([stats.MinIntensity stats.MaxIntensity]);
    my_disp("Min & Max Intensity Stats", intensity_stats);
    
    length_stats = calculate_statistic([stats.MinorAxisLength stats.MajorAxisLength]);
    my_disp("Min & Max Length Stats",length_stats);
    
    statsPlot(stats);
    
end

