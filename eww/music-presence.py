from pypresence import Presence
import re, json
from time import time


RPC = Presence("1086258743823564903")

RPC.connect()

with open("/tmp/yt-music/current",'r') as file:
    li = re.split(' >|: | - ',file.readline().strip('\n'))
    file.close()
RPC.update(large_image=f"https://i.ytimg.com/vi/{li[-1]}/mqdefault.jpg",details=f"{li[1]}",state=li[2],small_image="/home/tanveer/Downloads/kisspng-mpv-logo-computer-software-5b0b2bfe514221.6053513215274588143328.png",start=time.time())
