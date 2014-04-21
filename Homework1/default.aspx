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
            padding: 5x;
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
        <h1>Cergis Memory Game</h1>
        <h2><label id="timer"></label></h2>
        <input type="button" value="Start Game" id="btnStartGame" onclick="startGame()" />
        <input type="button" value="Stop Game" class="hide" id="btnStopGame" onclick="stopGame()" />
        <ul id="people" class="hide">
        </ul>
    </div>
    <input type="hidden" id="prev-id" value="0" />
    <input type="hidden" id="click-count" value="0" />
    <input type="hidden" id="click-enabled" value="true" />

    <!-- jquery -->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script type="text/javascript">
        var timerHandle;
        var milliseconds = 0;

        function startGame() {

            // clear the timer
            clearInterval(timerHandle);
            count = 0;

            // change text
            $("#btnStartGame").prop('value', 'Restart Game');
            $("#btnStopGame").removeClass("hide");

            // get all images in folder
            $("#people").html("");
            $("#people").removeClass("hide");
            getImages();
        }

        function stopGame() {
            clearInterval(timerHandle);
            $("#people").addClass("hide");
            $("#btnStopGame").addClass("hide");
            $("#btnStartGame").prop('value', 'Start Game');
            $("#timer").html("");
        }

        function timer() {
            if ($('.unmatched').length > 0) {
                milliseconds++;
                $("#timer").html(milliseconds / 100 + " secs");
            }
            else {
                alert("Done!");
                clearInterval(timerHandle);
            }
        }

        $('#people').on('click', '.person', function (event) {

            // prevent default action
            event.preventDefault();

            if ($("#click-enabled").attr('value') == "true") {
                $("#click-enabled").attr('value', "false");

                var that = $(this);
                var prev = $("#" + $("#prev-id").attr('value'));

                // set image
                that.children('img').attr('src', that.attr('data-img'));

                // increase counter
                var counter = $("#click-count").attr('value');
                counter++;
                $("#click-count").attr('value', counter);
                if (counter >= 2) {
                    if (counter == 2) {
                        if (that.attr("data-img") == prev.children('img').attr("src")) {
                            that.children('img').removeClass('unmatched');
                            prev.children('img').removeClass('unmatched');
                            that.children('img').addClass('matched');
                            prev.children('img').addClass('matched');
                        }
                    }

                    // set prev clicked
                    prev.attr('value', that.attr('id'));
                    setTimeout('resetAllImages()', 500);
                }
                else {
                    $("#click-enabled").attr('value', "true");

                    // set prev clicked
                    prev.attr('value', that.attr('id'));
                }

                $("#prev-id").attr('value', $(this).attr('id'));
            }
        });


        function resetAllImages() {
            $("#people").find("img").map(function () {
                if (!$(this).hasClass('matched')) {
                    $(this).attr('src', "img/peek.png");
                }
            })

            $("#click-last").attr('value', "0");
            $("#click-count").attr('value', "0");
            $("#click-enabled").attr('value', "true");
        }

        function getImages() {
            $.ajax({
                //This will retrieve the contents of the folder if the folder is configured as 'browsable'
                url: getRootURL() + "/img/memory-game",
                success: function (data) {

                    var arr = [];

                    //get all images
                    $(data).find("a:contains('jpg')").each(function () {
                        // add twice to match
                        arr.push(this.href);
                        arr.push(this.href);
                    });

                    // shuffle
                    var suffleArr = shuffleArray(arr);
                    $.each(suffleArr, function (index, value) {

                        $("#people").append($("<li><a id=" + index + " class='person' data-img=" + value + " href='#'><img width='100%' class='unmatched' src='img/peek.png'></img></a></li>"));
                    });


                    // start timer
                    timerHandle = setInterval(timer, 10);
                }
            });
        };

        function shuffleArray(array) {
            for (var i = array.length - 1; i > 0; i--) {
                var j = Math.floor(Math.random() * (i + 1));
                var temp = array[i];
                array[i] = array[j];
                array[j] = temp;
            }
            return array;
        };


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
