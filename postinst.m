#import <Foundation/Foundation.h>

#define NSLog(...) fprintf(stderr, "%s\n", [[NSString stringWithFormat:__VA_ARGS__] UTF8String])

static void SearchForAttachmentsAndEncrypt(NSFileManager *fm, NSString *path)
{
	for (NSString *subpath in [fm contentsOfDirectoryAtPath:path error:NULL]) {
		NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
		BOOL isDirectory;
		if ([fm fileExistsAtPath:fullSubpath isDirectory:&isDirectory]) {
			if (isDirectory) {
				SearchForAttachmentsAndEncrypt(fm, fullSubpath);
			} else {
				NSLog(@"Encrypting %@", fullSubpath);
				NSDictionary *attributes = @{
					NSFileOwnerAccountName: @"mobile",
					NSFileProtectionKey: NSFileProtectionCompleteUntilFirstUserAuthentication,
				};
				NSError *error = nil;
				if (![fm setAttributes:attributes ofItemAtPath:fullSubpath error:&error]) {
					NSLog(@" failed with error: %@", error);
				}
			}
		}
	}
}

static void SearchForFolderAndEncrypt(NSFileManager *fm, NSString *path)
{
	for (NSString *subpath in [fm contentsOfDirectoryAtPath:path error:NULL]) {
		NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
		if ([subpath isEqualToString:@"Attachments"]) {
			SearchForAttachmentsAndEncrypt(fm, fullSubpath);
		} else {
			SearchForFolderAndEncrypt(fm, fullSubpath);
		}
	}
}

int main(int argc, char *argv[])
{
	@autoreleasepool {
		NSFileManager *fm = [[NSFileManager alloc] init];
		SearchForFolderAndEncrypt(fm, @"/var/mobile/Library/Mail/");
		[fm release];
	}
	return 0;
}
