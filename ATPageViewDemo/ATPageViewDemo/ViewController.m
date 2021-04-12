//
//  ViewController.m
//  ATPageViewDemo
//
//  Created by liyebiao on 2021/4/6.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController4.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)clickDemo1:(id)sender {
    ViewController2 * vctl = [[ViewController2 alloc] init];
    [self.navigationController pushViewController:vctl animated:YES];
}

- (IBAction)clickDemo2:(id)sender {
    ViewController3 * vctl = [[ViewController3 alloc] init];
    [self.navigationController pushViewController:vctl animated:YES];
}

- (IBAction)clickDemo3:(id)sender {
    ViewController4 * vctl = [[ViewController4 alloc] init];
    [self.navigationController pushViewController:vctl animated:YES];
}


@end
