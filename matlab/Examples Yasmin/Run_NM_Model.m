% Run_NM_Model
% V01-02 14 Sept 2016
%Sample script deomonstrating how to use NM_model

% Two input variables must be defined in your workspace before running the
% simulation:
%   VolCmd - signal correspodning to the coluntary command to the joint
%   TqDisturbance - the distirubance torque applied to the joint

% The simulation generatrs the following outputs and places them in your
% matlab worksapce:

% Set model name to version specific valuie
nmModelName='NM_Model';

TStop=4; % End time of simulation 
deltaT = 0.001; % Time increment for simulation;
T=0:deltaT:TStop; % Time base
T=T(:); 
nSamp=length(T); % number of samples in simulation 

% Define some variables to use as needed 
nullIn=T*0; % For a null input
stepIn= T*0+1; % Step input
stepIn(1:100)=zeros(100,1);
randIn=randn(nSamp,1); % Random input


% Intrinsic Properties
Inertia = 0.005; % Limb inertia
Bintrinsic=5; % Instrisic viscosity 
Kintrinsic=50; %Elastic parameter of intrinsic stiffnes
% Muscle Properties
Kmuscle=1; % Gain of muscle dynamics
epsi=1; % Damping Paramter of muscle dynamics
wn=2*pi; % Natural frequency of muscle dynamics
% Reflex Properties
ReflexDelay=.05;
Kreflex=50; % Gain of reflex stiffness 
% Input signals - change the field signals.values to change the input. 
% Disturbance torquem input
TQdisturbance.time=T;
TQdisturbance.signals.values=randIn;
% Voluntary Command
VolCmd.time=T;
VolCmd.signals.values=nullIn;
% Run simulation

sim(nmModelName)

%% Plot results

plotNM(VolCmd,'VolCmd','', 4,2,1);
% TQdist - disturbance torque 
plotNM(TQdist, 'TQdist','Nm',4,2,2);
set(gca,'ylim',[-1 11]);

plotNM(TQtotal,'Total torque','Nm',4,2,5); 
plotNM(Position,'Position','rad',4,2,3);
plotNM(Velocity,'Velocity','rad/s', 4,2,4);


plotNM(TQelastic,'Elastic torque','Nm',4,2,6);
plotNM(TQmuscle,'Muscle torque','Nm', 4,2,7);
xlabel('Time (S)'); 

plotNM(ReflexActivation,'Reflex Activation','', 4,2,8);
xlabel('Time (S)'); 



