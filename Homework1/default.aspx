<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="_default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Memory game</title>
    <link href="css/main.css" rel="stylesheet" />
</head>
<body>

    <ul id="people">
    </ul>

    <input type="hidden" id="prev-clicked-id" value="0" />
    <input type="hidden" id="click-count" value="0" />
    <input type="hidden" id="click-enabled" value="true" />

  

    <!-- jquery -->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>


    <script src="js/global.js"></script>
</body>
</html>