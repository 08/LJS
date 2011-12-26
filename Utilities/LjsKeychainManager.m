#import "LjsKeychainManager.h"
#import "Lumberjack.h"
#import "SFHFKeychainUtils.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *LjsKeychainManagerErrorDomain = @"com.littlejoysoftware.ljs LJS Keychain Manager Error";

/**
 It is a common design pattern to have a username stored in defaults and a 
 password optionally (user controlled) stored in the Keychain.  
 LjsKeychainManager provides methods to bridge the Keychain Access API (using
 the SFHFKeychainUtils) and the User Defaults API.
 */
@implementation LjsKeychainManager


- (void) dealloc {
  [super dealloc];
}

- (id) init {
  self = [super init];
  if (self) {
    // keep this around - sometimes is it helpful to see what is in the defaults      
    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // NSDictionary *dict = [defaults dictionaryRepresentation];
    // DDLogDebug(@"dict = %@", dict);
  }
  return self;
}

#pragma mark Username Stored in Defaults

/**
 used to determine the validity of a username
 
 currently there are no restrictions on usernames other than they not be
 nil or empty
 
 @param username the name to check
 @return true if username is a non-nil, non-empty string
 */
- (BOOL) isValidUsername:(NSString *) username {
  return username != nil && [username length] != 0;
}

/**
 used to determine the validity of a password
 
 currently there are no restrictions on passwords other than they not be
 nil or empty
 
 @param password the password to check
 @return true iff password is a non-nil, non-empty string
 */
- (BOOL) isValidPassword:(NSString *) password {
  return password != nil && [password length] != 0;
}

/**
 @return true iff key is non-nil and non empty
 @param key the key to test
 */
- (BOOL) isValidKey:(NSString *) key {
  return key != nil && [key length] != 0;
}

/**
 queries the NSUserDefaults standardUserDefaults with the AgChoiceUsernameDefaultsKey
 @param key the defaults key
 @return if there is no entry, will return nil
 */
- (NSString *) usernameStoredInDefaultsForKey:(NSString *) key {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *username = [defaults stringForKey:key];
  
  NSString *result = nil;
  if ([self isValidUsername:username]) {
    result = username;
  }
  return result;  
}


/**
 deletes the value (if any) for the key AgChoiceUsernameDefaultsKey from the
 NSUserDefaults standardUserDefaults
 @return true iff the delete was successful
 @param error catches invalid key errors
 */
- (BOOL) deleteUsernameInDefaultsForKey:(NSString *)key error:(NSError **)error {
  BOOL result = NO;
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeychainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
    }
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setNilValueForKey:key];
    result = YES;
  }
  return result;
}


/**
 sets the value for key AgChoiceUsernameDefaultsKey in the NSUserDefaults
 standardUserDefaults
 @return true iff the username was succesfully set
 @param username the new value for AgChoiceUsernamDefaultsKey
 @param key the key to store the username under
 @param error catches bad key and bad username
 */
- (BOOL) setDefaultsUsername:(NSString *) username forKey:(NSString *) key error:(NSError **) error {
  if (![self isValidUsername:username]) {
    if (*error != NULL) {
      *error = [self ljsKeychainManagerErrorWithCode:LjsKeychainManagerBadUsernameError
                                            userInfo:nil];
    }
    return NO;
  }
  
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeychainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
    }
    return NO;
  }

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:username forKey:key];
  return YES;
}

#pragma mark Should Use Key Chain in Defaults

/**

 
 @return the BOOL value of the item stored in defaults under key
 @param key the key under which the should use keychain value is stored
 @param error catches bad key
 */
- (BOOL) shouldUseKeyChainWithKey:(NSString  *) key error:(NSError **) error {
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeychainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
    }
    return NO;
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
  }
}


/**
 @return true iff the delete was successful
 @param key the key to lookup (and delete) from defaults
 @param error catches bad key
 */
- (BOOL) deleteShouldUseKeyChainInDefaults:(NSString *) key error:(NSError **) error {
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeychainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
    }
    return NO;
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setNilValueForKey:key];
    return YES;
  }
}


/**
 @return sets defaults value to shouldUse for key 
 @param shouldUse the new value to store in the User Defaults
 @param key the key under which to store the shouldUse value
 @param catches bad key
 */
- (BOOL) setDefaultsShouldUseKeyChain:(BOOL) shouldUse key:(NSString *) key error:(NSError **) error {
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeychainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
    }
    return NO;
  } else {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:shouldUse forKey:key];
    return YES;
  }
}

#pragma mark Key Chain Interaction

/**
 queries the keychain to see if a password is stored for username
 @param username the name we want the password for
 @param serviceName the keychain service name
 @param error catches bad usernames
 @return true iff the keychain has a password for the username
 */
- (BOOL) hasKeychainPasswordForUsername:(NSString *) username 
                            serviceName:(NSString *) serviceName
                                  error:(NSError **) error {
  
  NSError *fetchError;
  NSString *fetchedPwd = [SFHFKeychainUtils getPasswordForUsername:username
                                                andServiceName:serviceName
                                                         error:&fetchError];
  if (fetchError != nil) {
    [self logKeychainError:fetchError];
    if (*error != NULL) {
        *error = fetchError;
    }
  }   
  return [self isValidPassword:fetchedPwd];
}


/**
 queries the keychain for the password stored for username
 
 @return returns the password stored for the username in the defaults or nil if
 no password is found
 @param key the key under the username is stored
 @param serviceName the keychain service name
 @param error catches bad key and Keychain Access error
 */
- (NSString *) keychainPasswordForUsernameInDefaults:(NSString *) key
                                         serviceName:(NSString *) serviceName
                                               error:(NSError **) error {
  if (![self isValidKey:key]) {
    if (*error != NULL) {
      *error = [self ljsKeychainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                            userInfo:nil];
    }
    return nil;
  }
  
  NSString *username = [self usernameStoredInDefaultsForKey:key];
  
  NSError *fetchError;
  NSString *result = [SFHFKeychainUtils getPasswordForUsername:username
                                                andServiceName:serviceName
                                                         error:&fetchError];
  
  if (fetchError != nil) {
    [self logKeychainError:fetchError];
    if (*error != NULL) {
      *error = fetchError;
    }
  }
  return result;
}

/**
 deletes the password for the keychain entry for the username

 @param username the username for the password we would like to delete
 @param serviceName the service name for the password
 @param error catches Keychain Access error
 @return true iff password was deleted
 */
- (BOOL) keychainDeletePasswordForUsername:(NSString *) username 
                               serviceName:(NSString *) serviceName
                                     error:(NSError **) error {
  return [SFHFKeychainUtils deleteItemForUsername:username
                                   andServiceName:serviceName
                                            error:error];
}

/**
 stores a username and password to the keychain
 
 @return true iff store was successful
 @param username the username for the password we would like to store
 @param serviceName the service name for the password
 @param password the password to store for the username
 @param error catches Keychain Access error
 */
- (BOOL) keychainStoreUsername:(NSString *) username 
                   serviceName:(NSString *) serviceName
                      password:(NSString *) password
                         error:(NSError **) error {

  return [SFHFKeychainUtils storeUsername:username andPassword:password
                    forServiceName:serviceName
                           updateExisting:YES 
                                    error:error];
}

#pragma mark Synchronizing Key Chain and Defaults

/**
 synchronizes the Keychain and User Defaults
 
 if shouldUseKeychain is YES and username and password are valid, then the
 pair is stored to the keychain and the username is stored in the User Defaults
 
 if shouldUseKeychain is NO, then any existing password for username in the Keychain
 is deleted.  the username is still persisted to User Defaults.
 
 the value of shouldUseKeychain is persisted the User Defaults
 
 This method will fail fast, but it is possible that the defaults might be set
 and the keychain elements will not be updated
 
 @return true iff synchronization is successful
 @param username the username to persist to defaults
 @param usernameKey the key under which to persist the username 
 @param shouldUseKeychainKey the key under which shouldUseKeychain value is stored
 @param shouldUseKeychain the value to store under shouldUseKeychainKey
 @param serviceName the service name for the password
 @param error catches Keychain Access error 
 */
- (BOOL) synchronizeKeychainAndDefaultsWithUsername:(NSString *) username
                                usernameDefaultsKey:(NSString *) usernameKey
                                           password:(NSString *) password
                       shouldUseKeychainDefaultsKey:(NSString *) shouldUseKeychainKey
                                  shouldUseKeyChain:(BOOL) shouldUseKeychain
                                        serviceName:(NSString *) serviceName
                                              error:(NSError **) error {
  if (![self isValidUsername:username]) {
    if (*error != NULL) {
      [self ljsKeychainManagerErrorWithCode:LjsKeychainManagerBadUsernameError
                                   userInfo:nil];
    }
    return NO;
  }
  
  if (![self isValidKey:usernameKey]) {
    if (*error != NULL) {
      [self ljsKeychainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                   userInfo:nil];
    }
    return NO;
  }
  
  if (![self isValidPassword:password]) {
    if (*error != NULL) {
      [self ljsKeychainManagerErrorWithCode:LjsKeychainManagerBadPasswordError
                                   userInfo:nil];
    }
    return NO;
  }
  
  if (![self isValidKey:shouldUseKeychainKey]) {
    if (*error != NULL) {
      [self ljsKeychainManagerErrorWithCode:LjsKeychainManagerBadKeyError
                                   userInfo:nil];
    }
    return NO;
  }

  if (![self setDefaultsShouldUseKeyChain:shouldUseKeychain
                                      key:shouldUseKeychainKey
                                    error:error]) {
    return NO;
  }
  
  if (![self setDefaultsUsername:username forKey:usernameKey error:error]) {
    return NO;
  }
  
  [[NSUserDefaults standardUserDefaults] synchronize];

  
  if (shouldUseKeychain == YES) {

    return [self keychainStoreUsername:username
                           serviceName:serviceName
                              password:password
                                 error:error];
    

  } else {
    return [self keychainDeletePasswordForUsername:username
                                       serviceName:serviceName
                                             error:error];
  }
}

#pragma mark Utility

/**
 @return an error using the LjsKeychainManagerErrorDomain and code
 @param code the error code use
 @param userInfo the user info dictionary
 */
- (NSError *) ljsKeychainManagerErrorWithCode:(NSUInteger) code
                                     userInfo:(NSDictionary *)userInfo {
  return [NSError errorWithDomain:LjsKeychainManagerErrorDomain
                             code:code
                         userInfo:userInfo];
}


/**
 prints error information to the log stream(s)
 @param error the error to log
 */
- (void) logKeychainError:(NSError *) error {
  NSInteger code = [error code];
  NSString *message = [error localizedDescription];
  DDLogError(@"%d: %@", code, message);
}

@end
