% colour_pallete(img_path, colours_number)
%
%       The function returns a color palette 
%       with the specified number of colors 
%       for a given image.
%
%       Example: colour_palette('autumn.tif', 16)

function palette = colour_palette(img_path, colours_number)
    img = imread(img_path);
    [size_x, size_y] = size(img(:,:,1));
    img_colours_number = size_x * size_y;
    if img_colours_number <= colours_number
        palette = img;
    return;
    end
    flatten_img = get_flatten_img(img, size_x, size_y);
    max_depth = ceil(log2(colours_number));
    palette = get_colours_palette(flatten_img, max_depth, 0, []);
end

% The function splits a flatten image recursively into two parts 
% until the maximum depth is reached; 
% at maximum depth returns the mean of the colors in the flatten image.
function palette = get_colours_palette(flatten_img, max_depth, depth, palette)
    if depth == max_depth 
        if size(palette)==0
            palette = [palette, get_mean(flatten_img)];
            return;
        end
        palette(end+1, [1,2,3]) = get_mean(flatten_img);
        return;
    end
    max_range_index = get_max_range_index(flatten_img);
    [flatten_img_1, flatten_img_2] = split_by_max_range(max_range_index, flatten_img);
    palette = get_colours_palette(flatten_img_1, max_depth, depth+1, palette);
    palette = get_colours_palette(flatten_img_2, max_depth, depth+1, palette);
end

% The function returns an array with elements [R, G, B, x_position, y_position].
% The array can be used to create a new image with a given number of colours.
function flatten_img = get_flatten_img(img, size_x, size_y)
    index = 1;
    flatten_img = zeros(size_x*size_y, 5);
    for x = 1:size_x
        for y = 1:size_y
            flatten_img(index, [1 2 3 4 5]) = [img(x,y,1), img(x,y,2), img(x,y,3), x, y];
            index = index + 1;
        end
    end
end

% The function returns an index of a colour with maximum range.
function max_range_index = get_max_range_index(flatten_img)
    max_range_index = 0;
    max_range = -1;
	for i=1:3
		min_colour = 255;
		max_colour = 0;
		for x = 1:size(flatten_img)
			if flatten_img(x,i) < min_colour
				min_colour = flatten_img(x,i);
			end
			if flatten_img(x,i) > max_colour
				max_colour = flatten_img(x,i);
            end
        end
		range = max_colour - min_colour;
		if range > max_range
			max_range = range;
			max_range_index = i;
		end
    end
end

% The function splits an flatten image by a colour with maximum range.
function [flatten_img_1, flatten_img_2] = split_by_max_range(max_range_index, flatten_img)
    flatten_img = sortrows(flatten_img, max_range_index);
	median = round(size(flatten_img(:,1))/2);
    flatten_img_1 = flatten_img(1:median,:);
    flatten_img_2 = flatten_img((median+1):end,:);
end

function mean_rgb = get_mean(flatten_img)
    mean_r = round(mean(flatten_img(:,1)));
    mean_g = round(mean(flatten_img(:,2)));
    mean_b = round(mean(flatten_img(:,3)));
    mean_rgb = [mean_r, mean_g, mean_b];
end



    


