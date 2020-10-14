# 3D-Orientation-Field-Transform
The MATLAB code of orientation field transform, available for enhancing 3D and 2D curves for segmentation purposes.

# Reference
This code is distributed under the MIT license, and could be used modified, and distributed for commercial and non-commercial purposes. To use this code, please cite: Yeung, W. T., Cai, X., Liang, Z., & Kang, B. H. (2020). 3D Orientation Field Transform. arXiv preprint arXiv:2010.01453. The authors of the code and the paper are not liable to any damage caused by using this code.

# Dependencies
MATLAB 2010a, MATLAB Image Processing Toolbox

# Main Functions
To enhance 2D curves in an image, enter: output = orientfield2d(input, l), where l is the length of the line to be used as the filter.
To enhance 3D curves in an image, enter: output = orientfield3d(input, l).

# Test
To test the codes, test images used in the paper cited above are included in the file test.mat.

To test the image with sparse 2D curves, enter: sparse2denhance = orientfield2d(sparse2d,31)); imshow(sparse2denhance);
To test the image with packed 3D curves, enter: dense2denhance = orientfield2d(dense2d,47); imshow(dense2denhance);
To test the image with synthetic 3D curves, enter: synthetic3denhance = orientfield3d(synthetic3d,11); implay(synthetic3d,11);
To test the 3D electron tomogram with 3D curves, enter: real3denhance = orientfield3d(real3d,19); implay(real3denhance);
