function out = calculate_statistic(stats)

%CALCULATE_STATISTIC calculate statistic value of any given data
%   calculate mean, median, standard deviation for 1d vector stats
%   calculate all the above and extra mean, min max value for n-by-2 paired
%   stats

    arguments
        stats (:,:) double
    end

    switch width(stats)
        case 1
            mean_value = mean(stats);
            median_value = median(stats);
            deviation = std(stats);
            varience = deviation^2;
            
            out = struct(...
                "mean", mean_value, ...
                "median", median_value, ...
                "StandardDeviation", deviation, ...
                "Varience", varience ...
                );
            
        case 2
            
            individual_mean = mean(stats, 2);
            minor_mean = mean(stats(:,1));
            major_mean = mean(stats(:,2));
            population_mean = mean(individual_mean);
            
            minor_median = median(stats(:,1));
            major_median = median(stats(:,2));
            population_median = median(individual_mean);
            
            min_minor = min(stats(:,1));
            max_minor = max(stats(:,1));
            min_major = min(stats(:,2));
            max_major = max(stats(:,2));
                        
            deviation = std(individual_mean);
            varience = deviation^2;
            
            out = struct(...
                "IdividualMean", individual_mean, ...
                "MinorMean", minor_mean, ...
                "MajorMean", major_mean, ...
                "PopulationMean", population_mean, ...
                "MinorMedian", minor_median, ...
                "MajorMedian", major_median, ...
                "PopulationMedian", population_median, ...
                "MinorMinimum", min_minor, ...
                "MinorMaximum", max_minor, ...
                "MajorMinimum", min_major, ...
                "MajorMaximum", max_major, ...
                "StandardDeviation", deviation, ...
                "Varience", varience ...
                );
            
    end
        
end

