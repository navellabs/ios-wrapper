/*
 Copyright (c) 2011 Readmill LTD
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "ReadmillUser.h"
#import "ReadmillReading.h"
#import "ReadmillBook.h"

@class ReadmillConnectBookUI;

@protocol ReadmillConnectBookUIDelegate <NSObject>

/*!
 @param connectionUI The ReadmillConnectBookUI object sending the message.
 @param aBook The book that was linked to.
 @param aReading The created ReadmillReading object.
 @brief   Called when a user successfully linked to a Readmill book.
 */
-(void)connect:(ReadmillConnectBookUI *)connectionUI didSucceedToLinkToBook:(ReadmillBook *)aBook withReading:(ReadmillReading *)aReading;

/*!
 @param connectionUI The ReadmillConnectBookUI object sending the message.
 @param aBook The book that was not linked to.
 @brief   Called when a user skipped linking to a Readmill book.
 */
-(void)connect:(ReadmillConnectBookUI *)connectionUI didSkipLinkingToBook:(ReadmillBook *)aBook;

/*!
 @param connectionUI The ReadmillConnectBookUI object sending the message.
 @param aBook The book that was not linked to.
 @param error The error that occurred.
 @brief   Called when linking to a book failed with an error.
 */
-(void)connect:(ReadmillConnectBookUI *)connectionUI didFailToLinkToBook:(ReadmillBook *)aBook withError:(NSError *)error;

@end

@interface ReadmillConnectBookUI : UIViewController <UIWebViewDelegate> {
@private
    
    ReadmillUser *user;
    ReadmillBook *book;
    
    id <ReadmillConnectBookUIDelegate> delegate;
        
}

/*!
 @param user The Readmill user to connect.
 @param ISBN The ISBN of the book the user wishes to connect.
 @param title The title of the book the user wishes to connect to. 
 @param author The author of the book the user wishes to connect to. 
 @result The initialized ReadmillConnectBookUI object.
 @brief   Initialize a ReadmillConnectBookUI.
 */
- (id)initWithUser:(ReadmillUser *)user ISBN:(NSString *)ISBN title:(NSString *)title author:(NSString *)author;

/*!
 @param user The Readmill user to connect.
 @param book The ReadmillBook object the user wishes to connect.
 @result The initialized ReadmillConnectBookUI object.
 @brief   Initialize a ReadmillConnectBookUI.
 */
- (id)initWithUser:(ReadmillUser *)user book:(ReadmillBook *)book;

/*!
 @property user 
 @brief The user being linked.
 */
@property (nonatomic, readonly, retain) ReadmillUser *user;

/*!
 @property book 
 @brief The book being linked.
 */
@property (nonatomic, readonly, retain) ReadmillBook *book;

/*!
 @property delegate 
 @brief The delegate object to be informed of success or failure.
 */
@property (nonatomic, readwrite, assign) id <ReadmillConnectBookUIDelegate> delegate;


@end
