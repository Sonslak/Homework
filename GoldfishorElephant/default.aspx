<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="_default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Memory game</title>
    <style type="text/css">
        body {
            background-color: #52A2D9;
            line-height: 1;
            font-family: Verdana;
            color: #fefefe;
            height: 100%;
            -webkit-font-smoothing: subpixel-antialiased;
            -webkit-backface-visibility: hidden;
        }

        div.container {
            text-align: center;
            width: 630px;
            margin-right: auto;
            margin-left: auto;
        }

        .hide {
            display: none;
        }

        ul {
            float: left;
            background-color: #fefefe;
            padding: 0;
            padding-left: 5px;
            padding-top: 5px;
        }

        h1 {
            padding: 5px;
            font-size: 1.2em;
            letter-spacing: 0;
            color: #fff;
            text-transform: uppercase;
        }

        h2 {
            padding: 5px;
            font-size: 0.9em;
            letter-spacing: 0;
            color: #fff;
            text-transform: uppercase;
        }

        ul li {
            float: left;
            margin: 0 5px 15px 0;
            list-style: none;
        }

            ul li a {
                border: none;
                display: block;
                width: 120px;
                height: 140px;
            }
    </style>
</head>
<body>
    <div class="container">
        <h1>Memory Game</h1>
        <h2><label id="timer"></label></h2>
        <input type="button" value="Start Game" id="btnStartGame"/>
        <input type="button" value="Stop Game" class="hide" id="btnStopGame" />
        <ul id="people" class="hide"></ul>
    </div>
   
    <!-- jquery -->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

    <%-- custom js --%>
    <script type="text/javascript">

        // global variables
        var timerHandle;
        var milliseconds = 0;
        var prevImg = ""
        var clickCounter = "0"
        var enabledImages = true;

        // events
        $('#people').on('click', '.person', clickImage);
        $("#btnStartGame").on("click", startGame);
        $("#btnStopGame").on("click", stopGame);

        function clickImage(event) {
            // prevent default action
            event.preventDefault();

            // disable click while comparing
            if (enabledImages) {
                enabledImages = false;

                var currentImg = $(this);

                // set image
                currentImg.children('img').attr('src', currentImg.attr('data-img'));

                // increase counter  
                clickCounter++;

                // if two images selected, compare them
                if (clickCounter == 2) {

                    // if they match keep them open
                    if (currentImg.attr("data-img") == prevImg.children('img').attr("src")) {
                        currentImg.children('img').removeClass('unmatched');
                        currentImg.children('img').addClass('matched');

                        prevImg.children('img').removeClass('unmatched');
                        prevImg.children('img').addClass('matched');
                    }

                    setTimeout('resetAllImages()', 500);
                }
                else
                {
                    prevImg = currentImg;
                    enabledImages = true;
                }     
            }
        }

        function resetAllImages() {
            // switch unmatched back to hidden
            $("#people").find("img").map(function () {if ($(this).hasClass('unmatched')) {$(this).attr('src', "img/peek.png");}})

            // reset counters
            prevImg = "";
            clickCounter = 0;
            enabledImages = true;
        }

        function startGame() {
            // timer
            $("#timer").removeClass("hide");
            clearInterval(timerHandle);
            milliseconds = 0;

            // stop button
            $("#btnStopGame").removeClass("hide");
            $("#btnStartGame").addClass("hide");

            // images
            $("#people").removeClass("hide");
            getImages();
        }

        // stops the game and hides elements
        function stopGame() {
            clearInterval(timerHandle);
            $("#people").addClass("hide");
            $("#btnStopGame").addClass("hide");
            $("#timer").addClass("hide");
            $("#btnStartGame").removeClass("hide");
        }

        // the game timer
        function timer() {
            if ($('.unmatched').length > 0) {
                milliseconds++;
                $("#timer").html(milliseconds / 100 + " secs");
            }
            else {
                clearInterval(timerHandle);
                alert("Done!");
            }
        }

        // gets all the images in the folder
        function getImages() {
            $.ajax({             
                url: getRootURL() + "/img/memory-game",
                success: function (data) {
                    var arr = [];
                    //get all images
                    $(data).find("a:contains('jpg')").each(function () {
                        // add twice to match
                        arr.push(this.href);
                        arr.push(this.href);
                    });

                    // clear the container
                    $("#people").html("");

                    // shuffle the array & populate container
                    $.each(shuffleArray(arr), function (index, value) {
                        $("#people").append($("<li><a id=" + index + " class='person' data-img=" + value + " href='#'><img width='100%' class='unmatched' src='img/peek.png'></img></a></li>"));
                    });

                    // start timer
                    timerHandle = setInterval(timer, 10);
                }
            });
        };


        // shuffle a array
        function shuffleArray(arr) {
            for (var i = arr.length - 1; i > 0; i--) {
                var j = Math.floor(Math.random() * (i + 1));
                var temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
            return arr;
        };

        // get website root
        function getRootURL() {
            var baseURL = location.href;
            var rootURL = baseURL.substring(0, baseURL.indexOf('/', 7));

            // if the root url is localhost, don't add the directory as cassani doesn't use it
            if (baseURL.indexOf('localhost') == -1) {
                // not localhost
                return rootURL + "/AppName/";
            } else {
                // localhost
                return rootURL + "/Homework/Homework1/";
            }
        };

    </script>
</body>
</html>

