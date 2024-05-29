#import "HelpItem.h"

@implementation HelpItem

- (instancetype)initWithType:(HelpItemType) helpItemType
                        name:(NSString *) name
                   imageName:(NSString *) imageName
            actionButtonName:(NSString *) actionButtonName
                      action:(NSString *) action {
    self = [super init];
    if (self) {
        _helpItemType = helpItemType;
        _name = name;
        _imageName = imageName;
        _actionButtonName = actionButtonName;
        _action = action;
    }
    return self;
}

@end
