<%@ Page Language="VB" AutoEventWireup="true" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Threading" %>

<script runat="server">
    Sub Page_Load()
        Dim delay As Byte() = New Byte(0) {}
        Dim prng As RandomNumberGenerator = New RNGCryptoServiceProvider()
        
        prng.GetBytes(delay)
        Thread.Sleep(CType(delay(0), Integer))
        
        Dim disposable As IDisposable = TryCast(prng, IDisposable)
        If Not disposable Is Nothing Then
            disposable.Dispose()
        End If
    End Sub
</script>

<html>
<head id="Head1" runat="server">
    <title>Mendoza College of Business</title>
</head>
<body>
    <div>
        We're sorry.  An error has occurred.  Please try again.
    </div>
</body>
</html>