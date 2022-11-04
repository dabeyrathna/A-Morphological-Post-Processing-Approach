
# Dataset Description

## Data Acquisition

Geobacillus is a bacterial genus from the family of Bacillaceae. The bacterial cells were grown at 60C in a rotatory cell culture system to simulate microgravity. After 24 hours of growth, the cells were arrested by treating with glutaraldehyde followed by three consecutive wash with 50%, 70% and 100% alcohol respectively. The diluted cell suspensions were mounted on SEM sample mount and air dried before the image acquisition. To generate SEM images, the equipment is Zeiss Supra 40 VP/Gemini Column Scanning Electron Microscope (SEM), and the microscopy parameters are as follows: Electron High Tension (EHT) Voltage = 1 kV (Also called accelerating voltage), and the type is field emission SEM, and the detector is SE2 (Secondary electron)[1]. 
The dataset of 72 gray scale SEM images were used to train and test the proposed bacterial cell segmentation approach. Each image in the dataset consists with meta data, such as magnitude, focal length of the objective lens (WD), EHT, Noise reduction method, Chamber Status, data and time. Figure~\ref{data_sample} shows the sample SEM images from the dataset used in our experiments and average 1 micrometer represents 60 pixels in the image.

More information regarding the experiment and data generation, please refer Carlson et al [1].

## Data Annotation
We have used VGG Image Annotator [2] to annotate the bacteria cells to seperate froeground from the background. The segmentation annotation contains white pixels which represent the cell foreground and rest is black pixels.  
<img src="../results/U-Net segmentation masks/out11.png" alt="1" width = 200px height = 150px >

## References

[1] Carlson, C., Singh, N. K., Bibra, M., Sani, R. K., & Venkateswaran, K. (2018). Pervasiveness of UVC254-resistant Geobacillus strains in extreme environments. Applied microbiology and biotechnology, 102(4), 1869-1887.


[2] Abhishek Dutta and Andrew Zisserman. 2019. The VIA Annotation Software for Images, Audio and Video. In Proceedings of the 27th ACM International Conference on Multimedia (MM ’19), October 21–25, 2019, Nice, France. ACM, New York, NY, USA.
