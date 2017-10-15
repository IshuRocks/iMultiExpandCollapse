//
//  ViewController.h
//  iMultiExpandCollapse
//
//  Created by homebethe e-commerce private limited on 10/15/17.
//  Copyright © 2017 homebethe e-commerce private limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *mainArray,* removeArray;
    NSMutableArray *menuItemsArray,* selectArray;
    NSIndexPath *selectedIndexPath;
}

@property (weak, nonatomic) IBOutlet UITableView *tbl_list;

@end

