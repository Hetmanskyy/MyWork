@import UIKit;
#import "HelpItem.h"

@protocol HelpTableViewCellDelegate <NSObject>
@optional

- (void)helpButtonTapped:(HelpItem *) helpItem;

@end

@interface HelpTableViewCell : UITableViewCell

@property (nonatomic, weak) id <HelpTableViewCellDelegate> delegate;

- (void) configureCellWith:(HelpItem *) helpItem;

@end
