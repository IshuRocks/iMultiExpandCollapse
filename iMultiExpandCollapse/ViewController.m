//
//  ViewController.m
//  iMultiExpandCollapse
//
//  Created by homebethe e-commerce private limited on 10/15/17.
//  Copyright © 2017 homebethe e-commerce private limited. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

NSString *const keyIndent = @"level";
NSString *const keyChildren = @"Objects";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iMultiData" ofType:@"plist"]];
    mainArray = [plistDict valueForKey:@"Objects"];
    
    menuItemsArray = [[NSMutableArray alloc] init];
    selectArray = [[NSMutableArray alloc] init];
    [menuItemsArray addObjectsFromArray:mainArray];
    
    _tbl_list.delegate = self;
    _tbl_list.dataSource = self;
    
    _tbl_list.tableFooterView = [UIView new];
    
    [_tbl_list reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSDictionary *dic = menuItemsArray[indexPath.row];
    
    if ([selectArray containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        [self acccesory:cell :@"up-arrow"];
    }
    else
    {
        if ([dic[keyChildren] count])
        {
            [self acccesory:cell :@"down-arrow"];
        }
        else
        {
            cell.accessoryView = nil;
        }
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSString * headername =[[menuItemsArray valueForKey:@"name"] objectAtIndex:indexPath.row];
    headername = [headername stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    cell.textLabel.text = headername;
    
    cell.indentationWidth = 20;
    cell.indentationLevel =[menuItemsArray[indexPath.row][keyIndent] integerValue];;
    
    cell.contentView.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:(CGFloat)(cell.indentationLevel)/25.0];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 34,self.view.frame.size.width,0.5)];
    view.backgroundColor = [UIColor colorWithRed:208.0f/255.0f green:208.0f/255.0f blue:208.0f/255.0f alpha:0.4f];
    [cell.contentView addSubview:view];
    
    return cell;
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = menuItemsArray[indexPath.row];
    
    NSArray *ar=[dic valueForKey:keyChildren];
    
    NSInteger indentLevel = [menuItemsArray[indexPath.row][keyIndent] integerValue]; //indentLevel of the selected cell
    
    BOOL isChildrenAlreadyInserted = [menuItemsArray containsObject:dic[keyChildren]]; //checking contains children
    
    for(NSDictionary *dicChildren in dic[keyChildren])
    {
        NSInteger indexe=[menuItemsArray indexOfObjectIdenticalTo:dicChildren];
        
        isChildrenAlreadyInserted=(indexe>0 && indexe!=NSIntegerMax); //checking contains children
        
        if(isChildrenAlreadyInserted) break;
        
    }
    
    NSString * T = [[menuItemsArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    if(isChildrenAlreadyInserted)
    {
        [self miniMizeThisRows:ar];
        
        if(indentLevel ==0)
        {
            [selectArray removeAllObjects];
        }
        
        [selectArray removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
        [self performSelector:@selector(tblReload) withObject:indexPath afterDelay:0.20];
        
    }
    else if([dic[keyChildren] count])
    {
        NSUInteger count=indexPath.row+1;
        
        if(removeArray.count && indentLevel ==0)
        {
            [self miniMizeThisRows:removeArray];
            
            [selectArray removeAllObjects];
            
            for (int i=0; i< menuItemsArray.count; i++)
            {
                NSString * T1 = [[menuItemsArray objectAtIndex:i] valueForKey:@"name"];
                
                if([T1 isEqualToString:T])
                {
                    count = i+1;
                }
            }
            
            [selectArray addObject:[NSString stringWithFormat:@"%ld",(long)count-1]];
        }
        else
        {
            [selectArray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        
        NSMutableArray *arCells=[NSMutableArray array];
        for(NSDictionary *dInner in ar )
        {
            [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
            [menuItemsArray insertObject:dInner atIndex:count++];
        }
        
        if(indentLevel == 0)
        {
            removeArray = ar;
        }
        
        if(selectedIndexPath == nil)
        {
            selectedIndexPath = indexPath;
        }
        
        [self.tbl_list insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationTop];
        
        [self performSelector:@selector(tblReload) withObject:indexPath afterDelay:0.20];
        
    }
    else
    {
        
        // Navigation to other View
        
    }
    
}

-(void)tblReload
{
    [self.tbl_list reloadData];
}

-(void)miniMizeThisRows:(NSArray*)ar
{
    
    for(NSDictionary *dInner in ar )
    {
        NSUInteger indexToRemove=[menuItemsArray indexOfObjectIdenticalTo:dInner];
        
        NSArray *arInner=[dInner valueForKey:keyChildren];
        if(arInner && [arInner count]>0){
            [self miniMizeThisRows:arInner];
        }
        
        if([menuItemsArray indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
            [menuItemsArray removeObjectIdenticalTo:dInner];
            
            
            [self.tbl_list deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                  [NSIndexPath indexPathForRow:indexToRemove inSection:0]]withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(void)acccesory :(UITableViewCell *)cell :(NSString*)img
{
    UIEdgeInsets insets = UIEdgeInsetsMake(24, 0, 0, 0);
    // Create custom accessory view, in this case an image view
    UIImage *customImage = [UIImage imageNamed:img];
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:customImage];
    
    // Create wrapper view with size that takes the insets into account
    UIView *accessoryWrapperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, customImage.size.width+insets.left+insets.right, customImage.size.height+insets.top+insets.bottom)];
    [accessoryWrapperView setBackgroundColor:[UIColor clearColor]];
    
    // Add custom accessory view into wrapper view
    [accessoryWrapperView addSubview:accessoryView];
    
    // Use inset's left and top values to position the custom accessory view inside the wrapper view
    accessoryView.frame = CGRectMake(insets.left+12, insets.top-5, customImage.size.width-10, customImage.size.height-10);
    
    // Set accessory view of cell (in this case this code is called from within the cell)
    cell.accessoryView = accessoryWrapperView;
}


@end
