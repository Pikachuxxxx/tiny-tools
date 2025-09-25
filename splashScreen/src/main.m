#import <Cocoa/Cocoa.h>

// clang -framework Foundation -framework Cocoa ./src/main.m -o ./bin/main && ./bin/main

void print()
{
    NSLog(@"Helo world!");
}

@interface SampleClass:NSObject
- (NSImage *)resizedImage:(NSImage *)sourceImage toPixelDimensions:(NSSize)newSize;
- (void) RunApp;
- (void) SplashScreen:(void *)arg1 yourView:(NSView *)view;
@end

@implementation SampleClass
- (NSImage *)resizedImage:(NSImage *)sourceImage toPixelDimensions:(NSSize)newSize {
    if (! sourceImage.isValid) return nil;

    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
              initWithBitmapDataPlanes:NULL
                            pixelsWide:newSize.width
                            pixelsHigh:newSize.height
                         bitsPerSample:8
                       samplesPerPixel:4
                              hasAlpha:YES
                              isPlanar:NO
                        colorSpaceName:NSCalibratedRGBColorSpace
                           bytesPerRow:0
                          bitsPerPixel:0];
    rep.size = newSize;

    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
    [sourceImage drawInRect:NSMakeRect(0, 0, newSize.width, newSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [NSGraphicsContext restoreGraphicsState];

    NSImage *newImage = [[NSImage alloc] initWithSize:newSize];
    [newImage addRepresentation:rep];
    return newImage;
}

- (void) RunApp {
    @autoreleasepool {

        NSRect screenRect;
    NSArray *screenArray = [NSScreen screens];
    unsigned screenCount = [screenArray count];
    unsigned index  = 0;

    for (;index < screenCount; index++)
    {
        NSScreen *screen = [screenArray objectAtIndex: index];
        screenRect = [screen visibleFrame];
    }
    NSLog(@"%f and %f",    screenRect.size.width, screenRect.size.height);

        int width = 480, height = 320;
        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        id applicationName = [[NSProcessInfo processInfo] processName];
        NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, width, height)
           styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
        [window setFrameOrigin:NSMakePoint((screenRect.size.width / 2) - (width / 2) + 50, (screenRect.size.height / 2) - (height / 2))];
        [window setTitle: applicationName];
        NSImage *image = [[NSImage alloc]initWithContentsOfFile:@"./RazixSplashScreenDev.bmp"];
        if (image == nil) {
            NSLog(@"image nil");
        }
        NSLog(@"%f and %f",image.size.width, image.size.height);

        // SampleClass *sampleClass = [[SampleClass alloc]init];

        print();

        // self = this pointer, since it's a member function it has access to self
        image = [self resizedImage:image toPixelDimensions:NSMakeSize(width, height)];\

        // Quit
        //
        id menubar = [[NSMenu new] autorelease];
        id appMenuItem = [[NSMenuItem new] autorelease];
        [menubar addItem:appMenuItem];
        [NSApp setMainMenu:menubar];
        id appMenu = [[NSMenu new] autorelease];
        id appName = [[NSProcessInfo processInfo] processName];
        id quitTitle = [@"Quit " stringByAppendingString:appName];
        id quitMenuItem = [[[NSMenuItem alloc] initWithTitle:quitTitle action:@selector(terminate:) keyEquivalent:@"q"] autorelease];
        [appMenu addItem:quitMenuItem];
        [appMenuItem setSubmenu:appMenu];
        //

        NSTextField *yourLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, -(height * 1.0/5.0) + 40, width , height * 1.0/4.0)];
        yourLabel.editable = false;
        yourLabel.bezeled = false;
        [yourLabel setTextColor:[NSColor whiteColor]];
        // [yourLabel setTextColor:[NSColor blackColor]];
        [yourLabel setBackgroundColor:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
        [yourLabel setFont:[NSFont fontWithName:@"CourierNewPSMT" size:14]];
        yourLabel.stringValue = [NSString stringWithFormat:@"Starting up Logging system..."];


        NSTextField *yourLabel2 = [[NSTextField alloc] initWithFrame:NSMakeRect(20, -(height * 1.0/5.0) + 20, width , height * 1.0/4.0)];
        yourLabel2.editable = false;
        yourLabel2.bezeled = false;
        [yourLabel2 setTextColor:[NSColor whiteColor]];
        // [yourLabel2 setTextColor:[NSColor blackColor]];
        [yourLabel2 setBackgroundColor:[NSColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
        [yourLabel2 setFont:[NSFont fontWithName:@"CourierNewPSMT" size:12]];
        yourLabel2.stringValue = [NSString stringWithFormat:@"Setting up sinks for spdlog"];

        // yourLabel.stringValue = [NSString stringWithFormat:@"Ahaaa..."];

        // yourLabel.alignment = NSTextAlignmentCenter;
        [window.contentView addSubview:yourLabel];
        [window.contentView addSubview:yourLabel2];

        [window setBackgroundColor:[NSColor colorWithPatternImage:image]];
        [window makeKeyAndOrderFront:nil];
        [NSApp activateIgnoringOtherApps:YES];
        [NSApp run];

    }
}

- (void) SplashScreen:(void *)arg1 yourView:(NSView *)view {

    }

@end

int main (int argc, const char * argv[]){

    print();

    NSLog(@"Starting Application!");
    SampleClass *sampleClass = [[SampleClass alloc]init];
    [sampleClass RunApp];
    NSLog(@"Starting Application!");

    return 0;
}
