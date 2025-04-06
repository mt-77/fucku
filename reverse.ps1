$client = New-Object System.Net.Sockets.TCPClient('129.226.212.179',4444);
$stream = $client.GetStream();
$message = "Test connection from PowerShell"
$sendbyte = [System.Text.Encoding]::ASCII.GetBytes($message);
$stream.Write($sendbyte,0,$sendbyte.Length);
$stream.Flush();
Start-Sleep -Seconds 10
$client.Close()
