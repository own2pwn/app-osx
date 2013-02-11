//
//  NSString+Helper.m
//  PrYv
//
//  Created by Victor Kristof on 06.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

+(NSString*)mimeTypeFromFileExtension:(NSString*) fileName{
    
    NSArray *components = [fileName componentsSeparatedByString:@"."];
    if([components count]<2)return @"dir";
    NSString *ext = [[components lastObject] lowercaseString];
    
    //Documents
	if([ext isEqualToString:@"pdf"])return @"application/pdf";
    else if([ext isEqualToString:@"rtf"])return @"text/rtf";
    else if([ext isEqualToString:@"txt"])return @"text/plain";
    
    //Microsoft Office
    else if([ext isEqualToString:@"doc"])return @"application/msword";
    else if([ext isEqualToString:@"docx"])return @"application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    else if([ext isEqualToString:@"ppt"])return @"application/vnd.ms-powerpoint";
    else if([ext isEqualToString:@"pptx"])return @"application/vnd.openxmlformats-officedocument.presentationml.presentation";
    else if([ext isEqualToString:@"xls"])return @"application/vnd.ms-excel";
    else if([ext isEqualToString:@"xlsx"]||[ext isEqualToString:@"xlsm"]||[ext isEqualToString:@"xlsb"])return @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
    
    //Open Office
    else if([ext isEqualToString:@"odt"])return @"application/vnd.oasis.opendocument.text";
    else if([ext isEqualToString:@"odp"])return @"application/vnd.oasis.opendocument.presentation";
    else if([ext isEqualToString:@"ods"])return @"application/vnd.oasis.opendocument.spreadsheet";
    else if([ext isEqualToString:@"odg"])return @"application/vnd.oasis.opendocument.graphics";
    
    //iWork (Unofficial, Technically application/zip)
    else if([ext isEqualToString:@"pages"])return @"application/x-iwork-pages-sffpages";
    else if([ext isEqualToString:@"keynote"])return @"application/x-iwork-keynote-sffkeynote";
    else if([ext isEqualToString:@"numbers"])return @"application/x-iwork-numbers-sffnumbers";
    
    //Web Markup
    else if([ext isEqualToString:@"htm"]||[ext isEqualToString:@"html"]||[ext isEqualToString:@"shtml"])return @"text/html";
    else if([ext isEqualToString:@"css"])return @"text/css";
    else if([ext isEqualToString:@"js"])return @"application/javascript";
    else if([ext isEqualToString:@"php"])return @"application/x-php"; //There is some dispute to this
    else if([ext isEqualToString:@"xml"]||[ext isEqualToString:@"rss"])return @"text/xml";
    else if([ext isEqualToString:@"swf"])return @"application/x-shockwave-flash";
    
    //Images
    else if([ext isEqualToString:@"png"])return @"image/png";
    else if([ext isEqualToString:@"bmp"])return @"image/bmp";
    else if([ext isEqualToString:@"gif"])return @"image/gif";
    else if([ext isEqualToString:@"tif"]||[ext isEqualToString:@"tiff"])return @"image/tiff";
    else if([ext isEqualToString:@"ico"])return @"image/vnd.microsoft.icon";
    else if([ext isEqualToString:@"svg"])return @"image/svg+xml";
    else if([ext isEqualToString:@"jpg"]||[ext isEqualToString:@"jpeg"])return @"image/jpeg";
    
    //Audio
    else if([ext isEqualToString:@"mp3"])return @"audio/mpeg";
    else if([ext isEqualToString:@"m4a"])return @"audio/mp4";
    else if([ext isEqualToString:@"ogg"]||[ext isEqualToString:@"oga"]||[ext isEqualToString:@"spx"])return @"audio/vorbis";
    else if([ext isEqualToString:@"flac"])return @"audio/x-flac";
    else if([ext isEqualToString:@"wma"])return @"audio/x-ms-wma";
    else if([ext isEqualToString:@"wav"])return @"audio/vnd.wave";
    else if([ext isEqualToString:@"aif"]||[ext isEqualToString:@"aifc"]||[ext isEqualToString:@"aiff"])return @"audio/x-aiff";
    else if([ext isEqualToString:@"ra"]||[ext isEqualToString:@"ram"])return @"audio/x-pn-realaudio";
    
    //Movies
    else if([ext isEqualToString:@"mp4"]||[ext isEqualToString:@"m4v"])return @"video/mp4";
    else if([ext isEqualToString:@"webm"])return @"video/webm";
    else if([ext isEqualToString:@"ogv"])return @"video/ogg";
    else if([ext isEqualToString:@"mov"]||[ext isEqualToString:@"qt"])return @"video/quicktime";
    else if([ext isEqualToString:@"mp2"]||[ext isEqualToString:@"mpg"]||[ext isEqualToString:@"mpeg"])return @"video/mpeg";
    else if([ext isEqualToString:@"wmv"])return @"video/x-ms-wmv";
    else if([ext isEqualToString:@"avi"])return @"video/x-msvideo";
    else if([ext isEqualToString:@"divx"])return @"video/x-divx";
    
    //Compression
    else if([ext isEqualToString:@"zip"])return @"application/zip";
    else if([ext isEqualToString:@"gz"])return @"application/x-gzip";
    else if([ext isEqualToString:@"tar"])return @"application/x-tar";
    else if([ext isEqualToString:@"sit"]||[ext isEqualToString:@"sitx"]||[ext isEqualToString:@"sif"])return @"application/x-stuffit";
    else if([ext isEqualToString:@"rar"])return @"application/x-rar-compressed";
    else if([ext isEqualToString:@"dmg"])return @"application/x-apple-diskimage";
    
    return @"text/plain";
}
@end
