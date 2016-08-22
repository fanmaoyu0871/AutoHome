//
//  FMDisBrandSliderController.m
//  AutoHome
//
//  Created by 范茂羽 on 15/5/24.
//  Copyright (c) 2015年 QianYuqing. All rights reserved.
//

#import "FMDisBrandSliderController.h"
#import "FMTableView.h"
#import "BrandModel.h"
#import "FMDisCarTypeSliderController.h"

@interface FMDisBrandSliderController ()


@end

@implementation FMDisBrandSliderController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)FMTableView:(FMTableView *)tableView withTableView:(UITableView *)tb atIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell =  [tb dequeueReusableCellWithIdentifier:@"brandCellID" forIndexPath:indexPath];
    
    
    if(indexPath.section == 0)
    {
        cell.textLabel.text = @"收藏";
    }
    else
    {
        BrandModel *model = self.brandArray[indexPath.section-1][indexPath.row];
        cell.textLabel.text = model.name;
    }
    
    return cell;
}


#define SELECTEDBRAND_URL @"http://app.api.autohome.com.cn/autov4.7/cars/seriesprice-pm1-b%ld-t1.json"

-(void)FMTableView:(FMTableView *)tableView didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    
    BrandModel *model = self.brandArray[indexPath.section-1][indexPath.row];
    FMDisCarTypeSliderController *VC = [[FMDisCarTypeSliderController alloc]init];
    VC.urlStr = [NSString stringWithFormat:SELECTEDBRAND_URL, [model.Id integerValue]];
    [self.navigationController pushViewController:VC animated:YES];
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
