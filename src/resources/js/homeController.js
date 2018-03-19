angular.module('appController').controller('indexController', function($scope){

	$scope.selectedAlgorithm = document.getElementsByName("selectedAlgorithm").value;
	$scope.summarySize = document.getElementsByName("summary-size").value;
	$scope.croppedImage = false;
	$scope.height = 500;
	$scope.width = 500;

	
    $scope.DrawImageCutInCanvas = function(urlImg){
        document.getElementById("imagem-cortada").appendChild(urlImg);
        document.getElementById("imagem-cortada").width = $scope.width;
        document.getElementById("imagem-cortada").height = $scope.height;
    };

    $scope.generateImage = function(){

		//validate select
		if($scope.selectedAlgorithm==null){
			alert('Please, choose an algorithm...');
			return false;
		}
		

        if(oROI.startX != undefined && oROI.startY != undefined && oROI.w != undefined && oROI.h != undefined){

            //parâmetros
            var xStart, xEnd, yStart, yEnd;

            //ordem das coords para a chamada do método | xStart <= xEnd e yStart <= yEnd
            if(oROI.startX <= (oROI.w + oROI.startX)){

                xStart = oROI.startX;
                xEnd = (oROI.w + oROI.startX);

            }else{

                xStart = (oROI.w + oROI.startX);
                xEnd = oROI.startX;

            }

            if(oROI.startY <= (oROI.h + oROI.startY)){

                yStart = oROI.startY;
                yEnd = (oROI.h + oROI.startY);

            }else{

                yStart = (oROI.h + oROI.startY);
                yEnd = oROI.startY;

            }

            var httpRequest = new XMLHttpRequest();

			//old
            //httpRequest.open('GET', 'http://localhost:8000/imgCut/' + xStart + '/' + xEnd + '/' + yStart + '/' + yEnd,true);
            
			//new
			//httpRequest.open('GET', 'http://localhost:8000/polsar/services/generateImage?algorithm=' + $scope.selectedAlgorithm + '&ssize=' + $scope.summarySize + '&xStart=' + xStart + '&xEnd=' + xEnd + '&yStart=' + yStart + '&yEnd=' + yEnd, true);
			//httpRequest.send();
			
						
			var outputImg = new Image($scope.summarySize,$scope.summarySize);
			outputImg.src = 'http://localhost:8000/polsar/services/generateImage?algorithm=' + $scope.selectedAlgorithm + '&ssize=' + $scope.summarySize + '&xStart=' + xStart + '&xEnd=' + xEnd + '&yStart=' + yStart + '&yEnd=' + yEnd;
			$scope.DrawImageCutInCanvas(outputImg);
				

			/*
            httpRequest.onreadystatechange = alertContents = function alertContents() {
                if (httpRequest.readyState === 4) {
                    if (httpRequest.status === 200) {
                        //var outputImg = new Image($scope.width,$scope.height);
                        var outputImg = new Image($scope.summarySize,$scope.summarySize);

						
						
                        //outputImg.src = '/cutImage'+ (new Date().toString());
                        //outputImg.src = '/imagem_cortada.png';
						
						
						//old
						//outputImg.src = 'http://localhost:8000/imgCut/' + xStart + '/' + xEnd + '/' + yStart + '/' + yEnd;
						
						
						//new
						outputImg.src = 'http://localhost:8000/polsar/services/generateImage?algorithm=' + $scope.selectedAlgorithm + '&ssize=' + $scope.summarySize + '&xStart=' + xStart + '&xEnd=' + xEnd + '&yStart=' + yStart + '&yEnd=' + yEnd;
						
						
						$scope.DrawImageCutInCanvas(outputImg);

                    } else {
                        console.log(httpRequest.status);
                    }
                }
            };
			*/
            //httpRequest.open('GET', 'http://localhost:8000/imgCut/' + xStart + '/' + xEnd + '/' + yStart + '/' + yEnd,true);
            //httpRequest.send();
        }
		/*
        $scope.croppedImage = true;
        var arraySummarySize = $scope.summarySize.split("x");
        $scope.width =  parseInt(arraySummarySize[0]);
        $scope.height = parseInt(arraySummarySize[1]);
        $scope.DrawImageCutInCanvas();
		*/
	};
});

    var oImageBuffer = document.createElement('img');
    var oCanvas = document.getElementById("myCanvas");
    var o2DContext = oCanvas.getContext("2d");
    var oRect = {}; //retângulo formado
    var oROI = {};
    var oLayers = new Array();
    var bDragging = false;
    var bSetROI = false;
    var bSetLayers = false;

    InitMouseEvents();
    DrawImageInCanvas();

    function DrawImageInCanvas() {
        //elemento html do background
        var bckgCanvas = document.getElementById("canvasBackground");
        var urlImage = bckgCanvas.src;

        var elementoCanvas = document.getElementById("myCanvas");
        elementoCanvas.width = 1186;
        elementoCanvas.height = 165;
        elementoCanvas.style = "background:url("+urlImage+")";
    };

    // Canvas event handlers (listeners).
    function InitMouseEvents() {
        oCanvas.addEventListener('mousedown', MouseDownEvent, false);
        oCanvas.addEventListener('mouseup', MouseUpEvent, false);
        oCanvas.addEventListener('mousemove', MouseMoveEvent, false);
        oCanvas.addEventListener('mouseout', MouseOutEvent, false);

    }
    function MouseDownEvent(e) {
        oRect.startX = e.pageX - this.offsetLeft;
        oRect.startY = e.pageY - this.offsetTop;
        bDragging = true;
    };

    function MouseUpEvent(e) {
        e.preventDefault();
        bDragging = false;
        oROI.endX =  e.clientX - this.offsetLeft;
        oROI.endY = e.clientY - this.offsetTop;
    };

    function MouseOutEvent() {
        document.getElementById("MouseCoords").innerHTML="";
    };

    function MouseMoveEvent(e) {

        if (bDragging) {
            oRect.w = (e.pageX - this.offsetLeft) - oRect.startX;
            oRect.h = (e.pageY - this.offsetTop) - oRect.startY;
            oCanvas.getContext('2d').clearRect(0,0,oCanvas.width, oCanvas.height);
            //roi
            var oROI = document.getElementById("btnROI");

            //analisar se o elemento ROI est� marcado no Html
            if (oROI.checked) {
                SetROI();
            }
            //layer
            var oLayer = document.getElementById("btnLAYER");
            if (oLayer.checked) {
            SetLayer();
        }

        //enquanto apertando, calcular as coordenadas do ROI
        ShowReferencialROICoordinates();
        ShowAbsoluteROICoordinates();
        }

        if (bSetROI) {
            DrawROI();
        }
        if (bSetLayers) {
            DrawLayers();
        }
        // Display the current mouse coordinates.
        ShowMouseCoordinates(e.pageX - this.offsetLeft, e.pageY - this.offsetTop);

    };

    //coordenadas do mouse
    function ShowMouseCoordinates(x, y) {
        document.getElementById("MouseCoords").innerHTML="mouse coordinates: (" + x + "," + y + ") " +
            document.getElementById('txtPatchCount').value;

    };

    //coordenadas referenciais da regi�o de interesse
    function ShowReferencialROICoordinates() {
        document.getElementById("ROICoordsRef").innerHTML="ref roi coordinates: (" +
            oROI.startX + "," + oROI.startY + "," + oROI.w  + "," + oROI.h + ")";

    };

    //coordenadas absolutas da regi�o de interesse (deve ser usada para o corte)
    function ShowAbsoluteROICoordinates() {

        //adjust coordinates
        document.getElementById("ROICoordsAbs").innerHTML="abs roi coordinates: ("
            + oROI.startX + "," + oROI.startY + "," + (oROI.w + oROI.startX)  + "," + (oROI.h + oROI.startY) + ")";

    };
    // Interactively draw ROI rectangle(s) on the canvas.
    function SetROI() {
        bSetROI = true;
        oROI.startX = oRect.startX;
        oROI.startY = oRect.startY;
        oROI.w = oRect.w;
        oROI.h = oRect.h;
    };

    //desenhar o retângulo do ROI
    function DrawROI() {

        o2DContext.lineWidth=1.5;
        o2DContext.strokeStyle = '#0F0';
        o2DContext.strokeRect(oROI.startX, oROI.startY, oROI.w, oROI.h);

        var iPatches = document.getElementById('txtPatchCount').value;
        o2DContext.beginPath();
        var iTop = oROI.startY;
        var iBottom = oROI.startY + oROI.h;
        var iLeft = oROI.startX;
        var iX = iLeft;

        for (var iPatch=1; iPatch<iPatches; ++iPatch) {
            iX = iLeft + iPatch*oROI.w/iPatches;
            o2DContext.moveTo(iX, iTop);
            o2DContext.lineTo(iX, iBottom);
        }
        o2DContext.lineWidth=0.25;

        //desenhar
        o2DContext.stroke();
    };

    // Interactively draw layer boundaries on the canvas.
    function SetLayer() {
        bSetLayers = true;
        oLayers.length = 0;
        oLayers.push(oRect.startY);
        oLayers.push(oRect.startY + oRect.h);
    };

    function DrawLayers() {
        o2DContext.lineWidth=0.25;
        o2DContext.strokeStyle = '#F00';
        o2DContext.beginPath();
        var iY = oLayers[0];
        var iLeft = 0;
        var iRight = oCanvas.width;
        for (var iLayer=0; iLayer<oLayers.length; ++iLayer) {
        iY = oLayers[iLayer];
        o2DContext.moveTo(iLeft, iY);
        o2DContext.lineTo(iRight, iY);
        o2DContext.stroke();
    };
}