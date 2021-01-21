//
//  ViewController.m
//  Bitcoin Monitor
//
//  Created by SuperHacker UEFI on 5/7/20.
//  Copyright © 2020 SuperHacker UEFI. All rights reserved.
//

#import "ViewController.h"
int flags = 0;
@implementation ViewController
- (IBAction)bugsel:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.label setTextColor:[NSColor yellowColor]];
    });
    flags = 0;
}
- (IBAction)sellsel:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.label setTextColor:[NSColor greenColor]];
    });
    flags = 1;
}
- (void) doSomethingWhenTimeIsUp:(NSTimer*)t {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *url = [NSURL URLWithString:@"https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC&tsyms=USD"];
    NSURLSessionDataTask *downloadTask =  [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data && !error){
                    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    if ([json isKindOfClass:[NSDictionary class]]){
                        //"BTC":{"USD":17802.24}}
                        NSString *btcValue=[[json objectForKey:@"BTC"] objectForKey:@"USD"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                           [self.label setTitle:btcValue];
                        });
                        float btcusd = [btcValue floatValue];
                        if(flags == 0)
                        {
                            if(btcusd < [self.buyval floatValue])
                            {
                                system("say buy bitcoin!");
                            }
                        }
                        else if (flags == 1)
                        {
                            if(btcusd > [self.sellval floatValue])
                            {
                                system("say sell bitcoin!");
                            }
                        }
                    }
                }
            }
    ];
    [downloadTask resume];
    [session finishTasksAndInvalidate];
}
- (void)viewDidLoad {
    [NSTimer scheduledTimerWithTimeInterval:(5.0)
      target:self
    selector:@selector(doSomethingWhenTimeIsUp:)
    userInfo:nil
     repeats:YES];

    //[session finishTasksAndInvalidate];
    // Do any additional setup after loading the view.
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
