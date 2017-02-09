#módulo serve para desenhar formas sobre imagens

using Images
using Colors
import ImageView

z = ones(10,50);
y = 8; x = 2;
z[y,x] = 0

#imagem1
#zimg = convert(Image, z)

#imagem2
zimg = load("../img.png")


imgc, img2 = ImageView.view(zimg,pixelspacing=[1,1]); #manter o aspect ratio


Tk.set_size(ImageView.toplevel(imgc), 1200, 200) #

#desenhar linha na imagem

#ponto de origem da linha
x_start = 10
y_start = 100
#ponto final da linha
x_end = 1700
y_end = 100


#idx = ImageView.annotate!(imgc, img2, ImageView.AnnotationText(x+135, y+44, "xAMA", color=RGB(0,0,1), fontsize=103))
#idx2 = ImageView.annotate!(imgc, img2, ImageView.AnnotationPoint(x+10, y, shape='.', size=4, color=RGB(1,0,0)))
#idx3 = ImageView.annotate!(imgc, img2, ImageView.AnnotationPoint(x+20, y-6, shape='.', size=1, color=RGB(1,0,0), linecolor=RGB(0,0,0), scale=true))
#idx4 = ImageView.annotate!(imgc, img2, ImageView.AnnotationLine(x_start, y_start, x_end, y_end, linewidth=225, color=RGB(1,0,0),  coord_order="xyxy")) #vermelha

#idx5 = ImageView.annotate!(imgc, img2, ImageView.AnnotationBox(x+10, y, x+20, y-6, linewidth=2, color=RGB(0,0,1)))

#ImageView.delete!(imgc, idx4)


length = 4
ImageView.scalebar(imgc, img2, length; x = 0.1, y = 0.05)




#visualiza as propriedades de uma imagem
img = load("../imgt.png")
imgnew = subim(img, "x", 1:500, "y", 500:1000)
ImageView.view(imgnew, pixelspacing = [1,1])






