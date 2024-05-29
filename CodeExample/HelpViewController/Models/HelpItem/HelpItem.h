#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    RoadsideAssistance,
    EmergencyServices,
    CustomerSupport,
    MakeAClaim,
    MyPolicyDocuments,
    Logbook
} HelpItemType;

@interface HelpItem : NSObject

@property (nonatomic) HelpItemType           helpItemType;
@property(nonatomic, strong) NSString       *name;
@property(nonatomic, strong) NSString       *imageName;
@property(nonatomic, strong) NSString       *actionButtonName;
@property(nonatomic, strong) NSString       *action;

- (instancetype)initWithType:(HelpItemType) helpItemType
                        name:(NSString *) name
                   imageName:(NSString *) imageName
            actionButtonName:(NSString *) actionButtonName
                      action:(NSString *) action;

@end

NS_ASSUME_NONNULL_END
