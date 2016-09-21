//
//  SecondViewController.m
//  AssignmentIOs
//
//  Created by Shailesh Patil on 20/09/16.
//  Copyright © 2016 Jyoti Shinde. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomTableViewCell.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title=@"Cart";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSLog(@"In second View");
    
    //NSLog(@"count cart Array=%d",[_appDelegate.cartArray count]);
    _cartArray=[[NSMutableArray alloc]init];
    _cellPriceArray=[[NSMutableArray alloc]init];
    _cellImgArray=[[NSMutableArray alloc]init];
    
    _cellPhnArray=[[NSMutableArray alloc]init];
    _cellVAdressArray=[[NSMutableArray alloc]init];
    _cellVArray=[[NSMutableArray alloc]init];
    _cellPArray=[[NSMutableArray alloc]init];

    
    
   _cartArray= [[DBManager getSharedInstance]FindAllCartData];
    [self Data];
}
//static NSString *simpleTableIdentifier = @"CustomCollectionCell";

//CustomCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
-(void )Data{
    
    if(_cartArray.count>0)
    {
        for (int i=0; i<=[_cartArray count]; i++)
        {
           // <#statements#>
        }
    }
}

- (void) loadImageFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageWithData:imageData];
            callback(image);
            
        });
    });
}


//UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
       return [_cartArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"CustomTableViewCell";
    CustomTableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:cellIdentifier] ;
    
    cell.cellLblPName.text=[_cellPArray objectAtIndex:indexPath.row];
    cell.cellLblPrice.text=[_cellPriceArray objectAtIndex:indexPath.row];
    cell.cellLblVName.text=[_cellVArray objectAtIndex:indexPath.row];
    cell.cellLblVAdress.text=[_cellVAdressArray objectAtIndex:indexPath.row];
    NSString *myImage = [_cellImgArray objectAtIndex:indexPath.row];
    [self loadImageFromURL:[NSURL URLWithString:[myImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] callback:^(UIImage *image) {
        cell.tableCellImage.image = image;
    }];

    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
        //NSIndexPath *path = [self.programTable indexPathForSelectedRow];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
           
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
