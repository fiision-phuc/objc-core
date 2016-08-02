#import "NSNumber+FwiExtension.h"
#import "FwiCore.h"


@implementation NSNumber (FwiExtension)


- (__autoreleasing NSString *)currencyWithISO3:(NSString *)currencyISO3 decimalSeparator:(NSString *)decimalSeparator groupingSeparator:(NSString *)groupingSeparator usingSymbol:(BOOL)usingSymbol {
    /* Condition validation */
    if (!self) {
        return nil;
    }
    
    // Initialize currency format object
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSNumberFormatter *currencyFormat = [[NSNumberFormatter alloc] init];
    
    // Layout currency
    currencyFormat.formatterBehavior = NSNumberFormatterBehavior10_4;
    currencyFormat.numberStyle = NSNumberFormatterCurrencyStyle;
    currencyFormat.roundingMode = NSNumberFormatterRoundHalfUp;
    [currencyFormat setGeneratesDecimalNumbers:YES];
    currencyFormat.locale = locale;
    
    currencyFormat.currencyGroupingSeparator = groupingSeparator;
    currencyFormat.currencyDecimalSeparator = decimalSeparator;
    
    if (usingSymbol) {
        currencyFormat.positiveFormat = @"\u00a4#,##0.00";
        currencyFormat.negativeFormat = @"- \u00a4#,##0.00";
    }
    else {
        currencyFormat.positiveFormat = [NSString stringWithFormat:@"#,##0.00 %@", currencyISO3];
        currencyFormat.negativeFormat = [NSString stringWithFormat:@"- #,##0.00 %@", currencyISO3];
    }
    currencyFormat.currencyCode = currencyISO3;
    
    __autoreleasing NSString *result = [currencyFormat stringFromNumber:self];
    FwiRelease(currencyFormat);
    FwiRelease(locale);
    
    return result;
}


@end
