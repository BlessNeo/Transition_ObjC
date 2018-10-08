//
//  DetailViewController.h
//  Transition_ObjC
//
//  Created by Egeo 迩格 on 2018/10/8.
//  Copyright © 2018 Neo_ZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

