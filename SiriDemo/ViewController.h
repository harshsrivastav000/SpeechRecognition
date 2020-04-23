//
//  ViewController.h
//  SiriDemo
//
//  Created by Harsh Srivastava on 22/04/20.
//  Copyright © 2020 Harsh Srivastava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>

@interface ViewController : UIViewController<SFSpeechRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;

//Speech
@property (strong, nonatomic) AVAudioEngine * audioEngine;
@property (strong, nonatomic) SFSpeechRecognizer * speechRecognizer;
@property (strong, nonatomic) SFSpeechAudioBufferRecognitionRequest * request;
@property (strong, nonatomic) SFSpeechRecognitionTask * recognitionTask;
@property (nonatomic) BOOL isRecording;

- (IBAction)startButtonAction:(id)sender;

@end

