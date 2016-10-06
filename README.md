# image_effector

Exam project: Formati Multimediali (2013/14) - University of Milan Bicocca

Executable java written with [Processing](https://processing.org/) to manipulate images. 

### Target of project:

- `void drawCenter()`:
draw little box which follow mouse's movements and shows the following informations:
	- mouse coordinates x,y
	- colored box with pixel color in x,y
	- rgb value of the pixel in x,y
- `void cleanHistograms()`, `void calcHistograms(int p_type)`, `void normHistograms()`:
calculate and draw histrograms of r,g,b channels, brightness and YCbCr
- `void doBlur()`: 
implement blur effect
- `void doPixelate(int p_dim, boolean p_dot)`:
implement pixelate effect; it split the images into squares or circles with dimension *p_dim* and fill them with the average color inside them.
- `void drawGui()`:
draw GUI (Graphical User Interface) with three buttons for effects, four buttons for images and some informations about usage
- `void processGui()`:
process GUI interaction, it detect if a button is pressed and check button type

### The code

- `void doPixelate(int p_dim, boolean p_dot)`: creates a pixelization of images in dots or in squares (with dimension *p_dim*) and the choosen form is selected in *p_dot* with nested loops that select all pixels in image and for each block calculate average color to fill  the corresponding square (or dot).
- `float[] g_filter`: the blur matrix.
- `void doBlur()`: with nested loops selects all pixels of image and analyze neighbourhood of each pixel to calculate the color to show.
- `void cleanHistograms()`: cleans histogram data
- `calcHistograms(int p_type)`: recalculates histogram depending on input type in *p_type* (r,g,b, ...) with a loop to check the value for each pixel.
- `void normHistograms()`: normalizes histogram with max value found in the search in calcHistogram.
- `void hitFx(int p_index)`, `void hitImg(int p_index)`: helper methods to check the corresponding function or image.
- `void processGui()`: process mouse click on the buttons; if is on effect button, it calls *hitFx(N)* (with *N* is 0,1 or 2); if is on image button, it calls *hitImg(N)* (with *N* is 0,1,2 or 3).
- `color getColorFromImage(int p_x, int p_y)`: return color of pixel in coordinates x,y.
- `void loadDiskImage(int p_image)`: load image with index *p_image* and call functions to initialize and recalculate histograms.
- `void setup()`: initial setup.
- `void drawHistogram(String p_text, int p_x, int p_y, int p_w, int p_h, color p_color_bg, color p_color)`: draw histogram with the correct data: *p_text* is the name of type of histogram, *p_* attributes are coordinates of box where draw histogram and *p_color* attributes are for fill histogram and background colors.
- `void drawGUI()`: draw background and buttons for GUI.
- `void drawCenter()`: draw dynamically box with informations for each pixel in mouse coordinates. The position to display the info-box is calculated to stay into the program window.
- `draw()`: draw canvas, every frame.
- `void keyPressed()`: detects which key in in keyboard is pressed and calls the corresponding function.
- `void mousePressed()`: detects mouse click.
- `void mouseReleased()`: detects mouse release.

