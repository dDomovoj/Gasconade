//
//  IExternalGameEvent.h
//  GameConnectV2
//
//  Created by Guillaume Derivery on 14/04/14.
//  Copyright (c) 2014 Guillaume Derivery. All rights reserved.
//

#import "GCEventModel.h"

@protocol IGCExternalGameEvent <NSObject>
@required

-(void) updateExternalContentInfo:(GCExternalContent *)externalContentModel;

-(void) updateEventInfo:(GCEventModel *)eventModel;

@end
