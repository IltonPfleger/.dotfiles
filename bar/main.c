#include <X11/Xlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

char *get_battery()
{
    static char str[16];
    int battery;
    FILE *file = fopen("/sys/class/power_supply/BAT1/capacity", "r");
	if(file == NULL) {
		str[0] = '\0';
	}
	else {
		fscanf(file, "%d", &battery);
		fclose(file);
		file = fopen("/sys/class/power_supply/BAT1/status", "r");
		char isCharging = fgetc(file);
		if(isCharging == 'C') {
			sprintf(str, " %d%%", battery);
		} else if (battery > 80) {
            sprintf(str, " %d%%", battery);
        } else if (battery > 60) {
            sprintf(str, " %d%%", battery);
        } else if (battery > 40) {
            sprintf(str, " %d%%", battery);
        } else if (battery > 20) {
            sprintf(str, " %d%%", battery);
        } else {
            sprintf(str, " %d%%", battery);
        }
		fclose(file);
    }
    return str;
}

char *get_backlight()
{
	static const int max_backlight = 96000;
    static char str[16];
    int backlight;
    FILE *file = fopen("/sys/class/backlight/intel_backlight/brightness", "r");
    if (file == NULL) {
		str[0] = '\0';
    } else {
		fscanf(file, "%d", &backlight);
        sprintf(str, " %d%%", (backlight*100)/max_backlight);
		fclose(file);
    }
    return str;
}

char *get_date_and_time()
{
    static char str[64];
    time_t t           = time(NULL);
    struct tm *tm_info = localtime(&t);
    strftime(str, sizeof(str), "%A, %B %d, %Y | %H:%M", tm_info);
    return str;
}

char *get_volume()
{
    static char str[8];
    static char const *NO_AUDIO = " ";
    FILE *file                  = popen("wpctl get-volume @DEFAULT_SINK@", "r");
    char buffer[128];

    if (fgets(buffer, sizeof(buffer), file) == NULL) {
        strcpy(str, NO_AUDIO);
    } else {
        float volume = 0.0f;
        int muted    = strstr(buffer, "MUTED") != NULL;
        if (sscanf(buffer, "Volume: %f", &volume) == 1 && !muted)
            sprintf(str, "  %d%%", (int)(volume * 100));
        else
            strcpy(str, NO_AUDIO);
    }

    pclose(file);
    return str;
}

int main(int, char **)
{
    static char str[256];
    setenv("XDG_RUNTIME_DIR", "/run/user/1000", 1);
    Display *display = XOpenDisplay(NULL);
    if (display == NULL) {
        fprintf(stderr, "Unable to open X display\n");
        return 1;
    }

    Window root = DefaultRootWindow(display);
    while (true) {
        sprintf(str, "%s | %s | %s | %s", get_battery(), get_backlight(), get_volume(), get_date_and_time());
        XStoreName(display, root, str);
        XSync(display, False);
		usleep(500);
    }
    XCloseDisplay(display);
    return 0;
}
