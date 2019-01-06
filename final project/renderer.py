
import numpy as np
from scipy import signal
import cv2 as cv
from sklearn.cluster import MiniBatchKMeans

class Renderer:
    def __init__(self, img_path):
        self.img = cv.imread(img_path, 1)  # [B, G, R]

    "Basic Operation: Get grayscale image"
    def grayscale(self):
        self.img = cv.cvtColor(self.img, cv.COLOR_BGR2GRAY)

    "Basic Operation: Get inverse image"
    def inverse(self):
        self.img = -self.img

    "Basic Operation: Blurring using Gaussian LPF"
    def blurring(self, size=3):
        gaussian = np.ones((size, size)) / (size * size)
        self.img[:, :, 0] = signal.convolve2d(self.img[:, :, 0], gaussian, mode='same')
        self.img[:, :, 1] = signal.convolve2d(self.img[:, :, 1], gaussian, mode='same')
        self.img[:, :, 2] = signal.convolve2d(self.img[:, :, 2], gaussian, mode='same')

    "display image for debugging"
    def imshow(self):
        cv.imshow('image', self.img)
        cv.waitKey(0)
        cv.destroyAllWindows()

    "Basic Operation: Color Enhancement. Not yet in GUI"
    def colorEnhance(self, band, gamma):
        b, g, r = cv.split(self.img)
        r_, g_, b_ = r, g, b
        if band == 'b':
            b_ = self.colorEnhanceHelper(b, gamma)
        elif band == 'g':
            g_ = self.colorEnhanceHelper(g, gamma)
        elif band == 'r':
            r_ = self.colorEnhanceHelper(r, gamma)
        self.img = cv.merge((b_, g, r_))

    def colorEnhanceHelper(self, band, gamma):
        b_ = np.power(band.astype('float') / 256, gamma)
        b_ *= 255
        return b_.astype('uint8')

    "Color Quantization using K-Means algorithm"
    def colorQuantization(self, cluster=16):
        # get image shape, use only height and width
        height, width, _ = self.img.shape
        # convert to 1-D LAB space
        img = cv.cvtColor(self.img, cv.COLOR_BGR2LAB).reshape((height * width), 3)
        # get MiniBatchKMeans predictor with `cluster levels
        predictor = MiniBatchKMeans(n_clusters=cluster)
        qColors = predictor.fit_predict(img)
        quant = predictor.cluster_centers_.astype("uint8")[qColors]
        # reshape the quantized image back to original shape
        quant = quant.reshape((height, width, 3))
        # convert back to BGR space
        self.img = cv.cvtColor(quant, cv.COLOR_LAB2BGR)

    "Cartoon Effect"
    def cartoon(self, d, sigmaColor, sigmaSpace, alpha):
        self.img = cv.bilateralFilter(self.img, d, sigmaColor, sigmaSpace)
        self.edgeEnhance(0.9)

    def dilation(self, iterations=1):
        kernel = np.ones((3, 3), np.uint8)
        self.img = cv.dilate(self.img, kernel=kernel, iterations=iterations)

    def erosion(self, iterations=1):
        kernel = np.ones((3, 3), np.uint8)
        self.img = cv.erode(self.img, kernel=kernel, iterations=iterations)

    "Watercolor Effect"
    def watercolor(self, quantLevel=8, iteration=1, extraDilation=0):
        self.edgeEnhance(0.9)
        self.colorQuantization(quantLevel)
        for _ in range(1, iteration):
            self.dilation()
            self.erosion()
        if extraDilation:
            self.dilation()

    def edgeEnhance(self, percent=1):
        edges = cv.Canny(self.img, 100, 200)
        indices = np.nonzero(edges)
        self.img = self.img.astype('float64')
        self.img[indices] *= percent
        self.img = self.img.astype('uint8')


    "BGR to RGB converter"
    def getRGB(self):
        b, g, r = cv.split(self.img)
        return cv.merge((r, g, b))


if __name__ == '__main__':
    rn = Renderer('cat.jpg')
    #rn.grayscale()
    #rn.blurring(4)
    #rn.inverse()
    #rn.colorQuantization()
    #rn.blurring()
    #rn.colorQuantization()
    rn.cartoon(9, 105, 105, 0.1)
    #rn.watercolor()
    #rn.colorEnhance('b', 0.5)
    rn.imshow()