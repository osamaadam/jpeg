clear;
clc;

N = 8;
uk = sqrt(2 / N) * ones(1, 8);
uk(1) = sqrt(1 / N);
k = (0 : 7);
r = transpose(k);

c8 = uk .* cos( k .* (pi / N) .* (r + 0.5) );
c8Trans = c8;
c8 = transpose(c8);

grayscaleImage = rgb2gray(imread('grayscale.png'));

imageSize = size(grayscaleImage);
paddedImage = uint8(zeros(nextNumberDivisbleByN(imageSize(1), N), nextNumberDivisbleByN(imageSize(2), N)));

paddedImage(1: imageSize(1), 1: imageSize(2)) = grayscaleImage;

figure;
title('Padded Image');
imshow(paddedImage);

splitImage = mat2cell( paddedImage, 8 * ones(1,ceil(size(paddedImage,1)/8)), 8 * ones(1,ceil(size(paddedImage,2)/8)) );

test = dct2(cell2mat(splitImage(1)));
test2 = round(c8 * double(cell2mat(splitImage(1))) * transpose(c8));
test3 = double(cell2mat(splitImage(1)));

dctBlocks = cellfun(@(x) round(c8 * double(x) * c8Trans), splitImage, 'UniformOutput', false);

scalingFactor = 1;

quantizedCells = quantizeCells(dctBlocks, scalingFactor);

rescaledImage = rescaleImage(quantizedCells, scalingFactor);

compressedImageCells = cellfun(@(x) round(c8Trans * double(x) * c8), rescaledImage, 'UniformOutput', false);

compressedImage = uint8(cell2mat(compressedImageCells));

figure;
title('Compressed Image');
imshow(compressedImage);