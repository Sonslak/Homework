$(document).ready(function () {

    // get all images in folder
    getImages();

});


$('#people').on('click', '.person', function (event) {


    // prevent default action
    event.preventDefault();
  
    if ($("#click-enabled").attr('value') == "true")
    {
        $("#click-enabled").attr('value', "false");

        var that = $(this);
        var prev = $("#" + $("#prev-id").attr('value'));

        // set image
        that.children('img').attr('src', that.attr('data-img'));

        // increase counter
        var counter = $("#click-count").attr('value');
        counter++;
        $("#click-count").attr('value', counter);

        //// values
        console.log("current:" + that.attr("data-img"));
        console.log("prev: " + prev.attr('value') + " " + prev.children('img').attr("src"));

        if (counter >= 2)
        {
            if (counter == 2) {
              
                if (that.attr("data-img") == prev.children('img').attr("src")) {

                    that.children('img').addClass('matched');
                    prev.children('img').addClass('matched');
                }
            }

            // set prev clicked
            prev.attr('value', that.attr('id'));

            setTimeout('resetAll()', 500);

        }
        else
        {        
            $("#click-enabled").attr('value', "true");

            // set prev clicked
            prev.attr('value', that.attr('id'));
        }
   
        $("#prev-id").attr('value', $(this).attr('id'));     
    }
});


function resetAll()
{
    $("#people").find("img").map(function () {
        if (!$(this).hasClass('matched'))
        {
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
        url: getRootURL() +  "/img/memory-game",
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
                
                $("#people").append($("<li><a id=" + index + " class='person' data-img=" + value + " href='#'><img width='100%' src='img/peek.png'></img></a></li>"));
            });

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





 
