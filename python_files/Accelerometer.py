import serial # type: ignore
import numpy as np # type: ignore
import matplotlib.pyplot as plt # type: ignore
from mpl_toolkits.mplot3d import Axes3D # type: ignore
import matplotlib.animation as animation # type: ignore

# Setup serial connection with Arduino(Kono Serial Monitor or Serial Plotter open rakha jabe na.)
ser = serial.Serial('COM7', 9600)  #Serial('<Port>', <Baud Rate>)

def get_acceleration_data():
    while True:
        try:
            line = ser.readline().decode('utf-8').strip()
            parts = line.split('|')
            if len(parts) == 3:
                ax = int(parts[0].split('=')[1].strip())
                ay = int(parts[1].split('=')[1].strip())
                az = int(parts[2].split('=')[1].strip())
                return ax, ay, az
        except (IndexError, ValueError): #For error control
            continue

def update_plot(frame, ax, xline, yline, zline):
    # Graph a x, y, z axis ar limit set kora
    ax.set_xlim([-10000, 10000]) 
    ax.set_ylim([-10000, 10000])
    ax.set_zlim([-10000, 10000])
    
    # Graph a x, y, z axis ar lable set kora
    ax.set_xlabel('X') 
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    
    ax_data, ay_data, az_data = get_acceleration_data()
    
    yline.set_data([0, ax_data], [0, ay_data])
    yline.set_3d_properties([0, az_data])
    
    zline.set_data([0, ax_data], [0, ay_data])
    zline.set_3d_properties([0, az_data])

    return zline,

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Graph a x, y, z axis indicate korar jonno line ar origin and color set kora
xline, = ax.plot([0, 0], [0, 0], [0, 0], 'r-') # x axis from (0,0,0) and color red
yline, = ax.plot([0, 0], [0, 0], [0, 0], 'g-') # y axis from (0,0,0) and color green
zline, = ax.plot([0, 0], [0, 0], [0, 0], 'b-') # z axis from (0,0,0) and color blue

ani = animation.FuncAnimation(fig, update_plot, fargs=(ax, xline, yline, zline), interval=25, blit=False)

plt.show()
