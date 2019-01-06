import Tkinter as tk
from tkFileDialog import askopenfilename, asksaveasfilename
from PIL import ImageTk, Image
import renderer as rdr



DEFAULT_X = 300
DEFAULT_Y = 300
MAX_SIZE = 500
class GUI:
    def __init__(self):
        self.master = tk.Tk()
        # self.master.geometry("1200x1500")

        canvases = tk.Frame(self.master)
        canvases.pack(side=tk.RIGHT)

        # Input image display
        self.inputCanvas = tk.Canvas(canvases, width=DEFAULT_X, height=DEFAULT_Y)
        self.inputCanvas.config(highlightbackground="black")
        self.inputCanvas.pack(padx=10, pady=10)

        # Output image display
        self.outputCanvas = tk.Canvas(canvases, width=DEFAULT_X, height=DEFAULT_Y)
        self.outputCanvas.config(highlightbackground="black")
        self.outputCanvas.pack(padx=10, pady=10)


        options = tk.Frame(self.master, padx=5, pady=5)
        options.pack(side=tk.LEFT)

        self.inputButton = tk.Button(options, text="Select image", command=self.inputButtonCallback)
        self.inputButton.pack(pady=10)

        self.convertButton = tk.Button(options, text="begin rendering", command=self.convertButtonCallback)
        self.convertButton.pack(pady=10)

        self.saveButton = tk.Button(options, text="save result", command=self.saveButtonCallback)
        self.saveButton.pack(pady=10)


        basics = tk.LabelFrame(options, text="basic effects", padx=5, pady=5)
        basics.pack(padx=10, pady=10)

        self.grayscaleSel = tk.IntVar()
        self.grayscaleCB = tk.Checkbutton(basics, text='grayscale', variable=self.grayscaleSel)
        self.grayscaleCB.pack(anchor='w')

        self.inverseSel = tk.IntVar()
        self.inverseSelCB = tk.Checkbutton(basics, text='inverse', variable=self.inverseSel)
        self.inverseSelCB.pack(anchor='w')

        self.blurringSel = tk.IntVar()
        self.blurringCB = tk.Checkbutton(basics, text='blurring', variable=self.blurringSel)
        self.blurringCB.pack(anchor='w')

        self.quantizationSel = tk.IntVar()
        self.quantizationCB = tk.Checkbutton(basics, text='quantization', variable=self.quantizationSel)
        self.quantizationCB.pack(anchor='w')

        advanced = tk.LabelFrame(options, text="advanced effects", padx=5, pady=5)
        advanced.pack(padx=10, pady=10)

        self.advSel = tk.IntVar()
        # advSel.set(1)
        self.watercolorRB = tk.Radiobutton(advanced, text='watercolor', variable=self.advSel, value=1)
        self.cartoonRB = tk.Radiobutton(advanced, text='cartoon', variable=self.advSel, value=2)
        self.noneRB = tk.Radiobutton(advanced, text='none', variable=self.advSel, value=0)
        self.watercolorRB.pack(anchor='w')
        self.cartoonRB.pack(anchor='w')
        self.noneRB.pack(anchor='w')

        selections = tk.LabelFrame(options, text="input levels", padx=5, pady=5)
        selections.pack(padx=10, pady=10)

        self.quantInput = tk.IntVar()
        self.blurInput = tk.IntVar()
        self.cartoonInput = tk.IntVar()
        self.closingInput = tk.IntVar()
        self.quantlevel = tk.Scale(selections, from_=1, to=16, orient=tk.HORIZONTAL, label='quantization', variable=self.quantInput)
        self.closinglevel = tk.Scale(selections, from_=1, to=16, orient=tk.HORIZONTAL, label='closing', variable=self.closingInput)
        self.blurlevel = tk.Scale(selections, from_=0, to=4, orient=tk.HORIZONTAL, label='blurring', variable=self.blurInput)
        self.cartoonlevel = tk.Scale(selections, from_=0, to=16, orient=tk.HORIZONTAL, label='canny', variable=self.cartoonInput)
        self.quantlevel.pack(anchor='w')
        self.closinglevel.pack(anchor='w')
        self.blurlevel.pack(anchor='w')
        # self.cartoonlevel.pack(anchor='w')

        self.extraDilSel = tk.IntVar()
        self.extraDilationButton = tk.Checkbutton(selections, text='extra dilation', variable=self.extraDilSel)
        self.extraDilationButton.pack(anchor='w')


    def inputButtonCallback(self):
        self.inputPath = askopenfilename()
        print self.inputPath
        self.inputImg = Image.open(self.inputPath)
        inputImgResize = self.imresize(self.inputImg, 0)
        self.inputImgWidget = ImageTk.PhotoImage(inputImgResize)
        self.inputCanvas.create_image(0, 0, image=self.inputImgWidget, anchor=tk.NW)
        self.inputCanvas.config(highlightbackground="white")

    def convertButtonCallback(self):
        self.renderer = rdr.Renderer(self.inputPath)
        self.rendering()
        if self.grayscaleSel.get():
            self.outputImg = Image.fromarray(self.renderer.img)
        else:
            self.outputImg = Image.fromarray(self.renderer.getRGB())
        self.outputImgResize = self.imresize(self.outputImg, 1)
        self.outputImgWidget = ImageTk.PhotoImage(image=self.outputImgResize)
        self.outputCanvas.create_image(0, 0, image=self.outputImgWidget, anchor=tk.NW)
        self.outputCanvas.config(highlightbackground="white")

    def saveButtonCallback(self):
        savepath = asksaveasfilename()
        # print savepath.dtype
        #if not savepath.contains("."):
        #    tkMessageBox.showinfo("Renderer", "please include file format")
        self.outputImg.save(savepath)



    def imresize(self, img, canvas):
        width, height = img.size
        resized = 0
        width2, height2 = width, height
        if width >= MAX_SIZE:
            resized = 1
            width2 = MAX_SIZE
            height2 = int(MAX_SIZE * height / width)
        elif height >= MAX_SIZE:
            resized = 1
            height2 = MAX_SIZE
            width2 = int(MAX_SIZE * width / height)

        if canvas == 0:
            self.inputCanvas.config(width=width2, height=height2)
        else:
            self.outputCanvas.config(width=width2, height=height2)
        if resized:
            return img.resize((width2, height2))
        else:
            return img

    def rendering(self):
        if self.grayscaleSel.get() == 1:
            self.renderer.grayscale()
        if self.inverseSel.get() == 1:
            self.renderer.inverse()
        if self.blurringSel.get() == 1:
            self.renderer.blurring(self.blurInput.get())
        if self.quantizationSel.get() == 1:
            self.renderer.colorQuantization(self.quantInput.get())
        if self.advSel.get() == 1:
            self.renderer.watercolor(quantLevel=self.quantlevel.get(), extraDilation=self.extraDilSel.get(), iteration=self.closingInput.get())
        if self.advSel.get() == 2:
            self.renderer.cartoon(9, 105, 105, 0.1)


if __name__ == '__main__':
    gui = GUI()
    gui.master.mainloop()

