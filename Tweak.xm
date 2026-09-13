#import <UIKit/UIKit.h>

static BOOL Pin95IsBatteryHealthText(NSString *text) {
    if (![text isKindOfClass:[NSString class]]) return NO;

    return [text isEqualToString:@"70%"] ||
           [text isEqualToString:@"70 %"] ||
           [text isEqualToString:@"70％"];
}

static BOOL Pin95IsWarningText(NSString *text) {
    if (![text isKindOfClass:[NSString class]]) return NO;

    return [text containsString:@"Không thể xác minh rằng iPhone này có pin"] ||
           [text containsString:@"Apple chính hãng"] ||
           [text containsString:@"Chi tiết từ pin này có thể không chính xác"] ||
           [text containsString:@"This iPhone is unable to determine battery health"] ||
           [text containsString:@"Unable to verify this iPhone has a genuine Apple battery"] ||
           [text containsString:@"Important Battery Message"];
}

%hook UILabel

- (void)setText:(NSString *)text {
    if (Pin95IsBatteryHealthText(text)) {
        %orig(@"95%");
        return;
    }

    // Hide the non-genuine battery warning text.
    // This is cosmetic and may leave a small empty area depending on iOS layout.
    if (Pin95IsWarningText(text)) {
        %orig(@"");
        [self setHidden:YES];
        return;
    }

    %orig;
}

- (void)setAttributedText:(NSAttributedString *)text {
    NSString *value = [text isKindOfClass:[NSAttributedString class]] ? text.string : nil;

    if (Pin95IsBatteryHealthText(value)) {
        NSMutableAttributedString *copy = [text mutableCopy];
        [copy.mutableString replaceOccurrencesOfString:@"70%"
                                             withString:@"95%"
                                                options:0
                                                  range:NSMakeRange(0, copy.length)];
        [copy.mutableString replaceOccurrencesOfString:@"70 %"
                                             withString:@"95%"
                                                options:0
                                                  range:NSMakeRange(0, copy.length)];
        [copy.mutableString replaceOccurrencesOfString:@"70％"
                                             withString:@"95%"
                                                options:0
                                                  range:NSMakeRange(0, copy.length)];
        %orig(copy);
        return;
    }

    if (Pin95IsWarningText(value)) {
        %orig(nil);
        [self setHidden:YES];
        return;
    }

    %orig;
}

%end

// Hide labels that are created after the first layout pass.
%hook UIView

- (void)didMoveToWindow {
    %orig;

    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        NSString *text = label.text ?: label.attributedText.string;

        if (Pin95IsWarningText(text)) {
            label.hidden = YES;
        }
    }
}

%end
