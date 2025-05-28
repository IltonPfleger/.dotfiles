#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <signal.h>

char *get_bluetooth()
{
    FILE *file = popen("timeout 0.05s bluetoothctl show | grep -o 'Powered: yes'", "r");
    if (!file) return "";
    if (fgetc(file) == EOF) {
        pclose(file);
        return "";
    }
	pclose(file);
    file = popen("timeout 0.05s bluetoothctl devices Connected", "r");
    if (!file) return "";
    if (fgetc(file) != EOF) {
        pclose(file);
        return "";
    }
    pclose(file);
    return "";
}

char *get_battery()
{
    static char str[32];
    int battery;
    FILE *file = fopen("/sys/class/power_supply/BAT1/capacity", "r");
    if (file == NULL) {
        str[0] = '\0';
    } else {
        fscanf(file, "%d", &battery);
        fclose(file);
        file            = fopen("/sys/class/power_supply/BAT1/status", "r");
        char isCharging = fgetc(file);
        if (isCharging == 'C') {
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
        sprintf(str, " %d%%", (backlight * 100) / max_backlight);
        fclose(file);
    }
    return str;
}

char *get_volume()
{
    static char str[8];
    static char const *NO_AUDIO = "";
    FILE *file                  = popen("timeout 0.05s wpctl get-volume @DEFAULT_SINK@", "r");
    char buffer[128];

    if (fgets(buffer, sizeof(buffer), file) == NULL) {
        strcpy(str, NO_AUDIO);
    } else {
        float volume = 0.0f;
        int muted    = strstr(buffer, "MUTED") != NULL;
        if (sscanf(buffer, "Volume: %f", &volume) == 1 && !muted)
            sprintf(str, " %d%%", (int)(volume * 100));
        else
            strcpy(str, NO_AUDIO);
    }

    pclose(file);
    return str;
}

char *get_date()
{
    static char str[64];
    time_t t           = time(NULL);
    struct tm *tm_info = localtime(&t);
    strftime(str, sizeof(str), " %A, %B %d, %Y", tm_info);
    return str;
}

char *get_time()
{
    static char str[16];
    time_t t           = time(NULL);
    struct tm *tm_info = localtime(&t);
    strftime(str, sizeof(str), " %H:%M", tm_info);
    return str;
}

int main(int, char **)
{
    FILE *file = fopen("/tmp/bar.pid", "w");
    if (file) fprintf(file, "%d\n", getpid());
    fclose(file);
    sigset_t mask;
    struct timespec timeout;
    timeout.tv_sec  = 30;
    timeout.tv_nsec = 0;
    sigemptyset(&mask);
    sigaddset(&mask, SIGUSR1);
    sigprocmask(SIG_BLOCK, &mask, NULL);

    printf("{ \"version\": 1 }\n[\n");
    bool first = true;
    while (true) {
        if (!first) printf(",\n");
        first = false;
        printf("[");
        printf("{\"full_text\":\"%s\"},", get_bluetooth());
        printf("{\"full_text\":\"%s\"},", get_battery());
        printf("{\"full_text\":\"%s\"},", get_backlight());
        printf("{\"full_text\":\"%s\"},", get_volume());
        printf("{\"full_text\":\"%s\"},", get_date());
        printf("{\"full_text\":\"%s\"}", get_time());
        printf("]");
        fflush(stdout);
        sigtimedwait(&mask, NULL, &timeout);
    }
    return 0;
}
