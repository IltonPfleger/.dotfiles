#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <signal.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

char str[64];

char *get_internet()
{
    str[0] = '\0';
    char path[512];
    struct dirent *entry;
    DIR *ifs = opendir("/sys/class/net");
    while ((entry = readdir(ifs)) != NULL) {
        char *ifname = entry->d_name;
        if (ifname[0] == '.') continue;
        if (ifname[0] == 'l' && ifname[1] == 'o') continue;

        sprintf(path, "/sys/class/net/%s/carrier", ifname);
        FILE *carrier = fopen(path, "r");

        if (fgetc(carrier) == '1') {
            sprintf(path, "/sys/class/net/%s/wireless", ifname);
            DIR *wireless = opendir(path);
            if (wireless) {
                closedir(wireless);
                strcat(str, "  ");
            } else {
                strcat(str, "  ");
            }
        }
        fclose(carrier);
    }
    closedir(ifs);
    return str;
}

char *get_bluetooth()
{
    str[0]     = '\0';
    FILE *file = popen(
        "timeout 0.05s bluetoothctl show 2>/dev/null | grep -q 'Powered: yes' && (timeout 0.05s bluetoothctl devices "
        "Connected 2>/dev/null | grep "
        "-q . && echo '' || echo '')",
        "r");
    if (file) {
        if (fgets(str, sizeof(str), file)) {
            str[strcspn(str, "\n")] = '\0';
        };
    }
    pclose(file);
    return str;
}

char *get_battery()
{
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

char *get_microphone()
{
    FILE *file = popen(
        "pactl get-source-mute @DEFAULT_SOURCE@ 2>/dev/null | grep -q 'Mute: yes' && echo '' || "
        "(pactl get-source-volume @DEFAULT_SOURCE@ 2>/dev/null | grep -o '[0-9]*%' | head -n1 | "
        "sed 's/^/ /' 2>/dev/null)",
        "r");
    if (file) {
        if (fgets(str, sizeof(str), file)) {
            str[strcspn(str, "\n")] = '\0';
        };
    }
    pclose(file);
    return str;
}

char *get_volume()
{
    static char MUTE[] = "";
    FILE *file         = popen("wpctl get-volume @DEFAULT_SINK@", "r");
    if (!file) return "";
    if (fgets(str, sizeof(str), file) == NULL) {
        pclose(file);
        return MUTE;
    }
    pclose(file);

    float volume = 0.0f;
    int muted    = strstr(str, "MUTED") != NULL;

    if (sscanf(str, "Volume: %f", &volume) == 1 && !muted)
        sprintf(str, " %d%%", (int)(volume * 100));
    else
        return MUTE;
    return str;
}

char *get_date()
{
    time_t t           = time(NULL);
    struct tm *tm_info = localtime(&t);
    strftime(str, sizeof(str), " %A, %B %d, %Y", tm_info);
    return str;
}

char *get_time()
{
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
    timeout.tv_sec  = 40;
    timeout.tv_nsec = 0;
    sigemptyset(&mask);
    sigaddset(&mask, SIGUSR1);
    sigprocmask(SIG_BLOCK, &mask, NULL);

    printf("{ \"version\": 1 }\n[\n");
    while (true) {
        printf("[");
        printf("{\"full_text\":\"%s\"},", get_internet());
        printf("{\"full_text\":\"%s\"},", get_bluetooth());
        printf("{\"full_text\":\"%s\"},", get_battery());
        printf("{\"full_text\":\"%s\"},", get_backlight());
        printf("{\"full_text\":\"%s\"},", get_volume());
        printf("{\"full_text\":\"%s\"},", get_microphone());
        printf("{\"full_text\":\"%s\"},", get_date());
        printf("{\"full_text\":\"%s\"}", get_time());
        printf("],\n");
        fflush(stdout);
        sigtimedwait(&mask, NULL, &timeout);
    }
    return 0;
}
