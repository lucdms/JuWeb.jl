# ============== #
#     Service	 #
# ============== #

using Colors, Images
using StatsBase
#using ImageView


type ImageService
	
	espVert::Function
	espHor::Function
	tomCinza::Function
	brilho::Function
	contraste::Function
	negativo::Function
	quantizar::Function	
	pointDetector::Function
	blur::Function
	dilate::Function
	erode::Function
	bilinear_interpolation::Function
	morpholaplace::Function
	morphogradient::Function
	tophat::Function
	opening::Function
	closing::Function
	MeanFilter::Function
	SaltPepperNoise::Function
	imfilter_gaussian::Function
	ZoomScript::Function #exibe img da home polsar
	
	
	function ImageService()
	
		this = new()
		
		function espVert()
			
		end
		
		function espHor()
			
		end
	
		function tomCinza(img)
			imgg = convert(Image{Gray}, img)
			println(colorspace(imgg))
			return imgg
		end	
	
		function brilho()
			
		end
	
		function contraste(img)

		end	
	
		function negativo()
			
		end	
	
		function quantizar()
			
		end
		
		function blur(img)
			kern = ones(Float32,7,7)/49
			return Images.imfilter(img, kern)
		end

		function pointDetector(img)
			dx,dy = size(img)
			mask = [-1 -1 -1; -1 8 -1; -1 -1 -1]
			imgP = copy(img)
			println("a")
			for i=2:dx-1, j=2:dy-1
				block = img[i-1:i+1,j-1:j+1]
				conv = block .* mask
				println(conv)
				println("d")
				sumb = sum(conv)
				println(eltype(sumb))
				println(length(sumb))
				println("b")
				if length(sumb) > 255
					sumb = 255
				elseif length(sumb) < 0
					sumb = 0
				end
				println("c")
				imgP[i,j] = sumb
			end
			return imgP
		end
		
		function dilate(img)
			return Images.dilate(img)
		end
	
		function erode(img)
			return Images.erode(img)
		end
		
		function bilinear_interpolation(img, p1::Float64, p2::Float64)
			return Images.bilinear_interpolation(img, p1, p2)
		end
	
		function morpholaplace(img)
			A = zeros(13, 13)
			A[5:9, 5:9] = 1
			return dilate(img) + erode(img)
		end
	
		function morphogradient(img)
			return dilate(img) - erode(img)
		end
		
		function tophat(img)
			return Images.tophat(img)
		end
		
		function opening(img)
			return Images.opening(img)
		end
		
		function closing(img)
			return Images.closing(img)
		end
		
		function SaltPepperNoise(img)
			dx,dy = size(img)
			newImg = img
			times = (dx*dy)/100
			for (j in 1:times)
				x = rand(1:dx)
				y = rand(1:dy)
				newImg[x,y,1] =  1
				newImg[x,y,2] =  1
				newImg[x,y,3] =  1
			end
			return newImg
		end
		
		function MeanFilter(img, width, height)
			newImg = img
			for (i in 2:(width-1))
				for (j in 2:(height-1))
					newImg[i,j,1] =  (img[i-1,j-1,1] + img[i,j-1,1] 	+ img[i+1,j-1,1] + 
									  img[i-1,j,1] 	 + img[i,j,1] 		+ img[i+1,j,1] +
									  img[i-1,j+1,1] + img[i,j+1,1] 	+ img[i+1,j+1,1])/9
					newImg[i,j,2] =  (img[i-1,j-1,2] + img[i,j-1,2] 	+ img[i+1,j-1,2] + 
									  img[i-1,j,2] 	 + img[i,j,2] 		+ img[i+1,j,2] +
									  img[i-1,j+1,2] + img[i,j+1,2] 	+ img[i+1,j+1,2])/9
					newImg[i,j,3] =  (img[i-1,j-1,3] + img[i,j-1,3] 	+ img[i+1,j-1,3] + 
									  img[i-1,j,3] 	 + img[i,j,3] 		+ img[i+1,j,3] +
									  img[i-1,j+1,3] + img[i,j+1,3] 	+ img[i+1,j+1,3])/9
				end
			end
			return (newImg)
		end
		
		function imfilter_gaussian(L, s)
			if (isa(L, Array{Complex{Int64},2}) == false)
				return Images.imfilter_gaussian(L,[s,s])
			else 
				return Images.imfilter_gaussian(real(L),[s,s]),Images.imfilter_gaussian(imag(L),[s,s])
			end
		end
		
		function PauliDecomposition(mHH, mHV, mVV, height, widht)
			println("-------------function PauliDecomposition(mHH, mHV, mVV, height, widht)--------------------")
			pauliR = mHH + mVV
			pauliG = mHV
			pauliB = mHH - mVV
			#------------------------
		#	pauliR = mHH
		#	pauliG = mHV
		#  	pauliB =  mVV
			pauliReq = ecdf(pauliR)(pauliR)
			pauliGeq = ecdf(pauliG)(pauliG)
			pauliBeq = ecdf(pauliB)(pauliB)
			
			pauliRGBeq = reshape([[pauliReq],[pauliGeq],[pauliBeq]],(widht,height,3))
			
			return pauliRGBeq
		end

		
		function ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection)
			index = 1   # The array in which is going to be stored the needed values from the source data needs and index variable different from the tipical i or j form the loops
			start *= 8  # start is multiplied by 8 in order to skip pixels accordingly
			windowHeight = trunc(windowHeight) # trunced in order to avoid non integer values (unnaccepted by the functions that use those variables)
			windowWidth = trunc(windowWidth)
			imageVector = zeros(Float64, zoomHeight*zoomWidth)
			# SETTING POINTER: Here we get the position of the last pickable pixel in the line, setting the connection to 0 (the beginning) and then to the desired beginning of the upcomming image, then it is skiped to it's width (remember that each pixel is 8 bits), then saved for further use and finally reset to 0.
			seekstart(connection)
			skip(connection, start)
			skip(connection, 8*windowWidth)
			windowWidthPosition = convert(Int32, position(connection)/8)
			seekstart(connection)
			skip(connection, start)
			# SETTING PACES: Calculates the proportion in which the rows and columns pixels are skiped.
			if (zoomWidth == windowWidth)
				widthPace = 0
				back = 0    # Back is needed because each access in the source file pixels automatically moves the pointer.
			else
				widthPace = trunc(windowWidth/zoomWidth)
				back = -8
			end

			if (zoomHeight == windowHeight)
				heightPace = 0
			else
				heightPace = trunc(windowHeight/zoomHeight)-1
			end
			heightPace  = convert(Int64, heightPace)
			widthPace = convert(Int64, widthPace)
			# FIRST LINE READING
			imageVector[index] = abs(read(connection, Float64, 1)[1])
			index +=  1
			for (j in 1:(zoomWidth-1)) # The order in which the pixels are accessed is important
				skip(connection, 8*widthPace)
				imageVector[index] = abs(read(connection, Float64, 1)[1])
				index +=  1
				skip(connection, back) # the automatical skip when the position is accessed in the source file is not accounted in the pace calculus
			end
			# ALL THE REMAINING LINES: After the first line is read, probably there are n != widthPace, making the continuous pace place the new line before or after it should begin to be alligned. To correct that, the moduloPosition is calculated using the modulo operation to find where the pointer is at in relation with the windowWidth, then the skipAux is calculated, taking in consideration also the heightPace, the pointer is moved, and the new line can begin alligned with the first.
			moduloPosition = convert(Int32, position(connection)/8)
			moduloValue = windowWidthPosition % moduloPosition
			skipAux = 8*(moduloValue + (sourceWidth - windowWidth) + (heightPace*sourceWidth))
			skip(connection, skipAux)
			# Now that the first line is done and the number of pixels to skip in the end of every line is known the rest of the image can be done.
			for (i in 1:zoomHeight-1)
				imageVector[index] = abs(read(connection, Float64, 1)[1])
				index += 1
				for (j in 1:(zoomWidth-1))
					skip(connection, 8*widthPace)
					imageVector[index] = abs(read(connection, Float64, 1)[1])
					index += 1
					skip(connection, back)
				end
				skip(connection, skipAux)
			end

			imageVector

		end
		
		function ZoomScript(hh::AbstractString, hv::AbstractString, vv::AbstractString, zoomPercent::Int, imgPath::AbstractString, windowPercent=100)
			tic()
			global time = zeros(5)
			# time[1] = step 1
			# time[2] = step 2
			# time[3] = step 3
			# CONSTANTS
			# SandAnd dims
			# sourceHeight          	= 11858
			# sourceWidth	        	= 1650
			# ChiVol dims
			# sourceHeight          	= 153546
			# sourceWidth	        	= 9580
			# windowHeight=76773
			# windowWidth=4790
			# zoomHeight=4798
			# zoomWidth=300
			start		            = 0
			sourceHeight      		= 11858
			sourceWidth	    		= 1650
			windowHeight          	= round(Int,sourceHeight*(windowPercent/100))
			windowWidth	        	= round(Int,sourceWidth*(windowPercent/100))
			zoomHeight 	        	= round(Int,sourceHeight*(zoomPercent/100))
			zoomWidth	            = round(Int,sourceWidth*(zoomPercent/100))
			# connection files
			connection1 = open(hh) # HHHH
			connection2 = open(hv) # HVHV
			connection3 = open(vv) # VVVV
			########## Step 1
			# Image bands
			A = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection1)
			B = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection2)
			C = ZoomImage(start, windowHeight, windowWidth, zoomHeight, zoomWidth, sourceHeight, sourceWidth, connection3)
			time[1] = toc()
			########## Step 2
			tic()
			pauliRGBeq = PauliDecomposition(A, B, C, zoomHeight, zoomWidth)
			time[2] = toc()
			########## Step 3
			tic()
			saveimg_time = Images.save(imgPath,convert(Image,pauliRGBeq))
			#ImageView.view(pauliRGBeq)
			time[3] = toc()
			# Add of noise and visualization
			#@time noisy = SaltPepperNoise(pauliRGBeq, zoomWidth, zoomHeight)
			# Filtering and visualization
			#@time pauliRGBeqMean = MeanFilter(noisy, zoomWidth, zoomHeight)
			close(connection1)
			close(connection2)
			close(connection3)
			time

		  return true

		end
		
		
	
		this.espVert = espVert
		this.espHor = espHor
		this.tomCinza = tomCinza
		this.brilho = brilho
		this.contraste = contraste
		this.negativo = negativo
		this.quantizar = quantizar
		this.pointDetector = pointDetector
		this.blur = blur
		this.dilate = dilate
		this.erode = erode
		this.bilinear_interpolation = bilinear_interpolation
		this.morpholaplace = morpholaplace
		this.morphogradient = morphogradient
		this.tophat = tophat
		this.opening = opening
		this.closing = closing
		this.SaltPepperNoise = SaltPepperNoise
		this.MeanFilter = MeanFilter
		this.imfilter_gaussian = imfilter_gaussian
		this.ZoomScript = ZoomScript #polsar
		
		
		
		return this
	
	end

end