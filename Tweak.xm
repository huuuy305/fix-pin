#import <UIKit/UIKit.h>

%hook UILabel

- (void)setText:(NSString *)text {
    if ([text isKindOfClass:[NSString class]] &&
        ([text isEqualToString:@"70%"] ||
         [text isEqualToString:@"70 %"])) {
        %orig(@"95%");
        return;
    }

    %orig;
}

- (void)setAttributedText:(NSAttributedString *)text {
    if ([text isKindOfClass:[NSAttributedString class]]) {
        NSString *value = text.string;

        if ([value isEqualToString:@"70%"] ||
            [value isEqualToString:@"70 %"]) {
            NSMutableAttributedString *copy = [text mutableCopy];

            [copy.mutableString replaceOccurrencesOfString:@"70%"
                                                 withString:@"95%"
                                                    options:0
                                                      range:NSMakeRange(0, copy.length)];

            [copy.mutableString replaceOccurrencesOfString:@"70 %"
                                                 withString:@"95%"
                                                    options:0
                                                      range:NSMakeRange(0, copy.length)];

            %orig(copy);
            return;
        }
    }

    %orig;
}

%end
