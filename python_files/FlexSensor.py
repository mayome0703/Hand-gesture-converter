import serial
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Set up the serial port
serial_port = 'COM7'  # Replace with your Arduino's serial port
baud_rate = 9600

ser = serial.Serial(serial_port, baud_rate)

def update(val):
    flex = []
    for i in range(2):
        try:
            line = ser.readline().decode('utf-8').strip()
            parts = line.split('|')
            if len(parts) == 8:
                ax = int(parts[0].split('=')[1].strip())
                ay = int(parts[1].split('=')[1].strip())
                az = int(parts[2].split('=')[1].strip())
                f1 = float(parts[3].split('=')[1].strip())
                f2 = float(parts[4].split('=')[1].strip())
                f3 = float(parts[5].split('=')[1].strip())
                f4 = float(parts[6].split('=')[1].strip())
                f5 = float(parts[7].split('=')[1].strip())
                
                flex = [f1, f2, f3, f4, f5]
                break
        except:
            continue

    if not flex:
        flex = [0, 0, 0, 0, 0]
    
    for i in range(5): 
        current_angle_rad = -flex[i] * np.pi / 180
        
        x_offset = -2 + i * 1 # Offset the lines horizontally for separation
        y_bendable = np.array([0, 0.75]) # The bendable portion of the line (length = 1 unit, from y = 0 to y = 0.75)
        
        x_bendable = y_bendable * np.sin(current_angle_rad) # Apply the bending transformation to the bendable part
        y_bendable = y_bendable * np.cos(current_angle_rad) # Apply the bending transformation to the bendable part
        
        bendable_lines[i].set_data(x_bendable + x_offset, y_bendable) # Set the new data for each bendable line segment
        static_lines[i].set_data([x_offset, x_offset], [-.75, 0]) # Set the data for the static vertical lines
    
    fig.canvas.draw_idle()  # Redraw the canvas


# Set up the figure and axis
fig, ax = plt.subplots(1,2)

ax[0].set_xlim(-3, 3)
ax[0].set_ylim(-1, 1)

bendable_lines = [ax[0].plot([], [], lw=2, color='blue')[0] for _ in range(5)] # Create five bendable line segments (vertically aligned)
static_lines = [ax[0].plot([], [], lw=2, color='black')[0] for _ in range(5)] # Create five static vertical lines

# Initial plot
update(0)

ani = animation.FuncAnimation(fig, update,frames=1, interval=100, blit=False)

plt.show()
