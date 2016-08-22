//
//  FMWebController.m
//  AutoHome
//
//  Created by qianfeng on 15/5/19.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMWebController.h"
#import "UMSocial.h"

@interface FMWebController ()<UIWebViewDelegate>

@end

@implementation FMWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNav];
    [self createWebView];
}

-(void)createNav
{
    UIButton *backBtn = [FMUtil createButtonWithFrame:CGRectMake(5, 20, 60, self.navBar.bounds.size.height-10) withTitle:@"返回" withImageName:@"bar_btn_icon_returntext" withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(backAction)];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navBar addSubview:backBtn];
    
    
    UIButton *moreBtn = [FMUtil createButtonWithFrame:CGRectMake(self.navBar.bounds.size.width-45, 10, 40, self.navBar.bounds.size.height) withTitle:@"分享" withImageName:nil withSelImageName:nil withHigImageName:nil withTarget:self withAction:@selector(moreAction)];
    [moreBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navBar addSubview:moreBtn];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)moreAction
{
    //这里要设置分享的新闻链接
    [UMSocialData defaultData].extConfig.qqData.url = @"http://www.baidu.com";
    
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"分享成功" image:[UIImage imageNamed:@"icon.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

-(void)createWebView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [FMProgressHUD showOnView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [FMProgressHUD hideAfterSuccessOnView:self.view];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [FMProgressHUD hideAfterFailOnView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
