//
//  RootViewController.m
//  UIWebView+XSSSample
//

#import "RootViewController.h"

@implementation RootViewController


-(void)dealloc
{
  [_webView release], _webView = nil;
  [super dealloc];
}

- (void)loadView
{
  [self openAddressBookfile];
  
  self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
  _webView.delegate = self;
  
  // リソースパスのURLからリクエストをロードするパターン
  NSURL* URL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"index.html"]; // XSS
  //NSURL* URL = [NSURL URLWithString:@"http://twitter.com/"]; // NONE
  [_webView loadRequest:[NSURLRequest requestWithURL:URL]];
  

//  // リソースパスのファイルをHTML文字列としてロードするパターン
//  NSString* src = [[[NSString alloc] initWithContentsOfURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"index.html"] 
//                                                  encoding:NSUTF8StringEncoding 
//                                                     error:nil] autorelease];
//  //[_webView loadHTMLString:src baseURL:[NSURL URLWithString:@"http://localhost/"]];
//  NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
//  [_webView loadHTMLString:src baseURL:[NSURL fileURLWithPath:bundlePath]];
//  //[_webView loadHTMLString:src baseURL:nil];
//  
  NSLog(@"loadView: %@", [_webView stringByEvaluatingJavaScriptFromString:@"location.href"]);
  
  [self.view addSubview:_webView];
  
  UIButton* button = [[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 44)] autorelease];
  button.backgroundColor = [UIColor grayColor];
  [button setTitle:@"TouchME!" forState:UIControlStateNormal];
  [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
  [self.view addSubview:button];
  
  UIButton* abButton = [[[UIButton alloc] initWithFrame:CGRectMake(200, 10, 100, 44)] autorelease];
  abButton.backgroundColor = [UIColor grayColor];
  [abButton setTitle:@"Open AddressBook" forState:UIControlStateNormal];
  [abButton addTarget:self action:@selector(abButtonAction:) forControlEvents:UIControlEventTouchDown];
  [self.view addSubview:abButton];
}

-(void)buttonAction:(id)sender
{
  NSLog(@"URL: %@", [_webView.request URL]);
  NSLog(@"buttonAction: %@", [_webView stringByEvaluatingJavaScriptFromString:@"location.href"]);
}

- (void)abButtonAction:(id)sender
{
  ABPeoplePickerNavigationController *picker = [[[ABPeoplePickerNavigationController alloc] init] autorelease];
  picker.delegate = self;
  [self presentModalViewController:picker animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
  [peoplePicker dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
  [peoplePicker dismissModalViewControllerAnimated:YES];
  return NO;
}

# pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  NSLog(@"URL: %@", [request URL]);
  return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  NSLog(@"URL: %@", [_webView.request URL]);
  NSLog(@"webViewDidFinishLoad: %@", [_webView stringByEvaluatingJavaScriptFromString:@"location.href"]);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{  
  NSLog(@"ERROR: %@", [error localizedDescription]);
  
  NSLog(@"URL: %@", [_webView.request URL]);
  NSLog(@"webViewDidFinishLoad: %@", [_webView stringByEvaluatingJavaScriptFromString:@"location.href"]);
}

- (void)openAddressBookfile
{
  NSFileManager* fm = [NSFileManager defaultManager];
  NSError* error;
  NSLog(@"%@", [fm contentsOfDirectoryAtPath:@"/" error:&error]);
  NSLog(@"%@", [fm contentsOfDirectoryAtPath:@"/private" error:&error]);
  NSLog(@"%@", [fm contentsOfDirectoryAtPath:@"/var/mobile" error:&error]);
}

@end
