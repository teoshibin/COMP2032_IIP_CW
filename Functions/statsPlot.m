function statsPlot(stats)
    figure
    set(gcf, 'Position',  [800, 50, 700, 700])
    
    subplot(4,4,1);
    histogram(stats.Area);
    title("Area Histogram");
    subplot(4,4,2);
    boxplot(stats.Area);
    title("Area Boxplot");
    
    subplot(4,4,3);
    histogram(stats.Circularity);
    title("Circularity Histogram");
    subplot(4,4,4);
    boxplot(stats.Circularity);
    title("Circularity Boxplot");
    
    subplot(4,4,5);
    histogram(stats.Perimeter);
    title("Perimeter Histogram");
    subplot(4,4,6);
    boxplot(stats.Perimeter);
    title("Perimeter Boxplot");
    
    subplot(4,4,7);
    histogram(stats.MeanIntensity);
    title("MeanIntensity Histogram");
    subplot(4,4,8);
    boxplot(stats.MeanIntensity);
    title("MeanIntensity Boxplot");
    
    subplot(4,4,9);
    histogram(stats.MinIntensity);
    title("MinIntensity Histogram");
    subplot(4,4,10);
    boxplot(stats.MinIntensity);
    title("MinIntensity Boxplot");
    
    subplot(4,4,11);
    histogram(stats.MaxIntensity);
    title("MaxIntensity Histogram");
    subplot(4,4,12);
    boxplot(stats.MaxIntensity);
    title("MaxIntensity Boxplot");
    
    subplot(4,4,13);
    histogram(stats.MinorAxisLength);
    title("MinorAxisLength Histogram");
    subplot(4,4,14);
    boxplot(stats.MinorAxisLength);
    title("MinorAxisLength Boxplot");
    
    subplot(4,4,15);
    histogram(stats.MajorAxisLength);
    title("MajorAxisLength Histogram");
    subplot(4,4,16);
    boxplot(stats.MajorAxisLength);
    title("MajorAxisLength Boxplot");
end

