#import "FwiCore.h"
#import "NSNumber+FwiExtension.h"


@implementation NSNumber (FwiExtension)


- (__autoreleasing NSString *)currencyWithISO3:(NSString *)currencyISO3 decimalSeparator:(NSString *)decimalSeparator groupingSeparator:(NSString *)groupingSeparator usingSymbol:(BOOL)usingSymbol {
	/* Condition validation */
    if (!self) return nil;
    
    // Initialize currency format object
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSNumberFormatter *currencyFormat = [[NSNumberFormatter alloc] init];
    
    // Layout currency
    [currencyFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyFormat setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormat setRoundingMode:NSNumberFormatterRoundHalfUp];
    [currencyFormat setGeneratesDecimalNumbers:YES];
    [currencyFormat setLocale:locale];
    
    [currencyFormat setCurrencyGroupingSeparator:groupingSeparator];
    [currencyFormat setCurrencyDecimalSeparator:decimalSeparator];
    
    if (usingSymbol) {
        [currencyFormat setPositiveFormat:@"\u00a4#,##0.00"];
        [currencyFormat setNegativeFormat:@"- \u00a4#,##0.00"];
    }
    else {
        [currencyFormat setPositiveFormat:[NSString stringWithFormat:@"#,##0.00 %@", currencyISO3]];
        [currencyFormat setNegativeFormat:[NSString stringWithFormat:@"- #,##0.00 %@", currencyISO3]];
    }
    [currencyFormat setCurrencyCode:currencyISO3];
    
    __autoreleasing NSString *result = [currencyFormat stringFromNumber:self];
    FwiRelease(currencyFormat);
    FwiRelease(locale);
    return result;
}


@end
