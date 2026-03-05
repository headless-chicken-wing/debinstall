#!/usr/bin/env python3

import tkinter as tk
from roku import Roku
import requests, io
from PIL import Image, ImageTk
roku = Roku('192.168.1.35')


def press_info():
   roku.info()
def press_play():
   roku.play()
def press_forward():
   roku.forward()
def press_reverse():
   roku.reverse()
def press_select():
   roku.select()
def press_left():
   roku.left()
def press_right():
   roku.right()
def press_up():
   roku.up()
def press_down():
   roku.down()
def press_back():
   roku.back()
def press_home():
   roku.home()
def netflix():
   roku['Netflix'].launch()
def prime():
   roku['Prime Video'].launch()
def hbo():
   roku['HBO Max'].launch()
def jellyfin():
   roku['Jellyfin'].launch()
def iheart():
   roku['iHeart'].launch()
def youtube():
   roku['YouTube'].launch()

root = tk.Tk()
my_frame = tk.Frame(root, bg="cyan")
buttons = tk.Frame(root, bg="cyan")
my_frame.grid(row=1, column=1)
buttons.grid(row=1, column=2, columnspan=6)
close_btn = tk.Button(my_frame, text="❌", command=root.destroy).grid(row=1, column=6)

tk.Button(my_frame, text="\u2630", command=press_home).grid(row=1, column=1)
tk.Button(my_frame, text="↑", command=press_up).grid(row=2, column=2)
tk.Button(my_frame, text="←", command=press_left).grid(row=3, column=1)
tk.Button(my_frame, text="ok", command=press_select).grid(row=3, column=2)
tk.Button(my_frame, text="→", command=press_right).grid(row=3, column=3)
tk.Button(my_frame, text="↓", command=press_down).grid(row=4, column=2)
tk.Button(my_frame, text="✱", command=press_info).grid(row=1, column=3)
tk.Button(my_frame, text="\u21A9", command=press_back).grid(row=5, column=1)
tk.Button(my_frame, text="✓", command=press_select).grid(row=5, column=3)
tk.Button(my_frame, text="⏮", command=press_reverse).grid(row=6, column=1)
tk.Button(my_frame, text="▶", command=press_play).grid(row=6, column=2)
tk.Button(my_frame, text="⏭", command=press_forward).grid(row=6, column=3)


app13 = roku['Prime Video']
icon13 = requests.get(f'http://192.168.1.35:8060/query/icon/{app13.id}', timeout=5).content
img13  = Image.open(io.BytesIO(icon13)).resize((72, 56), Image.LANCZOS)
photo13 = ImageTk.PhotoImage(img13)

app12 = roku['Netflix']
icon12 = requests.get(f'http://192.168.1.35:8060/query/icon/{app12.id}', timeout=5).content
img12  = Image.open(io.BytesIO(icon12)).resize((72, 56), Image.LANCZOS)
photo12 = ImageTk.PhotoImage(img12)

app14 = roku['iHeart']
icon14 = requests.get(f'http://192.168.1.35:8060/query/icon/{app14.id}', timeout=5).content
img14  = Image.open(io.BytesIO(icon14)).resize((72, 56), Image.LANCZOS)
photo14 = ImageTk.PhotoImage(img14)

app15 = roku['61322']
icon15 = requests.get(f'http://192.168.1.35:8060/query/icon/{app15.id}', timeout=5).content
img15  = Image.open(io.BytesIO(icon15)).resize((72, 56), Image.LANCZOS)
photo15 = ImageTk.PhotoImage(img15)

app16 = roku['592369']
icon16 = requests.get(f'http://192.168.1.35:8060/query/icon/{app16.id}', timeout=5).content
img16  = Image.open(io.BytesIO(icon16)).resize((72, 56), Image.LANCZOS)
photo16 = ImageTk.PhotoImage(img16)

app17 = roku['837']
icon17 = requests.get(f'http://192.168.1.35:8060/query/icon/{app17.id}', timeout=5).content
img17  = Image.open(io.BytesIO(icon17)).resize((72, 56), Image.LANCZOS)
photo17 = ImageTk.PhotoImage(img17)



#tk.Button(buttons, image=photo12, command=netflix).grid(row=3, column=2)
#tk.Button(buttons, image=photo13, command=prime).grid(row=3, column=1)
#tk.Button(buttons, image=photo14, command=iheart).grid(row=4, column=1)
#tk.Button(buttons, image=photo15, command=hbo).grid(row=4, column=2)
#tk.Button(buttons, image=photo16, command=jellyfin).grid(row=5, column=1)
#tk.Button(buttons, image=photo17, command=youtube).grid(row=5, column=2)

tk.Button(my_frame, image=photo12, command=netflix).grid(row=1, column=5, rowspan=2)
tk.Button(my_frame, image=photo13, command=prime).grid(row=1, column=4, rowspan=2)
tk.Button(my_frame, image=photo14, command=iheart).grid(row=3, column=4, rowspan=2)
tk.Button(my_frame, image=photo15, command=hbo).grid(row=3, column=5, rowspan=2)
tk.Button(my_frame, image=photo16, command=jellyfin).grid(row=5, column=4, rowspan=2)
tk.Button(my_frame, image=photo17, command=youtube).grid(row=5, column=5, rowspan=2)








root.overrideredirect(True)
root.mainloop()




quit()
