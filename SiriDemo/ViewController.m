//
//  ViewController.m
//  SiriDemo
//
//  Created by Harsh Srivastava on 22/04/20.
//  Copyright © 2020 Harsh Srivastava. All rights reserved.
//

#import "ViewController.h"


#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestSpeechAuthorization];
    
    self.audioEngine = [[AVAudioEngine alloc]init];
    self.speechRecognizer = [[SFSpeechRecognizer alloc]init];
    self.request = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    self.isRecording = NO;
}

-(void)requestSpeechAuthorization {
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    [self.startButton setEnabled:YES];
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    [self.startButton setEnabled:NO];
                    self.textLabel.text = @"User Denied access to speech recognition";
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    [self.startButton setEnabled:NO];
                    self.textLabel.text = @"Speech recognition restricted to this device";
                    break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    [self.startButton setEnabled:NO];
                    self.textLabel.text = @"Speech Recognition not yet authorized";
                    break;
            }
        }];
    }];
}

- (void)recordAndRecognizeSpeech {
    AVAudioInputNode * node = self.audioEngine.inputNode;
    AVAudioFormat * recordingFormat = [node outputFormatForBus:0];
    [node installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        
        [self.request appendAudioPCMBuffer:buffer];
    }];
    
    [self.audioEngine prepare];
    NSError * error;
    BOOL status = [self.audioEngine startAndReturnError:&error];
    if (status == NO) {
        NSLog(@"%@", error);
        return;
    }
    
    SFSpeechRecognizer * myRecognizer = [[SFSpeechRecognizer alloc]init];
    if (myRecognizer.isAvailable == NO) {
        return;
    }
    
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        if ((result != nil)||(result != NULL)) {
            NSString *resultString = result.bestTranscription.formattedString;
            NSString * lastString = @"";
            for(SFTranscriptionSegment * segments in result.bestTranscription.segments) {
                NSRange range = [resultString rangeOfString:segments.substring options:NSBackwardsSearch];
                lastString = [resultString substringWithRange:range];
            }
            self.textLabel.text = lastString;
            [self checkColorSaid:lastString];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

-(void)checkColorSaid:(NSString*)resultString {
    SWITCH (resultString.lowercaseString) {
        CASE (@"red") {
            self.colorView.backgroundColor = UIColor.redColor;
            break;
        }
        CASE (@"orange") {
            self.colorView.backgroundColor = UIColor.orangeColor;
            break;
        }
        CASE (@"yellow") {
            self.colorView.backgroundColor = UIColor.yellowColor;
            break;
        }
        CASE(@"green") {
            self.colorView.backgroundColor = UIColor.greenColor;
            break;
        }
        CASE(@"blue") {
            self.colorView.backgroundColor = UIColor.blueColor;
            break;
        }
        CASE(@"purple") {
            self.colorView.backgroundColor = UIColor.purpleColor;
            break;
        }
        CASE(@"black") {
            self.colorView.backgroundColor = UIColor.blackColor;
            break;
        }
        CASE(@"white") {
            self.colorView.backgroundColor = UIColor.whiteColor;
            break;
        }
        CASE(@"gray") {
            self.colorView.backgroundColor = UIColor.grayColor;
            break;
        }
        DEFAULT {
            break;
        }
    }
}



- (IBAction)startButtonAction:(id)sender {
    if(self.isRecording == YES) {
        [self cancelRecording];
        self.isRecording = NO;
        self.startButton.backgroundColor = UIColor.grayColor;
    } else {
        [self recordAndRecognizeSpeech];
        self.isRecording = YES;
        self.startButton.backgroundColor = UIColor.redColor;
    }
}

-(void)cancelRecording {
    [self.recognitionTask finish];
    self.recognitionTask = nil;
    
    //stop audio
    [self.request endAudio];
    [self.audioEngine stop];
    [self.audioEngine.inputNode removeTapOnBus:0];
}

@end
