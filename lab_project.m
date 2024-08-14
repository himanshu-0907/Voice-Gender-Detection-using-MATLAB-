clc;
close all;

% Set the desired sample rate
desiredSampleRate = 16000; % Change this to your desired sample rate
fs = 16000;
% Set the recording duration in seconds
recordingDuration = 10; % Change this to your desired recording duration

% Create an audiorecorder object with the desired sample rate
recObj = audiorecorder(desiredSampleRate, 16, 1); % 16 bits per sample, 1 channel (monaural)

% Record audio
disp('Start recording...');
recordblocking(recObj, recordingDuration);
disp('Recording complete.');

% Get the recorded data
audioData = getaudiodata(recObj);

% Plot the recorded audio waveform
t = (0:length(audioData)-1) / recObj.SampleRate;
figure;
plot(t, audioData);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Recorded Audio');

% Play the recorded audio
disp('Playing recorded audio...');
play(recObj);

% Save the recorded audio to a file (optional)
% audiowrite('recorded_audio.wav', audioData, recObj.SampleRate);


%Number of Samples
N = length(audioData);
% Making N to the nearest power of 2
NFFT = 2^nextpow2(N);
%Applying N-point DFT algorithm
Y = fft(audioData,NFFT)/N;

%Generate plot of frequency spectrum
f =fs/2*linspace(0,1,NFFT/2+1);

%plot single-sided amplitude spectrum
figure(2);
stem(f,2*abs(Y(1:NFFT/2+1)));
title('Single-Sided Amplitude Spectrum of y(t)');
xlabel('Frequency (Hz)');
ylabel('|Y(f)|');

% Abs needed since they are complex numbers
Y_mag = abs(Y);
%Finding n(4350) where the threshold frequency is there (i.e. 265 Hz) at
% this sampling frequency of 16000Hz and then finding the frequency 
% corresponding to the dominant peak in this range
[pks, n_dominant_freq] = max(Y_mag(1:4350));
freq = f(n_dominant_freq);

%Finding the peak for human speech signal range i.e. between 80-260 hz
% Predicting whether sound is male or female on the basis of dominant 
% frequency peak
if (freq < 155)
    disp('This is a Male Voice');
elseif (freq>155 && freq<165)
    disp('Overlapping region');
else
    disp('This is a Female Voice');
end
