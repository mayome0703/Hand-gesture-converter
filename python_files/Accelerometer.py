import serial
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Setup serial connection with Arduino
serial_port = 'COM7'  # Replace with your Arduino's serial port
baud_rate = 9600

ser = serial.Serial(serial_port, baud_rate)

def update_plot(frame, ax, zline):
    for i in range(2):
        try:
            line = ser.readline().decode('utf-8').strip()
            parts = line.split('|')
            if len(parts) == 8:
                ax = int(parts[0].split('=')[1].strip())
                ay = int(parts[1].split('=')[1].strip())
                az = int(parts[2].split('=')[1].strip())
                f1 = int(parts[3].split('=')[1].strip())
                f2 = int(parts[4].split('=')[1].strip())
                f3 = int(parts[5].split('=')[1].strip())
                f4 = int(parts[6].split('=')[1].strip())
                f5 = int(parts[7].split('=')[1].strip())
                
                break
        except:
            continue
    
    zline.set_data([0, -ay], [0, ax])
    zline.set_3d_properties([0, az])
    
    return zline,

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Set limits only once outside the update function
ax.set_xlim([-10000, 10000])
ax.set_ylim([-10000, 10000])
ax.set_zlim([-10000, 10000])

# Set labels only once outside the update function
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

# Initialize the line once
zline, = ax.plot([0, 0], [0, 0], [0, 0], 'b-')
# time.sleep(2)
ani = animation.FuncAnimation(fig, update_plot, fargs=(ax, zline),frames=1, interval=100, blit=False)

plt.show()