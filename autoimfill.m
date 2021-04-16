function out_image = autoimfill(image)
    
    % Automatically predict empty space and flood fill white
    
    % n = number of locations generated from each side
    % so the total number of locations generated is n * 4
    % use one percent of the min pixel dimansion to decide number of locations needed
    n = ceil(min(width(image), height(image))*0.01);
    
    locations = get_imfill_locations(image, n, n*2);
    out_image = image;
    for j = 1:height(locations)
        out_image = imfill(out_image, locations(j,:));
    end
    
end


% === Helper Functions ===

function locations = get_imfill_locations(image, location_count_per_side, thickness)
    
    % get random location that is not within the object 
    
    % image - input image for selection of locations
    % n - number of locations generated for each side of the edge
    % thickness - sample size of edge (for detecting object touching the edge)

    arguments
        image (:,:,1) logical
        location_count_per_side (1,1) double {mustBePositive, mustBeInteger} = 3
        thickness (1,1) double {mustBePositive, mustBeInteger} = 1
    end
    
    % coordinates for imfill
    locations = zeros(location_count_per_side*4, 2);
    
    % remove pixel that connect less than 3 pixel in all direction
    se = strel("square", 3); 
    image = imopen(image ,se);
    
    % loop 4 sides
    sides = ["left", "right", "top", "bottom"];
    for j = 1:length(sides)
        
        % crop and sample down the edge
        edge = get_edge(image, sides(j), thickness);
        % predict contact area
        contact_edge = get_contact_edge(edge);
        % get index positions for each side using predected contact area
        positions = get_random_none_contact_pixel(contact_edge, location_count_per_side);
        
        % put calculated positions (1d index from each side) to locations (2d coordinates)
        switch sides(j)
            case 'left'
                locations( location_count_per_side*(j-1) + 1 : location_count_per_side*j, 1) = positions;
                locations( location_count_per_side*(j-1) + 1 : location_count_per_side*j, 2) = 1;
            case 'right'
                locations( location_count_per_side*(j-1) + 1 : location_count_per_side*j, 1) = positions;
                locations( location_count_per_side*(j-1) + 1 : location_count_per_side*j, 2) = width(image);
            case 'top'
                locations( location_count_per_side*(j-1) + 1 : location_count_per_side*j, 1) = 1;
                locations( location_count_per_side*(j-1) + 1 : location_count_per_side*j, 2) = positions;
            case 'bottom'
                locations( location_count_per_side*(j-1) + 1 : location_count_per_side*j, 1) = height(image);
                locations( location_count_per_side*(j-1) + 1 : location_count_per_side*j, 2) = positions;
            otherwise
        end
    end
    
    % remove duplicated and zeros locations
    locations = clean_up_locations(locations);
end

function clean_locations = clean_up_locations(locations)

    % remove duplicated and value zero locations

    for j = 1:height(locations)
        if locations(j,1) == 0 || locations(j,2) == 0
            locations(j,:) = 0;
        end
    end
    
    clean_locations = reshape(locations(locations ~= 0), [], 2);
    clean_locations = unique(clean_locations, "rows");
end

function edge = get_edge(image, side, thickness)
    
    % Return a vector edge that is cropped and sampled down from a thick edge

    % image - input image
    % side - side of edge
    % thickness - thickness of sampled thick edge
    
    arguments
        image (:,:,1) logical
        side (1,:) char {mustBeMember(side,{'left','right','top','bottom'})}
        thickness (1,1) double {mustBePositive, mustBeInteger} = 1
    end
    
    % crop out edge of image with certain thickness
    switch side
        case 'left'
            thick_edge = image(:,1:thickness);
        case 'right'
            thick_edge = image(:,end-thickness+1:end);
        case 'top'
            thick_edge = image(1:thickness,:);
        case 'bottom'
            thick_edge = image(end-thickness+1:end,:);
    end
    
    % merge thick edge into 1 row or 1 column line
    switch side
        case {'left', 'right'}
            edge = false([height(image) 1]);
            for j = 1:thickness
                edge = or(edge, thick_edge(:, j));
            end
        case {'top', 'bottom'}
            edge = false([1 width(image)]);
            for j = 1:thickness
                edge = or(edge, thick_edge(j, :));
            end
    end
end

function contact_edge = get_contact_edge(edge)
    
    % Return logical vector that links 2 outer pixels
    
    % to detect object that is touching the edge of the image
    
    % === example here ===
    % input         = 0   0   1   0   1   0
    % edge_set      = 0   0   1   1   1   1
    % rev_edge_set  = 1   1   1   1   1   0
    % out           = 0   0   1   1   1   0
    %  out : And operation of both edge set

    edge_set = set_true_after_first_true(edge);
    reverse_edge_set = flip(set_true_after_first_true(flip(edge)));
    contact_edge = and(edge_set, reverse_edge_set);
    
end

function out_vector = set_true_after_first_true(vector)

    % set all bits after the first true bit to true
    % input     = 0 1 0 0
    % output    = 0 1 1 1

    h = height(vector);
    w = width(vector);
    index = find(vector == 1, 1);
    if h > w
        out_vector = [false([index-1 1]); true([h-index+1 1])];
    else
        out_vector = [false([1 index-1]) true([1 w-index+1])];
    end
end

function selection = get_random_none_contact_pixel(vector, n)
    
    % Return a vector of indexes from elements in vector that contains zero randomly

    % n - number of selections needed
    % vector - input
    
    selection = zeros(n,1);
    index_false_vector = find(vector ~= 1);
    if height(index_false_vector) > width(index_false_vector)
        index_false_vector = transpose(index_false_vector);
    end
    length = numel(index_false_vector);
    number_iteration = min(length, n);
    for j = 1:number_iteration
        random_index = round(rand*(length-1)) + 1;
        selection(j, 1) = index_false_vector(1, random_index);
    end
end
