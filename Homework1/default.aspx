<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="_default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Memory game</title>
    <link href="css/main.css" rel="stylesheet" />
</head>
<body>
    <div class="container">
        <h1>Cergis Memory Game</h1>
        

         <h2><label id="timer" data-seconds="0" ></label></h2>

        <input type="button" value="Start Game" id="btnStartGame" onclick="startGame()" />
        <ul id="people" class="hide">
        </ul>
        
    </div>
    <input type="hidden" id="prev-id" value="0" />
    <input type="hidden" id="click-count" value="0" />
    <input type="hidden" id="click-enabled" value="true" />



    <!-- jquery -->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>


    <script src="js/global.js"></script>
</body>
</html>
