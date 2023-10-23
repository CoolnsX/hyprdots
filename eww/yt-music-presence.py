import socket
import time,re
from pypresence import Presence

def update():
    # Get the duration information
    time.sleep(2)

    # Update Discord Rich Presence with the end timestamp
    with open("/tmp/yt-music/current", 'r') as file:
        li = re.split(' >|: | - ', file.readline().strip('\n'))
        file.close()

    print(li)
    # Update Discord Rich Presence with the information from the file
    RPC.update(
        large_image=f"https://i.ytimg.com/vi/{li[-1]}/mqdefault.jpg",
        details=f"{li[1]}",
        large_text = "Checkmate Premium Users",
        state=li[2],
        start=int(time.time()),
    )

socket_path = "/tmp/yt-music/yt-music-mpvsocket"

# Initialize Discord Rich Presence
RPC = Presence("1165951947245879316")
RPC.connect()

# Create a UNIX socket
mpv_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
mpv_socket.connect(socket_path)
update()
while True:
    event = mpv_socket.recv(1024).decode('utf-8')
    # Adjust the buffer size as needed
    if not event:
        break
    #check if event contains "end-file" or "eof"
    if "end-file" in event or "eof" in event:
        print(event)
        update()

mpv_socket.close()
RPC.close()
