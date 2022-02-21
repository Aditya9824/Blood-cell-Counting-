
function output= erosion(image,se)

[rows, columns, ~] = size(image);


[p, q]=size(se);
halfHeight = floor(p/2);
halfWidth = floor(q/2);
% Initialize output image
output = zeros(size(image), class(image));
% Perform local min operation, which is morphological erosion.
for col = (halfWidth + 1) : (columns - halfWidth)
  for row = (halfHeight + 1) : (rows - halfHeight)
    % Get the 3x3 neighborhood
    row1 = row-halfHeight;
    row2 = row+halfHeight;
    col1 = col-halfWidth;
    col2 = col+halfWidth;
    thisNeighborhood = image(row1:row2, col1:col2);
    % Apply the structuring element
    pixelsInSE = thisNeighborhood(se);
    output(row, col) = min(pixelsInSE);
  end
end
