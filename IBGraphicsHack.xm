#import <sys/sysctl.h>
#import <substrate.h>

static const char *model;
static int profile = 0;
static BOOL tweakEnabled = NO;

#define PreferencesChangedNotification "com.PS.IBGraphicsHack.prefs"
#define PREF_PATH @"/var/mobile/Library/Preferences/com.PS.IBGraphicsHack.plist"

static void IBLoader()
{
	NSDictionary *prefDict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
	tweakEnabled = [[prefDict objectForKey:@"IBGraphicsHackEnabled"] boolValue];
	id o = [prefDict objectForKey:@"GraphicsProfile"];
	if (o == nil) {
		profile = 0;
		return;
	}
	profile = [o intValue];
	switch (profile) {
		case 1:
			model = "iPhone2,1"; break;
		case 2:
			model = "iPhone3,1"; break;
		case 3:
			model = "iPad1,1"; break;
		case 4:
			model = "iPhone4,1"; break;
		case 5:
			model = "iPad2,1"; break;
		case 6:
			model = "iPad3,1"; break;
		case 7:
			model = "iPhone5,1"; break;
		case 8:
			model = "iPad4,1"; break;
		case 9:
			model = "iPhone6,1"; break;
		case 10:
			model = "iPad4,1"; break;
	}
}

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	IBLoader();
}

static int (*orig_ctl)(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen);
int replaced_ctl(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen) {
    if (strcmp(name, "hw.machine") == 0) {
    	if (tweakEnabled && profile != 0) {
    		if (oldp)
        		strcpy((char *)oldp, model);
        	*oldlenp = sizeof(model);
    	}
    }
    return orig_ctl(name, oldp, oldlenp, newp, newlen);
}


__attribute__((constructor)) static void IBHackInit()
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	IBLoader();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesChangedCallback, CFSTR(PreferencesChangedNotification), NULL, CFNotificationSuspensionBehaviorCoalesce);
    MSHookFunction((void *)sysctlbyname, (void *)replaced_ctl, (void **)&orig_ctl);
    [pool drain];
}
