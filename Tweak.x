#import <Foundation/Foundation.h>

%hook NSData

- (BOOL)writeToFile:(NSString *)path options:(NSDataWritingOptions)mask error:(NSError **)errorPtr
{
	switch (mask & NSDataWritingFileProtectionMask) {
		case 0:
		case NSDataWritingFileProtectionNone:
			if ([path hasPrefix:@"/var/mobile/Library/Mail/"] && [path rangeOfString:@"/Attachments/"].location != NSNotFound) {
				NSLog(@"AttachmentEncryptor: Applying encryption to %@", path);
				mask = (mask & ~NSDataWritingFileProtectionMask) | NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication;
			}
			break;
		default:
			break;
	}
	return %orig();
}

%end
