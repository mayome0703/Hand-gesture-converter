import serial
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Set up the serial port (make sure the correct port is set)
serial_port = 'COM7'  # Replace with your Arduino's serial port
baud_rate = 9600
ser = serial.Serial(serial_port, baud_rate)

# Update function to get data from both sensors
def update_plot(frame, ax_3d, zline, bendable_lines, static_lines):
    flex = []
    for i in range(2):  # Read up to two lines
        try:
            line = ser.readline().decode('utf-8').strip()
            parts = line.split('|')
            if len(parts) == 8:
                # Parse accelerometer data
                ax = int(parts[0].split('=')[1].strip())
                ay = int(parts[1].split('=')[1].strip())
                az = int(parts[2].split('=')[1].strip())
                # Parse flex sensor data
                f1 = float(parts[3].split('=')[1].strip())
                f2 = float(parts[4].split('=')[1].strip())
                f3 = float(parts[5].split('=')[1].strip())
                f4 = float(parts[6].split('=')[1].strip())
                f5 = float(parts[7].split('=')[1].strip())

                flex = [f1, f2, f3, f4, f5]
                break
        except:
            continue

    # Default to no flex if no data
    if not flex:
        flex = [0, 0, 0, 0, 0]

    # Update the 3D accelerometer plot
    zline.set_data([0, -ay], [0, ax])
    zline.set_3d_properties([0, az])

    # Update the flex sensor plot
    for i in range(5):
        current_angle_rad = -flex[i] * np.pi / 180

        x_offset = -2 + i * 1  # Offset the lines horizontally for separation
        y_bendable = np.array([0, 0.75])  # The bendable portion of the line (length = 1 unit)

        x_bendable = y_bendable * np.sin(current_angle_rad)
        y_bendable = y_bendable * np.cos(current_angle_rad)

        bendable_lines[i].set_data(x_bendable + x_offset, y_bendable)
        static_lines[i].set_data([x_offset, x_offset], [-.75, 0])

    return zline, *bendable_lines, *static_lines

# Set up the figure and axis
fig = plt.figure(figsize=(10, 5))
ax_3d = fig.add_subplot(121, projection='3d')
ax_flex = fig.add_subplot(122)

# 3D Accelerometer plot setup
ax_3d.set_xlim([-10000, 10000])
ax_3d.set_ylim([-10000, 10000])
ax_3d.set_zlim([-10000, 10000])
ax_3d.set_xlabel('X')
ax_3d.set_ylabel('Y')
ax_3d.set_zlabel('Z')
zline, = ax_3d.plot([0, 0], [0, 0], [0, 0], 'b-')

# Flex sensor plot setup
ax_flex.set_xlim(-3, 3)
ax_flex.set_ylim(-1, 1)
bendable_lines = [ax_flex.plot([], [], lw=2, color='blue')[0] for _ in range(5)]
static_lines = [ax_flex.plot([], [], lw=2, color='black')[0] for _ in range(5)]

# Animation function to update both plots
ani = animation.FuncAnimation(fig, update_plot, fargs=(ax_3d, zline, bendable_lines, static_lines), frames=1, interval=100, blit=False)

plt.show()
