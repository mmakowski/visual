CC = gcc
CFLAGS = $(shell pkg-config --cflags --libs gstreamer-0.10)

hc: hc.c
	$(CC) hc.c $(CFLAGS) -o hc

clean:
	rm -f hc
