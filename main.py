import time, sensor, image,pyb
from image import SEARCH_EX, SEARCH_DS
from pyb import UART
# Reset sensor
sensor.reset()
# Set sensor settings
sensor.set_contrast(1)
sensor.set_gainceiling(16)
# Max resolution for template matching with SEARCH_EX is QQVGA
sensor.set_framesize(sensor.QQVGA)
# You can set windowing to reduce the search image.
#sensor.set_windowing(((640-80)//2, (480-60)//2, 80, 60))
sensor.set_pixformat(sensor.GRAYSCALE)

template = image.Image("/C2.pgm")
clock = time.clock()
uart = UART(3, 9600)
# Run template matching
while (True):
    clock.tick()
    img = sensor.snapshot()
    # find_template(template, threshold, [roi, step, search])
    # ROI: The region of interest tuple (x, y, w, h).
    # Step: The loop step used (y+=step, x+=step) use a bigger step to make it faster.
    # Search is either image.SEARCH_EX for exhaustive search or image.SEARCH_DS for diamond search
    # Note1: ROI has to be smaller than the image and bigger than the template.
    # Note2: In diamond search, step and ROI are both ignored.
    l = img.find_template(template, 0.5, step=4, search=SEARCH_EX) #, roi=(10, 0, 60, 60))
    if l:
        img.draw_rectangle(l)
        #uart.write('1')
        led=pyb.LED(1)
        led.on()
        led=pyb.LED(2)
        led.off()
        print('find it')
    else :
        led=pyb.LED(1)
        led.off()
        led=pyb.LED(2)
        led.on()
        #print('0')
        #uart.write('0')
    #print(clock.fps())
